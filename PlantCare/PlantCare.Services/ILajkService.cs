using PlantCare.Model;
using PlantCare.Model.SearchObjects;
using PlantCare.Model.Requests;

namespace PlantCare.Services;

public interface ILajkService
  : ICRUDService<
      Lajk,
      LajkSearchObject,
      LajkInsertRequest,
      LajkUpdateRequest>
{
    void Delete(int lajkId, int korisnikId);
    int GetLajkCountByPost(int postId);
}