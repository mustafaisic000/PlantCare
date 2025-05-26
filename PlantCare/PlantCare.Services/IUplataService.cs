using PlantCare.Model;
using PlantCare.Model.Requests;
using PlantCare.Model.SearchObjects;

namespace PlantCare.Services;

public interface IUplataService
    : ICRUDService<
        Uplata,
        UplataSearchObject,
        UplataInsertRequest,
        UplataUpdateRequest>
{

}
