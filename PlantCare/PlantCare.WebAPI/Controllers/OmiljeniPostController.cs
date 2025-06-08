using PlantCare.Model;
using PlantCare.Model.Requests;
using PlantCare.Model.SearchObjects;
using PlantCare.Services;

namespace PlantCare.WebAPI.Controllers
{
    public class OmiljeniPostController : BaseCRUDController<OmiljeniPost, OmiljeniPostSearchObject, OmiljeniPostInsertRequest, OmiljeniPostUpdateRequest>
    {
        public OmiljeniPostController(IOmiljeniPostService service)
            : base(service)
        {
        }
    }
}
