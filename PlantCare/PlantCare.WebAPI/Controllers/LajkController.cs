using Microsoft.AspNetCore.Mvc;
using PlantCare.Model;
using PlantCare.Model.Requests;
using PlantCare.Model.SearchObjects;
using PlantCare.Services;

namespace PlantCare.WebAPI.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class LajkController : BaseCRUDController<
        Lajk,
        LajkSearchObject,
        LajkInsertRequest,
        LajkUpdateRequest>
    {
        private readonly ILajkService _lajkService;

        public LajkController(ILajkService service)
            : base(service)
        {
            _lajkService = service;
        }

        [HttpDelete("{id}")]
        public IActionResult Delete(int id)
        {
            try
            {
                _lajkService.Delete(id);
                return NoContent(); 
            }
            catch (Exception ex)
            {
                return NotFound(new { message = ex.Message });
            }
        }
    }
}
