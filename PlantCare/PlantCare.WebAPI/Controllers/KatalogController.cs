using Microsoft.AspNetCore.Authorization;
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

        [Authorize(Roles = "Administrator")]
        [HttpPost]
        public override ActionResult<Katalog> Insert([FromBody] KatalogInsertRequest request)
        {
            return base.Insert(request);
        }

        [Authorize(Roles = "Administrator")]
        [HttpPut("{id}")]
        public override ActionResult<Katalog> Update(int id, [FromBody] KatalogUpdateRequest request)
        {
            return base.Update(id, request);
        }

        [Authorize(Roles = "Administrator")]
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
