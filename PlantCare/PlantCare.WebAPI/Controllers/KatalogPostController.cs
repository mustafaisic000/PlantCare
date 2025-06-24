using Microsoft.AspNetCore.Mvc;
using PlantCare.Model;
using PlantCare.Model.Requests;
using PlantCare.Model.SearchObjects;
using PlantCare.Services;

namespace PlantCare.WebAPI.Controllers
{
    public class KatalogPostController : BaseCRUDController<KatalogPost, KatalogPostSearchObject, KatalogPostInsertRequest, KatalogPostUpdateRequest>
    {
        public KatalogPostController(IKatalogPostService service)
            : base(service)
        {
        }
        [HttpDelete("ByKatalog/{katalogId}")]
        public async Task<IActionResult> DeleteByKatalogId(int katalogId)
        {
            var service = (IKatalogPostService)_service;
            await service.DeleteByKatalogIdAsync(katalogId);
            return NoContent();
        }

    }
}
