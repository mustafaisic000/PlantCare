using PlantCare.Model;
using PlantCare.Model.Requests;
using PlantCare.Model.SearchObjects;

namespace PlantCare.Services;

public interface IKatalogService
    : ICRUDService<
        Katalog,
        KatalogSearchObject,
        KatalogInsertRequest,
        KatalogUpdateRequest>
{
    void Delete(int id);
}