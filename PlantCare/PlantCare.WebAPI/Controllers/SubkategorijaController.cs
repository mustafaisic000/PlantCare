using Microsoft.EntityFrameworkCore.Query;
using PlantCare.Model;
using PlantCare.Model.Requests;
using PlantCare.Model.SearchObjects;
using PlantCare.Services;

namespace PlantCare.WebAPI.Controllers
{
    public class SubkategorijeController : BaseCRUDController<Subkategorija, SubkategorijaSearchObject, SubkategorijaInsertRequest, SubkategorijaUpdateRequest>
    {
        public SubkategorijeController(ISubkategorijaService service)
            : base(service)
        {
        }
    }
}
