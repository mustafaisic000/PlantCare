using PlantCare.Model;
using PlantCare.Model.SearchObjects;
using PlantCare.Model.Requests;

namespace PlantCare.Services;

public interface IUlogaService
    : ICRUDService<Uloga, UlogaSearchObject, UlogaInsertRequest, UlogaUpdateRequest>
{
}
