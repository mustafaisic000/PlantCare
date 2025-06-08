using PlantCare.Model;
using PlantCare.Model.Requests;
using PlantCare.Model.SearchObjects;
using PlantCare.Services;

namespace PlantCare.WebAPI.Controllers
{
    public class KategorijaController : BaseCRUDController<Kategorija, KategorijaSearchObject, KategorijaInsertRequest, KategorijaUpdateRequest>
    {
        public KategorijaController(IKategorijaService service)
             : base(service)
        {
        }
    }
}
