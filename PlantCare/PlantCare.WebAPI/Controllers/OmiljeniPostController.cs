using Microsoft.AspNetCore.Mvc;
using PlantCare.Model;
using PlantCare.Model.Requests;
using PlantCare.Model.SearchObjects;
using PlantCare.Services;

namespace PlantCare.WebAPI.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class OmiljeniPostController : BaseCRUDController<
        OmiljeniPost,
        OmiljeniPostSearchObject,
        OmiljeniPostInsertRequest,
        OmiljeniPostUpdateRequest>
    {
        private readonly IOmiljeniPostService _omiljeniPostService;

        public OmiljeniPostController(IOmiljeniPostService service)
            : base(service)
        {
            _omiljeniPostService = service;
        }

        [HttpDelete("{id}")]
        public IActionResult Delete(int id)
        {
            try
            {
                _omiljeniPostService.Delete(id);
                return NoContent(); 
            }
            catch (Exception ex)
            {
                return NotFound(new { message = ex.Message });
            }
        }
    }
}
