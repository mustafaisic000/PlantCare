using Microsoft.AspNetCore.Mvc;
using PlantCare.Model;
using PlantCare.Model.Requests;
using PlantCare.Model.SearchObjects;
using PlantCare.Services;

namespace PlantCare.WebAPI.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class Transakcija25062025Controller : BaseCRUDController<Transakcija25062025, Transakcija25062025SearchObject, Transakcija25062025UpsertRequest, Transakcija25062025UpsertRequest>
    {
        private readonly ITransakcija25062025Service _transakcija25062025Service;
        public Transakcija25062025Controller(ITransakcija25062025Service service)
          : base(service)
        {
            _transakcija25062025Service = service;
        }

        public override ActionResult<Transakcija25062025> Insert(Transakcija25062025UpsertRequest request)
        {
            try
            {
                return base.Insert(request);
            }
            catch (Exception ex)
            {
                throw new Exception("Prešli ste limit pri dodavanju transakcije" + ex.Message);
            }
        }

        [HttpGet("statistika")]
        public async Task<ActionResult> GetStat(int? KategorijaTransakcije25062025Id)
        {
            var statisika = await _transakcija25062025Service.GetStat(KategorijaTransakcije25062025Id);
            return Ok(statisika);
        }

    }
}
