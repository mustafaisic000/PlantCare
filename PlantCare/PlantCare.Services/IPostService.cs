using PlantCare.Model;
using PlantCare.Model.Requests;
using PlantCare.Model.SearchObjects;

namespace PlantCare.Services;

public interface IPostService
    : ICRUDService<
        Post,
        PostSearchObject,
        PostInsertRequest,
        PostUpdateRequest>
{
}
