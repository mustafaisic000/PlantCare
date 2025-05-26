using Microsoft.AspNetCore.Mvc;
using PlantCare.Model;
using PlantCare.Model.Requests;
using PlantCare.Model.SearchObjects;
using PlantCare.Services;

namespace PlantCare.WebAPI.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class ObavijestController : ControllerBase
    {
        private readonly IObavijestService _service;
        public ObavijestController(IObavijestService service) => _service = service;

        [HttpGet]
        public ActionResult<PagedResult<Obavijest>> Get([FromQuery] ObavijestSearchObject search)
            => Ok(_service.GetPaged(search));

        [HttpGet("{id}")]
        public ActionResult<Obavijest> GetById(int id)
        {
            var entity = _service.GetById(id);
            if (entity == null) return NotFound();
            return Ok(entity);
        }

        [HttpPost]
        public ActionResult<Obavijest> Create(ObavijestInsertRequest request)
        {
            var created = _service.Insert(request);
            return CreatedAtAction(nameof(GetById), new { id = created.ObavijestId }, created);
        }

        [HttpPut("{id}")]
        public ActionResult<Obavijest> Update(int id, ObavijestUpdateRequest request)
            => Ok(_service.Update(id, request));
    }
}
