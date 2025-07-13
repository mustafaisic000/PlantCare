using PlantCare.Model.Requests;
using PlantCare.Model.SearchObjects;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PlantCare.Services
{
    public interface ITransakcijeLog25062025Service : ICRUDService<
         PlantCare.Model.TransakcijeLog25062025,
         TransakcijeLog25062025SearchObject,
         TransakcijeLog25062025UpsertRequest,
         TransakcijeLog25062025UpsertRequest>
    {
    }
}
