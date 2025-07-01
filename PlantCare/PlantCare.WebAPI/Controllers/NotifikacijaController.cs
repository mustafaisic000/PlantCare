using Microsoft.AspNetCore.Mvc;
using PlantCare.Model;
using PlantCare.Model.Requests;
using PlantCare.Model.SearchObjects;
using PlantCare.Services;

namespace PlantCare.WebAPI.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class NotifikacijaController : BaseCRUDController<
        Notifikacija,
        NotifikacijaSearchObject,
        NotifikacijaInsertRequest,
        NotifikacijaUpdateRequest>
    {
        private readonly INotifikacijaService _notifikacijaService;

        public NotifikacijaController(INotifikacijaService service)
            : base(service)
        {
            _notifikacijaService = service;
        }

        [HttpDelete("{id}")]
        public IActionResult Delete(int id)
        {
            try
            {
                _notifikacijaService.Delete(id);
                return NoContent(); // 204
            }
            catch (Exception ex)
            {
                return NotFound(new { message = ex.Message });
            }
        }

        [HttpPatch("{id}/mark-as-read")]
        public IActionResult MarkAsRead(int id)
        {
            try
            {
                _notifikacijaService.MarkAsRead(id);
                return Ok();
            }
            catch (Exception ex)
            {
                return NotFound(new { message = ex.Message });
            }
        }

    }
}
