// PlantCare.Services/KategorijaService.cs
using MapsterMapper;
using Microsoft.EntityFrameworkCore;
using PlantCare.Model;
using PlantCare.Model.Requests;
using PlantCare.Model.SearchObjects;
using PlantCare.Services.Database;
using System.Linq;

namespace PlantCare.Services;

public class KategorijaService
    : BaseCRUDService<
         Model.Kategorija,
         KategorijaSearchObject,
         Database.Kategorija,
         KategorijaInsertRequest,
         KategorijaUpdateRequest>,
      IKategorijaService
{
    public KategorijaService(PlantCareContext ctx, IMapper mapper)
        : base(ctx, mapper)
    { }

    protected override IQueryable<Database.Kategorija> AddFilter(
        KategorijaSearchObject search,
        IQueryable<Database.Kategorija> query)
    {
        query = base.AddFilter(search, query);

        if (!string.IsNullOrWhiteSpace(search.Naziv))
            query = query.Where(x => x.Naziv.StartsWith(search.Naziv));

        return query;
    }
}
