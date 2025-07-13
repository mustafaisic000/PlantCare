using MapsterMapper;
using PlantCare.Model;
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
    public class KategorijaTransakcije25062025Service : BaseCRUDService<
         Model.KategorijaTransakcije25062025,
         KategorijaTransakcije25062025SearchObject,
         Database.KategorijaTransakcije25062025,
         KategorijaTransakcije25062025UpsertRequest,
         KategorijaTransakcije25062025UpsertRequest>,
      IKategorijaTransakcije25062025Service
    {
        public KategorijaTransakcije25062025Service(PlantCareContext context, IMapper mapper) : base(context, mapper)
        {
        }

    }
}
