using PlantCare.Model;
using PlantCare.Model.Requests;
using PlantCare.Model.SearchObjects;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PlantCare.Services;

public interface IKorisnikService: ICRUDService<Korisnik,KorisnikSearchObject,KorisnikInsertRequest,KorisnikUpdateRequest>
{
    Model.Korisnik Login(string username, string password);
    Task<Korisnik> UpdateMobile(int id, KorisnikMobileUpdateRequest request);
    Task<bool> ResetPasswordByEmail(string email);
    Task<bool> ResetPasswordByAdmin(int korisnikId);
    Task ValidateUsernameEmail(string korisnickoIme, string email, int? ignoreId = null);
    void SoftDelete(int id);
    Task<Model.Korisnik> PromoteToPremiumAsync(int korisnikId);
}
