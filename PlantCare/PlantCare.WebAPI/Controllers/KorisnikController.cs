using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Identity.Data;
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

        [HttpPatch("{id}/soft-delete")]
        public IActionResult SoftDelete(int id)
        {
            try
            {
                _service.SoftDelete(id);
                return Ok(new { message = "Korisnik je deaktiviran (soft deleted)." });
            }
            catch (Exception ex)
            {
                return NotFound(new { message = ex.Message });
            }
        }
        [HttpPost]
        [AllowAnonymous]
        public override ActionResult<Korisnik> Insert([FromBody] KorisnikInsertRequest request)
        {
            var created = _service.Insert(request);
            return Ok(created);
        }

        [HttpPost("reset-password-by-email")]
        [AllowAnonymous]
        public async Task<IActionResult> ResetPasswordByEmail([FromBody] string email)
        {
            var result = await _service.ResetPasswordByEmail(email);
            if (!result)
                return BadRequest("Korisnik nije pronađen.");
            return Ok("Nova lozinka je poslana na vaš email.");
        }

        [HttpPatch("{id}/reset-password")]
        public async Task<IActionResult> ResetPasswordByAdmin(int id)
        {
            var result = await _service.ResetPasswordByAdmin(id);
            if (!result)
                return NotFound("Korisnik nije pronađen.");
            return Ok("Nova lozinka je poslana korisniku na email.");
        }





    }
}
