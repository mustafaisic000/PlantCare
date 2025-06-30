using Azure.Core;
using MapsterMapper;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Logging;
using PlantCare.Model;
using PlantCare.Model.Requests;
using PlantCare.Model.SearchObjects;
using PlantCare.Services.Database;
using System;
using System.Linq;
using System.Net.Mail;
using System.Security.Cryptography;
using System.Text;
using System.Threading.Tasks;

namespace PlantCare.Services
{
    public class KorisnikService
        : BaseCRUDService<Model.Korisnik,
                          KorisnikSearchObject,
                          Database.Korisnik,
                          KorisnikInsertRequest,
                          KorisnikUpdateRequest>,
          IKorisnikService
    {
        ILogger<KorisnikService> _logger;
        private readonly IEmailService _emailService;
        private readonly INotifikacijaService _notificationservice;
        public KorisnikService(PlantCareContext context, IMapper mapper, ILogger<KorisnikService> logger, INotifikacijaService notificationservice, IEmailService emailService)
            : base(context, mapper)
        {
            _logger = logger;
            _emailService = emailService;
            _notificationservice =notificationservice;
        }

        protected override IQueryable<Database.Korisnik> AddFilter(
            KorisnikSearchObject search,
            IQueryable<Database.Korisnik> query)
        {
            query = base.AddFilter(search, query);

            if (!string.IsNullOrWhiteSpace(search.ImeGTE))
                query = query.Where(x => x.Ime.Contains(search.ImeGTE));

            if (!string.IsNullOrWhiteSpace(search.PrezimeGTE))
                query = query.Where(x => x.Prezime.Contains(search.PrezimeGTE));

            if (!string.IsNullOrWhiteSpace(search.Email))
                query = query.Where(x => x.Email == search.Email);

            if (!string.IsNullOrWhiteSpace(search.KorisnickoImeGTE))
                query = query.Where(x => x.KorisnickoIme.Contains(search.KorisnickoImeGTE));

            if (search.UlogaId.HasValue)
                query = query.Where(x => x.UlogaId == search.UlogaId);

            if (search.Status.HasValue)
                query = query.Where(x => x.Status == search.Status.Value);

            if (search.IncludeUloga == true)
            {
                query = query.Include(x => x.Uloga);
            }

            return query;
        }

        protected override void BeforeInsert(
            KorisnikInsertRequest request,
            Database.Korisnik entity)
        {
            _logger.LogInformation($"Dodavanje korisnika : {entity.KorisnickoIme}");
            if (request.Lozinka != request.LozinkaPotvrda)
                throw new InvalidOperationException("Lozinka i potvrda lozinke se ne poklapaju.");

            entity.LozinkaSalt = GenerateSalt();
            entity.LozinkaHash = GenerateHash(entity.LozinkaSalt, request.Lozinka);
            entity.Status = true;
        }

        public override void BeforeUpdate(
            KorisnikUpdateRequest request,
            Database.Korisnik entity)
        {
            if (!string.IsNullOrWhiteSpace(request.Lozinka))
            {
                if (request.Lozinka != request.LozinkaPotvrda)
                    throw new InvalidOperationException("Lozinka i potvrda lozinke se ne poklapaju.");

                entity.LozinkaSalt = GenerateSalt();
                entity.LozinkaHash = GenerateHash(entity.LozinkaSalt, request.Lozinka);
            }
        }
        public Model.Korisnik Login(string username, string password)
        {
            var user = Context.Korisnici
                .Include(x => x.Uloga)
                .FirstOrDefault(x => x.KorisnickoIme == username);

            if (user == null || !user.Status)
                return null;

            var hash = GenerateHash(user.LozinkaSalt, password);
            _logger.LogInformation("Expected Hash: " + user.LozinkaHash);
            _logger.LogInformation("Generated Hash: " + GenerateHash(user.LozinkaSalt, password));
            if (hash != user.LozinkaHash)
                return null;
          
            return Mapper.Map<Model.Korisnik>(user);
          
        }

        


        public Model.Korisnik UpdateMobile(int id, KorisnikMobileUpdateRequest req)
        {
            var user = Context.Korisnici.Find(id);
            if (user == null)
                throw new KeyNotFoundException("Korisnik nije pronađen.");

            user.Ime = req.Ime;
            user.Prezime = req.Prezime;
            user.Email = req.Email;
            user.Telefon = req.Telefon;

            Context.SaveChanges();
            return Mapper.Map<Model.Korisnik>(user);
        }

        public async Task<bool> ResetPasswordByEmail(string email)
        {
            var user = await Context.Korisnici.FirstOrDefaultAsync(x => x.Email == email && x.Status);

            if (user == null)
                return false;

            var newPwd = GenerateRandomPassword(8);
            user.LozinkaSalt = GenerateSalt();
            user.LozinkaHash = GenerateHash(user.LozinkaSalt, newPwd);
            await Context.SaveChangesAsync();

            var emailObj = new Notifier
            {
                Email = user.Email!,
                Datum = DateTime.Now,
                Naslov = "Reset lozinke - Zeleni kutak",
                Tekst = $"Poštovani {user.Ime} {user.Prezime},\n\n" +
                        $"Vaša nova lozinka je: {newPwd}\n\n" +
                        "Preporučujemo da je odmah promijenite nakon prijave.\n\n" +
                        "Srdačan pozdrav,\nZeleni kutak tim"
            };

            _emailService.SendingObject(emailObj);
            return true;
        }

        public async Task<bool> ResetPasswordByAdmin(int id)
        {
            var user = await Context.Korisnici.FindAsync(id);
            if (user == null || !user.Status)
                return false;

            var newPwd = GenerateRandomPassword(8);
            user.LozinkaSalt = GenerateSalt();
            user.LozinkaHash = GenerateHash(user.LozinkaSalt, newPwd);
            await Context.SaveChangesAsync();

            var emailObj = new Notifier
            {
                Email = user.Email!,
                Datum = DateTime.Now,
                Naslov = "Reset lozinke (admin) - Zeleni kutak",
                Tekst = $"Poštovani {user.Ime} {user.Prezime},\n\n" +
                        $"Administrator vam je resetovao lozinku. Nova lozinka je: {newPwd}\n\n" +
                        "Preporučujemo da je odmah promijenite nakon prijave.\n\n" +
                        "Srdačan pozdrav,\nZeleni kutak tim"
            };

            _emailService.SendingObject(emailObj);
            return true;
        }

        public override Model.Korisnik Insert(KorisnikInsertRequest request)
        {
            // Prvo koristi baznu metodu koja poziva BeforeInsert i mapira entitet
            var entity = base.Insert(request);

            // Napravi notifikaciju
            var insertObj = new NotifikacijaInsertRequest
            {
                KorisnikId = entity.KorisnikId,
                Naslov = "Novi korisnik",
                Sadrzaj = $"{entity.KorisnickoIme} se pridružio/la platformi.",
                KoPrima = "Desktop"
            };
            _notificationservice.Insert(insertObj);

            // Pošalji email
            var emailObj = new Notifier
            {
                Email = entity.Email!,
                Datum = DateTime.Now,
                Naslov = "Dobrodošli na Zeleni kutak!",
                Tekst = $"Poštovani {entity.Ime} {entity.Prezime},\n\n" +
                        "Uspješno ste kreirali nalog na aplikaciji Zeleni kutak.\n" +
                        "Hvala što ste se registrovali!\n\n" +
                        "Srdačan pozdrav,\nZeleni kutak tim"
            };
            _emailService.SendingObject(emailObj);

            return entity;
        }






        //helper
        private static string GenerateSalt()
        {
            var buff = new byte[16];
            RandomNumberGenerator.Fill(buff);
            return Convert.ToBase64String(buff);
        }

        public static string GenerateHash(string salt, string password)
        {
            byte[] src = Convert.FromBase64String(salt);
            byte[] bytes = Encoding.Unicode.GetBytes(password);
            byte[] dst = new byte[src.Length + bytes.Length];

            Buffer.BlockCopy(src, 0, dst, 0, src.Length);
            Buffer.BlockCopy(bytes, 0, dst, src.Length, bytes.Length);

            using HashAlgorithm algorithm = HashAlgorithm.Create("SHA1");
            byte[] inArray = algorithm.ComputeHash(dst);
            return Convert.ToBase64String(inArray);
        }

        private static string GenerateRandomPassword(int len)
        {
            const string chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";
            return new string(Enumerable
                .Repeat(chars, len)
                .Select(_ => chars[RandomNumberGenerator.GetInt32(chars.Length)])
                .ToArray());
        }

        public void SoftDelete(int id)
        {
            var korisnik = Context.Korisnici.Find(id);
            if (korisnik == null)
                throw new Exception("Korisnik nije pronađen.");

            korisnik.Status = false;
            Context.SaveChanges();
        }

      

    }
}
