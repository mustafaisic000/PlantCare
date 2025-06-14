using Microsoft.AspNetCore.Mvc;
using PlantCare.Model;
using PlantCare.Model.Requests;
using PlantCare.Model.SearchObjects;
using PlantCare.Services;
using static Microsoft.EntityFrameworkCore.DbLoggerCategory;

namespace PlantCare.WebAPI.Controllers
{
    public class BaseCRUDController<TModel, TSearch, TInsert, TUpdate> : BaseController<TModel, TSearch>
        where TSearch : BaseSearchObject
        where TModel : class
    {
        protected new readonly ICRUDService<TModel, TSearch, TInsert, TUpdate> _service;

        public BaseCRUDController(ICRUDService<TModel, TSearch, TInsert, TUpdate> service) : base(service)
        {
            _service = service;
        }

        [HttpPost]
        public virtual ActionResult<TModel> Insert([FromBody] TInsert request)
        {
            var created = _service.Insert(request);
             return Ok(created);
        }

        [HttpPut("{id}")]
        public virtual ActionResult<TModel> Update(int id, [FromBody] TUpdate request)
        {
            var updated = _service.Update(id, request);
            return Ok(updated);
        }
    }
}

