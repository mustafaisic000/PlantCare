using Microsoft.AspNetCore.Mvc;
using PlantCare.Model;
using PlantCare.Model.Requests;
using PlantCare.Model.SearchObjects;
using PlantCare.Services;

namespace PlantCare.WebAPI.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class KategorijaController : ControllerBase
    {
        private readonly IKategorijaService _service;
        public KategorijaController(IKategorijaService service) => _service = service;

        [HttpGet]
        public ActionResult<PagedResult<Kategorija>> Get([FromQuery] KategorijaSearchObject search)
            => Ok(_service.GetPaged(search));

        [HttpGet("{id}")]
        public ActionResult<Kategorija> GetById(int id)
        {
            var entity = _service.GetById(id);
            if (entity == null) return NotFound();
            return Ok(entity);
        }

        [HttpPost]
        public ActionResult<Kategorija> Create(KategorijaInsertRequest request)
        {
            var created = _service.Insert(request);
            return CreatedAtAction(nameof(GetById), new { id = created.KategorijaId }, created);
        }

        [HttpPut("{id}")]
        public ActionResult<Kategorija> Update(int id, KategorijaUpdateRequest request)
            => Ok(_service.Update(id, request));
    }
}
