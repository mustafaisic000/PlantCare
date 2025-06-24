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

        [HttpDelete("{id}")]
        public IActionResult Delete(int id)
        {
            try
            {
                _komentarService.Delete(id);
                return NoContent(); 
            }
            catch (Exception ex)
            {
                return NotFound(new { message = ex.Message });
            }
        }
    }
}
