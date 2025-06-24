using Microsoft.AspNetCore.Mvc;
using PlantCare.Model;
using PlantCare.Model.Requests;
using PlantCare.Model.SearchObjects;
using PlantCare.Services;

namespace PlantCare.WebAPI.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class KatalogController : BaseCRUDController<
        Katalog,
        KatalogSearchObject,
        KatalogInsertRequest,
        KatalogUpdateRequest>
    {
        private readonly IKatalogService _katalogService;

        public KatalogController(IKatalogService service)
            : base(service)
        {
            _katalogService = service;
        }

        [HttpDelete("{id}")]
        public IActionResult Delete(int id)
        {
            try
            {
                _katalogService.Delete(id);
                return NoContent(); 
            }
            catch (Exception ex)
            {
                return NotFound(new { message = ex.Message });
            }
        }
    }
}
