using PlantCare.Model;
using PlantCare.Model.Requests;
using PlantCare.Model.SearchObjects;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PlantCare.Services
{
    public interface ITransakcija25062025Service: ICRUDService<Model.Transakcija25062025, Transakcija25062025SearchObject,Transakcija25062025UpsertRequest, Transakcija25062025UpsertRequest>
    {
        Task<List<StatKategorije>> GetStat(int? Transakcija25062025Id);
    }
}
