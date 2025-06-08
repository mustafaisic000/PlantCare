using PlantCare.Model;
using PlantCare.Model.Requests;
using PlantCare.Model.SearchObjects;
using PlantCare.Services;

namespace PlantCare.WebAPI.Controllers
{
    public class NotifikacijaController : BaseCRUDController<Notifikacija, NotifikacijaSearchObject, NotifikacijaInsertRequest, NotifikacijaUpdateRequest>
    {
        public NotifikacijaController(INotifikacijaService service)
            : base(service)
        {
        }
    }
}
