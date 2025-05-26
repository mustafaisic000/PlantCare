using Microsoft.AspNetCore.Mvc;
using PlantCare.Model;
using PlantCare.Model.Requests;
using PlantCare.Model.SearchObjects;
using PlantCare.Services;

namespace PlantCare.WebAPI.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class KatalogPostController : ControllerBase
    {
        private readonly IKatalogPostService _service;
        public KatalogPostController(IKatalogPostService service) => _service = service;

        [HttpGet]
        public ActionResult<PagedResult<KatalogPost>> Get([FromQuery] KatalogPostSearchObject search)
            => Ok(_service.GetPaged(search));

        [HttpGet("{id}")]
        public ActionResult<KatalogPost> GetById(int id)
        {
            var entity = _service.GetById(id);
            if (entity == null) return NotFound();
            return Ok(entity);
        }

        [HttpPost]
        public ActionResult<KatalogPost> Create(KatalogPostInsertRequest request)
        {
            var created = _service.Insert(request);
            return CreatedAtAction(nameof(GetById), new { id = created.KatalogPostId }, created);
        }

        [HttpPut("{id}")]
        public ActionResult<KatalogPost> Update(int id, KatalogPostUpdateRequest request)
            => Ok(_service.Update(id, request));
    }
}
