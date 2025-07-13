using Microsoft.AspNetCore.Mvc;
using PlantCare.Model;
using PlantCare.Model.Requests;
using PlantCare.Model.SearchObjects;
using PlantCare.Services;
using PlantCare.Services.Database;

namespace PlantCare.WebAPI.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class FinansijskiLimit25062025Controller : BaseCRUDController<Model.FinansijskiLimit25062025, FinansijskiLimit25062025SearchObject, FinansijskiLimit25062025UpsertRequest, FinansijskiLimit25062025UpsertRequest>
    {
        public FinansijskiLimit25062025Controller(IFinansijskiLimit25062025Service service)
            : base(service)
        {
        }
    }
}
