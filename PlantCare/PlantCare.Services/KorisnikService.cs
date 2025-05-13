using MapsterMapper;
using Microsoft.EntityFrameworkCore;
using PlantCare.Model;
using PlantCare.Model.Requests;
using PlantCare.Model.SearchObjects;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Security.Cryptography;
using System.Text;
using System.Threading.Tasks;

namespace PlantCare.Services;

public class KorisnikService : BaseCRUDService<Model.Korisnik, KorisnikSearchObject, Database.Korisnik, KorisnikInsertRequest, KorisnikUpdateRequest>, IKorisnikService
{

  //  private readonly IEmailService _emailService; -- kasnije dodati preko rabbitMQ
    public KorisnikService(Database.PlantCareContext context, Mapper mapper) : base(context, mapper)
    {

    }

    //pretraga, filter
    protected override IQueryable<Database.Korisnik> AddFilter(KorisnikSearchObject searchObject, IQueryable<Database.Korisnik> query)
    {
        query = base.AddFilter(searchObject, query);

        if (searchObject.IncludeUloga)
            query = query.Include(x => x.Uloga);

        if (!string.IsNullOrWhiteSpace(searchObject?.Ime))
            query = query.Where(x => x.Ime.Contains(searchObject.Ime));

        if (!string.IsNullOrWhiteSpace(searchObject?.Prezime))
            query = query.Where(x => x.Prezime.Contains(searchObject.Prezime));

        if (!string.IsNullOrWhiteSpace(searchObject?.Email))
            query = query.Where(x => x.Email == searchObject.Email);

        if (!string.IsNullOrWhiteSpace(searchObject?.KorisnickoIme))
            query = query.Where(x => x.KorisnickoIme.Contains(searchObject.KorisnickoIme));

        if (searchObject.UlogaId.HasValue)
            query = query.Where(x => x.UlogaId == searchObject.UlogaId.Value);

        if (searchObject.Status.HasValue)
            query = query.Where(x => x.Status == searchObject.Status.Value);

        return query;
    }

    protected override void BeforeInsert(KorisnikInsertRequest request, Database.Korisnik entity)
    {
        if (request.Lozinka != request.LozinkaPotvrda)
            throw new InvalidOperationException("Lozinka i potvrda lozinke se ne poklapaju.");
        entity.LozinkaSalt = GenerishiSalt();
        entity.LozinkaHash = GenerisiHash(entity.LozinkaSalt, request.Lozinka);
        entity.Status = true;
    }

    private static string GenerishiSalt()
    {
        var buff = new byte[16];
        RandomNumberGenerator.Fill(buff);
        return Convert.ToBase64String(buff);
    }

    private static string GenerisiHash(string salt, string pwd)
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

    Korisnik ICRUDService<Korisnik, KorisnikSearchObject, KorisnikInsertRequest, KorisnikUpdateRequest>.Insert(KorisnikInsertRequest request)
    {
        throw new NotImplementedException();
    }

    Korisnik IKorisnikService.Login(string username, string password)
    {
        throw new NotImplementedException();
    }

    Task<bool> IKorisnikService.ResetPasswordByEmail(string korisnickoIme, string email)
    {
        throw new NotImplementedException();
    }

    Korisnik ICRUDService<Korisnik, KorisnikSearchObject, KorisnikInsertRequest, KorisnikUpdateRequest>.Update(int id, KorisnikUpdateRequest request)
    {
        throw new NotImplementedException();
    }

    Korisnik IKorisnikService.UpdateMobile(int id, KorisnikMobileUpdateRequest request)
    {
        throw new NotImplementedException();
    }
}
