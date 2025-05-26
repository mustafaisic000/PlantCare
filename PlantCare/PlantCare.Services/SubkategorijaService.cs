// File: PlantCare.Services/SubkategorijaService.cs
using MapsterMapper;
using Microsoft.EntityFrameworkCore;
using PlantCare.Model;
using PlantCare.Model.Requests;
using PlantCare.Model.SearchObjects;
using PlantCare.Services.Database;
using System.Linq;

namespace PlantCare.Services;

public class SubkategorijaService
    : BaseCRUDService<
        Model.Subkategorija,
        SubkategorijaSearchObject,
        Database.Subkategorija,
        SubkategorijaInsertRequest,
        SubkategorijaUpdateRequest>,
      ISubkategorijaService
{
    public SubkategorijaService(PlantCareContext ctx, IMapper mapper)
        : base(ctx, mapper)
    {
    }

    protected override IQueryable<Database.Subkategorija> AddFilter(
        SubkategorijaSearchObject search,
        IQueryable<Database.Subkategorija> query)
    {
        query = base.AddFilter(search, query);

        if (!string.IsNullOrWhiteSpace(search.Naziv))
            query = query.Where(x => x.Naziv.StartsWith(search.Naziv));

        if (search.KategorijaId.HasValue)
            query = query.Where(x => x.KategorijaId == search.KategorijaId.Value);

        return query;
    }
}
