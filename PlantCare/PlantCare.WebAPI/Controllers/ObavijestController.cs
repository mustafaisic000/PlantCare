using Microsoft.AspNetCore.Mvc;
using PlantCare.Model;
using PlantCare.Model.Requests;
using PlantCare.Model.SearchObjects;
using PlantCare.Services;

namespace PlantCare.WebAPI.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class ObavijestController : BaseCRUDController<
        Obavijest,
        ObavijestSearchObject,
        ObavijestInsertRequest,
        ObavijestUpdateRequest>
    {
        private readonly IObavijestService _obavijestService;

        public ObavijestController(IObavijestService service)
            : base(service)
        {
            _obavijestService = service;
        }

        [HttpDelete("{id}")]
        public IActionResult Delete(int id)
        {
            try
            {
                _obavijestService.Delete(id);
                return NoContent(); 
            }
            catch (Exception ex)
            {
                return NotFound(new { message = ex.Message });
            }
        }
    }
}
