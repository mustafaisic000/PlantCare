using MapsterMapper;
using Microsoft.EntityFrameworkCore;
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
    public class FinansijskiLimit25062025Service : BaseCRUDService<
        PlantCare.Model.FinansijskiLimit25062025,
        FinansijskiLimit25062025SearchObject,
        Database.FinansijskiLimit25062025,
        FinansijskiLimit25062025UpsertRequest,
        FinansijskiLimit25062025UpsertRequest>,
        IFinansijskiLimit25062025Service
    {
        public FinansijskiLimit25062025Service(PlantCareContext context, IMapper mapper) : base(context, mapper)
        {
        }
    }
}
