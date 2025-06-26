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


        [HttpDelete("{lajkId}/korisnik/{korisnikId}")]
        public IActionResult Delete(int lajkId, int korisnikId)
        {
            try
            {
                _lajkService.Delete(lajkId, korisnikId);
                return NoContent();
            }
            catch (Exception ex)
            {
                return BadRequest(new { message = ex.Message });
            }
        }

        [HttpGet("count/post/{postId}")]
        public ActionResult<int> GetLajkCountByPost(int postId)
        {
            return _lajkService.GetLajkCountByPost(postId);
        }
    }
}
