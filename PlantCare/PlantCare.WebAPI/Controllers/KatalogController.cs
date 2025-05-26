using Microsoft.AspNetCore.Mvc;
using PlantCare.Model;
using PlantCare.Model.Requests;
using PlantCare.Model.SearchObjects;
using PlantCare.Services;

namespace PlantCare.WebAPI.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class KatalogController : ControllerBase
    {
        private readonly IKatalogService _service;
        public KatalogController(IKatalogService service) => _service = service;

        [HttpGet]
        public ActionResult<PagedResult<Katalog>> Get([FromQuery] KatalogSearchObject search)
            => Ok(_service.GetPaged(search));

        [HttpGet("{id}")]
        public ActionResult<Katalog> GetById(int id)
        {
            var entity = _service.GetById(id);
            if (entity == null) return NotFound();
            return Ok(entity);
        }

        [HttpPost]
        public ActionResult<Katalog> Create(KatalogInsertRequest request)
        {
            var created = _service.Insert(request);
            return CreatedAtAction(nameof(GetById), new { id = created.KatalogId }, created);
        }

        [HttpPut("{id}")]
        public ActionResult<Katalog> Update(int id, KatalogUpdateRequest request)
            => Ok(_service.Update(id, request));
    }
}
