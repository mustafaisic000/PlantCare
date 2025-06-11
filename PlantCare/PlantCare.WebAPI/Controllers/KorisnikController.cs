using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using PlantCare.Model;
using PlantCare.Model.Requests;
using PlantCare.Model.SearchObjects;
using PlantCare.Services;

namespace PlantCare.WebAPI.Controllers
{
    public class KorisnikController : BaseCRUDController<Korisnik, KorisnikSearchObject, KorisnikInsertRequest, KorisnikUpdateRequest>
    {
        protected IKorisnikService _service;
        public KorisnikController(IKorisnikService service)
            : base(service)
        {
           _service = service;
        }
        [HttpPost("login")]
        [AllowAnonymous]
        public Model.Korisnik Login(string username, string password)
        {
            if (_service == null)
            {
                throw new Exception("Servis nije inicijalizovan.");
            }
            return _service.Login(username, password);
        }
    }
}
