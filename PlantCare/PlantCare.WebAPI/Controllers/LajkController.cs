using Microsoft.AspNetCore.Mvc;
using PlantCare.Model;
using PlantCare.Model.Requests;
using PlantCare.Model.SearchObjects;
using PlantCare.Services;

namespace PlantCare.WebAPI.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class LajkController : ControllerBase
    {
        private readonly ILajkService _service;
        public LajkController(ILajkService service) => _service = service;

        [HttpGet]
        public ActionResult<PagedResult<Lajk>> Get([FromQuery] LajkSearchObject search)
            => Ok(_service.GetPaged(search));

        [HttpGet("{id}")]
        public ActionResult<Lajk> GetById(int id)
        {
            var entity = _service.GetById(id);
            if (entity == null) return NotFound();
            return Ok(entity);
        }

        [HttpPost]
        public ActionResult<Lajk> Create(LajkInsertRequest request)
        {
            var created = _service.Insert(request);
            return CreatedAtAction(nameof(GetById), new { id = created.LajkId }, created);
        }

        [HttpPut("{id}")]
        public ActionResult<Lajk> Update(int id, LajkUpdateRequest request)
            => Ok(_service.Update(id, request));
    }
}
