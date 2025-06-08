using Microsoft.AspNetCore.Mvc;
using PlantCare.Model;
using PlantCare.Model.SearchObjects;
using PlantCare.Services;

namespace PlantCare.WebAPI.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class BaseController<TModel, TSearch> : ControllerBase where TSearch : BaseSearchObject
    {
        protected readonly IService<TModel, TSearch> _service;

        public BaseController(IService<TModel, TSearch> service)
        {
            _service = service;
        }

        [HttpGet]
        public virtual ActionResult<PagedResult<TModel>> GetList([FromQuery] TSearch searchObject)
        {
            return Ok(_service.GetPaged(searchObject));
        }

        [HttpGet("{id}")]
        public virtual ActionResult<TModel> GetById(int id)
        {
            var entity = _service.GetById(id);
            if (entity == null) return NotFound();
            return Ok(entity);
        }
    }
}

