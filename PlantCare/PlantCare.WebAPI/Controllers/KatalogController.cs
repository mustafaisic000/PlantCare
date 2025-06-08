using PlantCare.Model;
using PlantCare.Model.Requests;
using PlantCare.Model.SearchObjects;
using PlantCare.Services;

namespace PlantCare.WebAPI.Controllers
{
    public class KatalogController : BaseCRUDController<Katalog,KatalogSearchObject, KatalogInsertRequest, KatalogUpdateRequest>
    {
        public KatalogController(IKatalogService service)
            : base(service)
        {
        }
    }
}
