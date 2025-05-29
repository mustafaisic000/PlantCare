using MapsterMapper;
using Microsoft.EntityFrameworkCore;
using PlantCare.Model;
using PlantCare.Model.Requests;
using PlantCare.Model.SearchObjects;
using PlantCare.Services.Database;
using System.Linq;

namespace PlantCare.Services;

public class KatalogService
    : BaseCRUDService<
        Model.Katalog,
        KatalogSearchObject,
        Database.Katalog,
        KatalogInsertRequest,
        KatalogUpdateRequest>,
      IKatalogService
{
    public KatalogService(PlantCareContext ctx, IMapper mapper)
        : base(ctx, mapper)
    {
    }

    protected override IQueryable<Database.Katalog> AddFilter(
        KatalogSearchObject search,
        IQueryable<Database.Katalog> query)
    {
        query = base.AddFilter(search, query);

        query = query.Include(x => x.Korisnik);

        if (!string.IsNullOrWhiteSpace(search.Naslov))
            query = query.Where(x => x.Naslov.Contains(search.Naslov));

        if (search.KorisnikId.HasValue)
            query = query.Where(x => x.KorisnikId == search.KorisnikId.Value);

        if (search.DatumOd.HasValue)
            query = query.Where(x => x.DatumOd >= search.DatumOd.Value);

        if (search.DatumDo.HasValue)
            query = query.Where(x => x.DatumDo <= search.DatumDo.Value);

        return query;
    }
}