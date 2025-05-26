// PlantCare.Services/ObavijestService.cs
using MapsterMapper;
using Microsoft.EntityFrameworkCore;
using PlantCare.Model;
using PlantCare.Model.Requests;
using PlantCare.Model.SearchObjects;
using PlantCare.Services.Database;
using System.Linq;

namespace PlantCare.Services;

public class ObavijestService
    : BaseCRUDService<
        Model.Obavijest,
        ObavijestSearchObject,
        Database.Obavijest,
        ObavijestInsertRequest,
        ObavijestUpdateRequest>,
      IObavijestService
{
    public ObavijestService(PlantCareContext ctx, IMapper mapper)
        : base(ctx, mapper)
    {
    }

    protected override IQueryable<Database.Obavijest> AddFilter(
        ObavijestSearchObject search,
        IQueryable<Database.Obavijest> query)
    {
        query = base.AddFilter(search, query);

        if (search.KorisnikId.HasValue)
            query = query.Where(x => x.KorisnikId == search.KorisnikId.Value);

        if (!string.IsNullOrWhiteSpace(search.Naslov))
            query = query.Where(x => x.Naslov.Contains(search.Naslov));

        if (search.DatumOd.HasValue)
            query = query.Where(x => x.Datum >= search.DatumOd.Value);

        if (search.DatumDo.HasValue)
            query = query.Where(x => x.Datum <= search.DatumDo.Value);

        return query;
    }
}
