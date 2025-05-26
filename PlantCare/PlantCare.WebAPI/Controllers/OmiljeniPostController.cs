using Microsoft.AspNetCore.Mvc;
using PlantCare.Model;
using PlantCare.Model.Requests;
using PlantCare.Model.SearchObjects;
using PlantCare.Services;

namespace PlantCare.WebAPI.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class OmiljeniPostController : ControllerBase
    {
        private readonly IOmiljeniPostService _service;
        public OmiljeniPostController(IOmiljeniPostService service) => _service = service;

        [HttpGet]
        public ActionResult<PagedResult<OmiljeniPost>> Get([FromQuery] OmiljeniPostSearchObject search)
            => Ok(_service.GetPaged(search));

        [HttpGet("{id}")]
        public ActionResult<OmiljeniPost> GetById(int id)
        {
            var entity = _service.GetById(id);
            if (entity == null) return NotFound();
            return Ok(entity);
        }

        [HttpPost]
        public ActionResult<OmiljeniPost> Create(OmiljeniPostInsertRequest request)
        {
            var created = _service.Insert(request);
            return CreatedAtAction(nameof(GetById), new { id = created.OmiljeniPostId }, created);
        }

        [HttpPut("{id}")]
        public ActionResult<OmiljeniPost> Update(int id, OmiljeniPostUpdateRequest request)
            => Ok(_service.Update(id, request));
    }
}
