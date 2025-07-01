using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using PlantCare.Model;
using PlantCare.Model.Requests;
using PlantCare.Model.SearchObjects;
using PlantCare.Services;

namespace PlantCare.WebAPI.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class KategorijaController : BaseCRUDController<
        Kategorija,
        KategorijaSearchObject,
        KategorijaInsertRequest,
        KategorijaUpdateRequest>
    {
        private readonly IKategorijaService _kategorijaService;

        public KategorijaController(IKategorijaService service)
             : base(service)
        {
            _kategorijaService = service;
        }

        [Authorize(Roles = "Administrator")]
        [HttpPost]
        public override ActionResult<Kategorija> Insert([FromBody] KategorijaInsertRequest request)
        {
            return base.Insert(request);
        }

        [Authorize(Roles = "Administrator")]
        [HttpPut("{id}")]
        public override ActionResult<Kategorija> Update(int id, [FromBody] KategorijaUpdateRequest request)
        {
            return base.Update(id, request);
        }

        [Authorize(Roles = "Administrator")]
        [HttpDelete("{id}")]
        public IActionResult Delete(int id)
        {
            try
            {
                _kategorijaService.Delete(id);
                return NoContent();
            }
            catch (Exception ex)
            {
                return BadRequest(new { message = ex.Message });
            }
        }
    }
}
