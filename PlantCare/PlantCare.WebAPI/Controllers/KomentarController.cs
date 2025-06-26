using Microsoft.AspNetCore.Mvc;
using PlantCare.Model;
using PlantCare.Model.Requests;
using PlantCare.Model.SearchObjects;
using PlantCare.Services;

namespace PlantCare.WebAPI.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class KomentarController : BaseCRUDController<
        Komentar,
        KomentarSearchObject,
        KomentarInsertRequest,
        KomentarUpdateRequest>
    {
        private readonly IKomentarService _komentarService;

        public KomentarController(IKomentarService service)
            : base(service)
        {
            _komentarService = service;
        }

        [HttpDelete("{komentarId}/korisnik/{korisnikId}/uloga/{ulogaId}")]
        public IActionResult Delete(int komentarId, int korisnikId, int ulogaId)
        {
            try
            {
                _komentarService.Delete(komentarId, korisnikId, ulogaId);
                return NoContent();
            }
            catch (Exception ex)
            {
                return BadRequest(new { message = ex.Message });
            }
        }


    }
}
