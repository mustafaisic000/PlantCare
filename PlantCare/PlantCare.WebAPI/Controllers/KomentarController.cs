using Microsoft.AspNetCore.Mvc;
using PlantCare.Model;
using PlantCare.Model.Requests;
using PlantCare.Model.SearchObjects;
using PlantCare.Services;

namespace PlantCare.WebAPI.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class KomentarController : ControllerBase
    {
        private readonly IKomentarService _service;
        public KomentarController(IKomentarService service) => _service = service;

        [HttpGet]
        public ActionResult<PagedResult<Komentar>> Get([FromQuery] KomentarSearchObject search)
            => Ok(_service.GetPaged(search));

        [HttpGet("{id}")]
        public ActionResult<Komentar> GetById(int id)
        {
            var entity = _service.GetById(id);
            if (entity == null) return NotFound();
            return Ok(entity);
        }

        [HttpPost]
        public ActionResult<Komentar> Create(KomentarInsertRequest request)
        {
            var created = _service.Insert(request);
            return CreatedAtAction(nameof(GetById), new { id = created.KomentarId }, created);
        }

        [HttpPut("{id}")]
        public ActionResult<Komentar> Update(int id, KomentarUpdateRequest request)
            => Ok(_service.Update(id, request));
    }
}
