using MapsterMapper;
using Microsoft.EntityFrameworkCore;
using PlantCare.Model;
using PlantCare.Model.Requests;
using PlantCare.Model.SearchObjects;
using PlantCare.Services.Database;
using System.Linq;

namespace PlantCare.Services;

public class LajkService
  : BaseCRUDService<
      Model.Lajk,
      LajkSearchObject,
      Database.Lajk,
      LajkInsertRequest,
      LajkUpdateRequest>,
    ILajkService
{
    public LajkService(PlantCareContext ctx, IMapper mapper)
      : base(ctx, mapper)
    {
    }

    protected override IQueryable<Database.Lajk> AddFilter(
        LajkSearchObject search,
        IQueryable<Database.Lajk> query)
    {
        query = base.AddFilter(search, query);

        if (search.KorisnikId.HasValue)
            query = query.Where(x => x.KorisnikId == search.KorisnikId.Value);

        if (search.PostId.HasValue)
            query = query.Where(x => x.PostId == search.PostId.Value);

        return query;
    }
}
