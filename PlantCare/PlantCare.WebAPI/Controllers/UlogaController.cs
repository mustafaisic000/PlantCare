using Microsoft.AspNetCore.Mvc;
using PlantCare.Model;
using PlantCare.Model.Requests;
using PlantCare.Model.SearchObjects;
using PlantCare.Services;

namespace PlantCare.WebAPI.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class UlogaController : ControllerBase
    {
        private readonly IUlogaService _service;
        public UlogaController(IUlogaService service) => _service = service;

        /// GET /api/uloga?Naziv=...
        [HttpGet]
        public ActionResult<PagedResult<Uloga>> Get([FromQuery] UlogaSearchObject search)
        {
            var result = _service.GetPaged(search);
            return Ok(result);
        }

        /// GET /api/uloga/{id}
        [HttpGet("{id}")]
        public ActionResult<Uloga> GetById(int id)
        {
            var uloga = _service.GetById(id);
            if (uloga == null) return NotFound();
            return Ok(uloga);
        }

        /// POST /api/uloga
        [HttpPost]
        public ActionResult<Uloga> Create(UlogaInsertRequest request)
        {
            var created = _service.Insert(request);
            // returns 201 Created plus a Location header
            return CreatedAtAction(nameof(GetById), new { id = created.UlogaId }, created);
        }

        /// PUT /api/uloga/{id}
        [HttpPut("{id}")]
        public ActionResult<Uloga> Update(int id, UlogaUpdateRequest request)
        {
            var updated = _service.Update(id, request);
            return Ok(updated);
        }
    }
}
