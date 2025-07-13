using PlantCare.Model.Requests;
using PlantCare.Model.SearchObjects;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PlantCare.Services
{
    public interface IFinansijskiLimit25062025Service : ICRUDService<
         PlantCare.Model.FinansijskiLimit25062025,
         FinansijskiLimit25062025SearchObject,
         FinansijskiLimit25062025UpsertRequest,
         FinansijskiLimit25062025UpsertRequest>
    {
    }
}
