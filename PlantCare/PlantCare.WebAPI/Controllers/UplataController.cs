using Microsoft.AspNetCore.Mvc;
using PlantCare.Model;
using PlantCare.Model.Requests;
using PlantCare.Model.SearchObjects;
using PlantCare.Services;

namespace PlantCare.WebAPI.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class UplataController : ControllerBase
    {
        private readonly IUplataService _service;
        public UplataController(IUplataService service) => _service = service;

        [HttpGet]
        public ActionResult<PagedResult<Uplata>> Get([FromQuery] UplataSearchObject search)
            => Ok(_service.GetPaged(search));

        [HttpGet("{id}")]
        public ActionResult<Uplata> GetById(int id)
        {
            var entity = _service.GetById(id);
            if (entity == null) return NotFound();
            return Ok(entity);
        }

        [HttpPost]
        public ActionResult<Uplata> Create(UplataInsertRequest request)
        {
            var created = _service.Insert(request);
            return CreatedAtAction(nameof(GetById), new { id = created.UplataId }, created);
        }

        [HttpPut("{id}")]
        public ActionResult<Uplata> Update(int id, UplataUpdateRequest request)
            => Ok(_service.Update(id, request));
    }
}
