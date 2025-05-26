using PlantCare.Model;
using PlantCare.Model.Requests;
using PlantCare.Model.SearchObjects;

namespace PlantCare.Services;

public interface IObavijestService
    : ICRUDService<
        Obavijest,
        ObavijestSearchObject,
        ObavijestInsertRequest,
        ObavijestUpdateRequest>
{
}
