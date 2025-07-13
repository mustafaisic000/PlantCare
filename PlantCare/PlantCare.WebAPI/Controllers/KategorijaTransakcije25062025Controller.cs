using Microsoft.AspNetCore.Mvc;
using PlantCare.Model;
using PlantCare.Model.Requests;
using PlantCare.Model.SearchObjects;
using PlantCare.Services;

namespace PlantCare.WebAPI.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class KategorijaTransakcije25062025Controller : BaseCRUDController<KategorijaTransakcije25062025, KategorijaTransakcije25062025SearchObject, KategorijaTransakcije25062025UpsertRequest, KategorijaTransakcije25062025UpsertRequest>
    {
        public KategorijaTransakcije25062025Controller(IKategorijaTransakcije25062025Service service)
          : base(service)
        {
        }
    }
}
