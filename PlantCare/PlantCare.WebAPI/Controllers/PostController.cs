using Microsoft.AspNetCore.Mvc;
using PlantCare.Model;
using PlantCare.Model.Requests;
using PlantCare.Model.SearchObjects;
using PlantCare.Services;

namespace PlantCare.WebAPI.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class PostController : BaseCRUDController<
        Post,
        PostSearchObject,
        PostInsertRequest,
        PostUpdateRequest>
    {
        private readonly IPostService _postService;

        public PostController(IPostService service)
            : base(service)
        {
            _postService = service;
        }

        [HttpPatch("{id}/soft-delete")]
        public IActionResult SoftDelete(int id)
        {
            try
            {
                _postService.SoftDelete(id);
                return Ok(new { message = "Post je deaktiviran (soft deleted)." });
            }
            catch (Exception ex)
            {
                return NotFound(new { message = ex.Message });
            }
        }

        [HttpGet("recommend/{korisnikId}")]
        public ActionResult<List<Post>> Recommend(int korisnikId, [FromQuery] bool? premium = null)
        {
            var result = _postService.Recommend(korisnikId, premium);
            return Ok(result);
        }


    }
}
