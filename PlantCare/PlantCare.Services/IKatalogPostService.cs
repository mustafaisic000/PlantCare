using PlantCare.Model;
using PlantCare.Model.Requests;
using PlantCare.Model.SearchObjects;

namespace PlantCare.Services;

public interface IKatalogPostService
    : ICRUDService<
        KatalogPost,
        KatalogPostSearchObject,
        KatalogPostInsertRequest,
        KatalogPostUpdateRequest>
{
}