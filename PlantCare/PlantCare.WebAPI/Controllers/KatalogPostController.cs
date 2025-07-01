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
    public class KatalogPostController : BaseCRUDController<
        KatalogPost,
        KatalogPostSearchObject,
        KatalogPostInsertRequest,
        KatalogPostUpdateRequest>
    {
        public KatalogPostController(IKatalogPostService service)
            : base(service)
        {
        }

        [Authorize(Roles = "Administrator")]
        [HttpPost]
        public override ActionResult<KatalogPost> Insert([FromBody] KatalogPostInsertRequest request)
        {
            return base.Insert(request);
        }

        [Authorize(Roles = "Administrator")]
        [HttpPut("{id}")]
        public override ActionResult<KatalogPost> Update(int id, [FromBody] KatalogPostUpdateRequest request)
        {
            return base.Update(id, request);
        }

        [Authorize(Roles = "Administrator")]
        [HttpDelete("ByKatalog/{katalogId}")]
        public async Task<IActionResult> DeleteByKatalogId(int katalogId)
        {
            var service = (IKatalogPostService)_service;
            await service.DeleteByKatalogIdAsync(katalogId);
            return NoContent();
        }
    }
}
