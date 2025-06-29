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
    public class SubkategorijeController : BaseCRUDController<
        Subkategorija,
        SubkategorijaSearchObject,
        SubkategorijaInsertRequest,
        SubkategorijaUpdateRequest>
    {
        private readonly ISubkategorijaService _subkategorijaService;

        public SubkategorijeController(ISubkategorijaService service)
            : base(service)
        {
            _subkategorijaService = service;
        }

        [Authorize(Roles = "Administrator")]
        [HttpPost]
        public override ActionResult<Subkategorija> Insert([FromBody] SubkategorijaInsertRequest request)
        {
            return base.Insert(request);
        }

        [Authorize(Roles = "Administrator")]
        [HttpPut("{id}")]
        public override ActionResult<Subkategorija> Update(int id, [FromBody] SubkategorijaUpdateRequest request)
        {
            return base.Update(id, request);
        }

        [Authorize(Roles = "Administrator")]
        [HttpDelete("{id}")]
        public IActionResult Delete(int id)
        {
            try
            {
                _subkategorijaService.Delete(id);
                return NoContent();
            }
            catch (Exception ex)
            {
                return BadRequest(new { message = ex.Message });
            }
        }
    }
}
