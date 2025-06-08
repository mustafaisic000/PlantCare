using PlantCare.Model;
using PlantCare.Model.Requests;
using PlantCare.Model.SearchObjects;
using PlantCare.Services;

namespace PlantCare.WebAPI.Controllers
{
    public class LajkController : BaseCRUDController<Lajk, LajkSearchObject, LajkInsertRequest, LajkUpdateRequest>
    {
        public LajkController(ILajkService service)
            : base(service)
        {
        }
    }
}
