using Microsoft.AspNetCore.Mvc;
using PlantCare.Model;
using PlantCare.Model.Requests;
using PlantCare.Model.SearchObjects;
using PlantCare.Services;

namespace PlantCare.WebAPI.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class SubkategorijeController : BaseCRUDController<
        Subkategorija,
        SubkategorijaSearchObject,
        SubkategorijaInsertRequest,
        SubkategorijaUpdateRequest>
    {
        private readonly ISubkategorijaService _subkategorijaService;

        public SubkategorijeController(ISubkategorijaService service)
            : base(service)
        {
            _subkategorijaService = service;
        }

        [HttpDelete("{id}")]
        public IActionResult Delete(int id)
        {
            try
            {
                _subkategorijaService.Delete(id);
                return NoContent();
            }
            catch (Exception ex)
            {
                return BadRequest(new { message = ex.Message });
            }
        }
    }
}
