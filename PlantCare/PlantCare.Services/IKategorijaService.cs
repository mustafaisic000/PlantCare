// PlantCare.Services/IKategorijaService.cs
using PlantCare.Model;
using PlantCare.Model.DTO;
using PlantCare.Model.Requests;
using PlantCare.Model.SearchObjects;
using PlantCare.Services;

public interface IKategorijaService
    : ICRUDService<
         Kategorija,
         KategorijaSearchObject,
         KategorijaInsertRequest,
         KategorijaUpdateRequest>
{
    void Delete(int id);
}
