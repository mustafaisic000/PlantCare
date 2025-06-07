using MapsterMapper;
using Microsoft.EntityFrameworkCore;
using PlantCare.Model;
using PlantCare.Model.Requests;
using PlantCare.Model.SearchObjects;
using PlantCare.Services.Database;
using System.Linq;

namespace PlantCare.Services;

public class NotifikacijaService
    : BaseCRUDService<
        Model.Notifikacija,
        NotifikacijaSearchObject,
        Database.Notifikacija,
        NotifikacijaInsertRequest,
        NotifikacijaUpdateRequest>,
      INotifikacijaService
{
    public NotifikacijaService(PlantCareContext ctx, IMapper mapper)
        : base(ctx, mapper)
    {
    }

    protected override IQueryable<Database.Notifikacija> AddFilter(
        NotifikacijaSearchObject search,
        IQueryable<Database.Notifikacija> query)
    {
        query = base.AddFilter(search, query);

        query = query
             .Include(x => x.Korisnik)
             .Include(x => x.Post);

        if (search.KorisnikId.HasValue)
            query = query.Where(x => x.KorisnikId == search.KorisnikId.Value);

        if (search.PostId.HasValue)
            query = query.Where(x => x.PostId == search.PostId.Value);

        if (search.Procitano.HasValue)
            query = query.Where(x => x.Procitano == search.Procitano.Value);

        if (!string.IsNullOrWhiteSpace(search.Naslov))
            query = query.Where(x => x.Naslov.Contains(search.Naslov));

        return query;
    }
}