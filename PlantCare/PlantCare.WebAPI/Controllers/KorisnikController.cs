using Microsoft.AspNetCore.Mvc;
using PlantCare.Model;
using PlantCare.Model.Requests;
using PlantCare.Model.SearchObjects;
using PlantCare.Services;

namespace PlantCare.WebAPI.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class KorisnikController : ControllerBase
    {
        private readonly IKorisnikService _service;
        public KorisnikController(IKorisnikService service) => _service = service;

        [HttpGet]
        public ActionResult<PagedResult<Korisnik>> Get([FromQuery] KorisnikSearchObject search)
            => Ok(_service.GetPaged(search));

        [HttpGet("{id}")]
        public ActionResult<Korisnik> GetById(int id)
        {
            var entity = _service.GetById(id);
            if (entity == null) return NotFound();
            return Ok(entity);
        }

        [HttpPost]
        public ActionResult<Korisnik> Create(KorisnikInsertRequest request)
        {
            var created = _service.Insert(request);
            return CreatedAtAction(nameof(GetById), new { id = created.KorisnikId }, created);
        }

        [HttpPut("{id}")]
        public ActionResult<Korisnik> Update(int id, KorisnikUpdateRequest request)
            => Ok(_service.Update(id, request));
    }
}
