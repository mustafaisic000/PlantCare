using MapsterMapper;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Logging;
using PlantCare.Model;
using PlantCare.Model.Requests;
using PlantCare.Model.SearchObjects;
using PlantCare.Services.Database;
using System;
using System.Linq;
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
        public KorisnikService(PlantCareContext context, IMapper mapper, ILogger<KorisnikService> logger)
            : base(context, mapper)
        {
            _logger = logger;
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

        public override Model.Korisnik Insert(KorisnikInsertRequest request)
            => base.Insert(request);

        public override Model.Korisnik Update(int id, KorisnikUpdateRequest request)
            => base.Update(id, request);

        public Model.Korisnik Login(string username, string password)
        {
            var user = Context.Korisnici
                .Include(x => x.Uloga)
                .FirstOrDefault(x => x.KorisnickoIme == username);

            if (user == null || !user.Status)
                return null;

            var hash = GenerateHash(user.LozinkaSalt, password);
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

        public async Task<bool> ResetPasswordByEmail(string korisnickoIme, string email)
        {
            var user = await Context.Korisnici
                .FirstOrDefaultAsync(x => x.KorisnickoIme == korisnickoIme && x.Email == email);

            if (user == null)
                throw new KeyNotFoundException("Korisnik nije pronađen.");

            var newPwd = GenerateRandomPassword(8);
            user.LozinkaSalt = GenerateSalt();
            user.LozinkaHash = GenerateHash(user.LozinkaSalt, newPwd);

            await Context.SaveChangesAsync();

            // TODO: publish newPwd via RabbitMQ / email

            return true;
        }
//helper
        private static string GenerateSalt()
        {
            var buff = new byte[16];
            RandomNumberGenerator.Fill(buff);
            return Convert.ToBase64String(buff);
        }

        private static string GenerateHash(string salt, string pwd)
        {
            var src = Convert.FromBase64String(salt);
            var pb = Encoding.UTF8.GetBytes(pwd);
            var dst = new byte[src.Length + pb.Length];

            Buffer.BlockCopy(src, 0, dst, 0, src.Length);
            Buffer.BlockCopy(pb, 0, dst, src.Length, pb.Length);

            using var sha = SHA256.Create();
            return Convert.ToBase64String(sha.ComputeHash(dst));
        }

        private static string GenerateRandomPassword(int len)
        {
            const string chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";
            return new string(Enumerable
                .Repeat(chars, len)
                .Select(_ => chars[RandomNumberGenerator.GetInt32(chars.Length)])
                .ToArray());
        }
    }
}
