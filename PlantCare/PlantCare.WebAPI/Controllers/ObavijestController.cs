using PlantCare.Model;
using PlantCare.Model.Requests;
using PlantCare.Model.SearchObjects;
using PlantCare.Services;

namespace PlantCare.WebAPI.Controllers
{
    public class ObavijestController : BaseCRUDController<Obavijest, ObavijestSearchObject, ObavijestInsertRequest, ObavijestUpdateRequest>
    {
        public ObavijestController(IObavijestService service)
            : base(service)
        {
        }
    }
}
