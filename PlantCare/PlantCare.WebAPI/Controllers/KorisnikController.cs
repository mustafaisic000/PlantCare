using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using PlantCare.Model;
using PlantCare.Model.Requests;
using PlantCare.Model.SearchObjects;
using PlantCare.Services;
using System.Text;

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

        [HttpGet("Authenticate")]
        [AllowAnonymous]
        public Korisnik Authenticate()
        {
            string authorization = HttpContext.Request.Headers["Authorization"];
            string encodedHeader = authorization["Basic ".Length..].Trim();
            Encoding encoding = Encoding.GetEncoding("iso-8859-1");
            string usernamePassword = encoding.GetString(Convert.FromBase64String(encodedHeader));
            int seperatorIndex = usernamePassword.IndexOf(':');

            return _service.Login(
                usernamePassword.Substring(0, seperatorIndex),
                usernamePassword[(seperatorIndex + 1)..]
            );
        }


    }
}
