using PlantCare.Model;
using PlantCare.Model.Requests;
using PlantCare.Model.SearchObjects;

namespace PlantCare.Services;

public interface IKomentarService
    : ICRUDService<
        Komentar,
        KomentarSearchObject,
        KomentarInsertRequest,
        KomentarUpdateRequest>
{
    void Delete(int komentarId, int korisnikId);

}