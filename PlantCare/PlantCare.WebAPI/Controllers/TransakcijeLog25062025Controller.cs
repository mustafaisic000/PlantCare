using Microsoft.AspNetCore.Mvc;
using PlantCare.Model;
using PlantCare.Model.Requests;
using PlantCare.Model.SearchObjects;
using PlantCare.Services;

namespace PlantCare.WebAPI.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class TransakcijeLog25062025Controller: BaseCRUDController<TransakcijeLog25062025, TransakcijeLog25062025SearchObject, TransakcijeLog25062025UpsertRequest, TransakcijeLog25062025UpsertRequest>
    {
        public TransakcijeLog25062025Controller(ITransakcijeLog25062025Service service)
           : base(service)
        {
        }
    }
}
