using Microsoft.AspNetCore.Mvc;
using PlantCare.Model;
using PlantCare.Model.Requests;
using PlantCare.Model.SearchObjects;
using PlantCare.Services;

namespace PlantCare.WebAPI.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class SubkategorijaController : ControllerBase
    {
        private readonly ISubkategorijaService _service;
        public SubkategorijaController(ISubkategorijaService service) => _service = service;

        [HttpGet]
        public ActionResult<PagedResult<Subkategorija>> Get([FromQuery] SubkategorijaSearchObject search)
            => Ok(_service.GetPaged(search));

        [HttpGet("{id}")]
        public ActionResult<Subkategorija> GetById(int id)
        {
            var entity = _service.GetById(id);
            if (entity == null) return NotFound();
            return Ok(entity);
        }

        [HttpPost]
        public ActionResult<Subkategorija> Create(SubkategorijaInsertRequest request)
        {
            var created = _service.Insert(request);
            return CreatedAtAction(nameof(GetById), new { id = created.SubkategorijaId }, created);
        }

        [HttpPut("{id}")]
        public ActionResult<Subkategorija> Update(int id, SubkategorijaUpdateRequest request)
            => Ok(_service.Update(id, request));
    }
}
