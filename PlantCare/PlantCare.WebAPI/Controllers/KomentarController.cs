using PlantCare.Model;
using PlantCare.Model.Requests;
using PlantCare.Model.SearchObjects;
using PlantCare.Services;

namespace PlantCare.WebAPI.Controllers
{
    public class KomentarController : BaseCRUDController<Komentar, KomentarSearchObject, KomentarInsertRequest, KomentarUpdateRequest>
    {
        public KomentarController(IKomentarService service)
            : base(service)
        {
        }
    }
}
