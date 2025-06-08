using PlantCare.Model;
using PlantCare.Model.Requests;
using PlantCare.Model.SearchObjects;
using PlantCare.Services;

namespace PlantCare.WebAPI.Controllers
{
    public class PostController : BaseCRUDController<Post, PostSearchObject, PostInsertRequest, PostUpdateRequest>
    {
        public PostController(IPostService service)
            : base(service)
        {
        }
    }
}
