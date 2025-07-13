using MapsterMapper;
using PlantCare.Model.Requests;
using PlantCare.Model.SearchObjects;
using PlantCare.Services.Database;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PlantCare.Services
{
    public class TransakcijeLog25062025Service : BaseCRUDService<
         Model.TransakcijeLog25062025,
         TransakcijeLog25062025SearchObject,
         Database.TransakcijeLog25062025,
         TransakcijeLog25062025UpsertRequest,
         TransakcijeLog25062025UpsertRequest>,
      ITransakcijeLog25062025Service
    {
        public TransakcijeLog25062025Service(PlantCareContext context, IMapper mapper) : base(context, mapper)
        {
        }
    }
}
