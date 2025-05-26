using Microsoft.AspNetCore.Mvc;
using PlantCare.Model;
using PlantCare.Model.Requests;
using PlantCare.Model.SearchObjects;
using PlantCare.Services;

namespace PlantCare.WebAPI.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class NotifikacijaController : ControllerBase
    {
        private readonly INotifikacijaService _service;
        public NotifikacijaController(INotifikacijaService service) => _service = service;

        [HttpGet]
        public ActionResult<PagedResult<Notifikacija>> Get([FromQuery] NotifikacijaSearchObject search)
            => Ok(_service.GetPaged(search));

        [HttpGet("{id}")]
        public ActionResult<Notifikacija> GetById(int id)
        {
            var entity = _service.GetById(id);
            if (entity == null) return NotFound();
            return Ok(entity);
        }

        [HttpPost]
        public ActionResult<Notifikacija> Create(NotifikacijaInsertRequest request)
        {
            var created = _service.Insert(request);
            return CreatedAtAction(nameof(GetById), new { id = created.NotifikacijaId }, created);
        }

        [HttpPut("{id}")]
        public ActionResult<Notifikacija> Update(int id, NotifikacijaUpdateRequest request)
            => Ok(_service.Update(id, request));
    }
}
