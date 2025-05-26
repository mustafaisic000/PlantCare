using MapsterMapper;
using Microsoft.EntityFrameworkCore;
using PlantCare.Model;
using PlantCare.Model.Requests;
using PlantCare.Model.SearchObjects;
using PlantCare.Services.Database;
using System.Linq;

namespace PlantCare.Services;

public class UplataService
    : BaseCRUDService<
        Model.Uplata,
        UplataSearchObject,
        Database.Uplata,
        UplataInsertRequest,
        UplataUpdateRequest>,
      IUplataService
{
    public UplataService(PlantCareContext ctx, IMapper mapper)
        : base(ctx, mapper)
    {
    }

    protected override IQueryable<Database.Uplata> AddFilter(
        UplataSearchObject search,
        IQueryable<Database.Uplata> query)
    {
        query = base.AddFilter(search, query);

        if (search.KorisnikId.HasValue)
            query = query.Where(x => x.KorisnikId == search.KorisnikId.Value);

        if (!string.IsNullOrWhiteSpace(search.TipPretplate))
            query = query.Where(x => x.TipPretplate.Contains(search.TipPretplate));

        return query;
    }
}
