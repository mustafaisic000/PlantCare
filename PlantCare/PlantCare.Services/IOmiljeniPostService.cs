using PlantCare.Model;
using PlantCare.Model.Requests;
using PlantCare.Model.SearchObjects;

namespace PlantCare.Services;

public interface IOmiljeniPostService
    : ICRUDService<
        OmiljeniPost,
        OmiljeniPostSearchObject,
        OmiljeniPostInsertRequest,
        OmiljeniPostUpdateRequest>
{
}
