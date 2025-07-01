using PlantCare.Model;
using PlantCare.Model.Requests;
using PlantCare.Model.SearchObjects;
using PlantCare.Services;

namespace PlantCare.WebAPI.Controllers
{
    public class UplataController : BaseCRUDController<Uplata, UplataSearchObject, UplataInsertRequest, UplataUpdateRequest>
    {
        public UplataController(IUplataService service)
            : base(service)
        {
        }
    }
}
