using PlantCare.Model;
using PlantCare.Model.SearchObjects;
using PlantCare.Model.Requests;

namespace PlantCare.Services;

public interface IKategorijaService
    : ICRUDService<
         Kategorija,
         KategorijaSearchObject,
         KategorijaInsertRequest,
         KategorijaUpdateRequest>
{
    // any category-specific methods later
}
