using PlantCare.Model;
using PlantCare.Model.Requests;
using PlantCare.Model.SearchObjects;

namespace PlantCare.Services;

public interface ISubkategorijaService
    : ICRUDService<
        Subkategorija,
        SubkategorijaSearchObject,
        SubkategorijaInsertRequest,
        SubkategorijaUpdateRequest>
{

}
