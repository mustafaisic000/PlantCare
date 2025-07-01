using PlantCare.Model;
using PlantCare.Model.Requests;
using PlantCare.Model.SearchObjects;
using PlantCare.Services;

namespace PlantCare.WebAPI.Controllers
{
    public class UlogaController : BaseCRUDController<Uloga, UlogaSearchObject, UlogaInsertRequest,UlogaUpdateRequest >
    {
        public UlogaController(IUlogaService service)
            : base(service)
        {
        }
    }
}
