using PlantCare.Model;
using PlantCare.Model.Requests;
using PlantCare.Model.SearchObjects;

namespace PlantCare.Services;

public interface INotifikacijaService
    : ICRUDService<
        Notifikacija,
        NotifikacijaSearchObject,
        NotifikacijaInsertRequest,
        NotifikacijaUpdateRequest>
{
}