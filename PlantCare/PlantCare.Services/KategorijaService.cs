using MapsterMapper;
using Microsoft.EntityFrameworkCore;
using PlantCare.Model;
using PlantCare.Model.Requests;
using PlantCare.Model.SearchObjects;
using PlantCare.Services.Database;

namespace PlantCare.Services;

public class KategorijaService : BaseCRUDService<
    Model.Kategorija,
    KategorijaSearchObject,
    Database.Kategorija,
    KategorijaInsertRequest,
    KategorijaUpdateRequest>, IKategorijaService
{
    public KategorijaService(PlantCareContext ctx, IMapper mapper)
        : base(ctx, mapper)
    {
    }

    // Optional filter override (by Naziv)
    protected override IQueryable<Database.Kategorija> AddFilter(KategorijaSearchObject search, IQueryable<Database.Kategorija> query)
    {
        query = base.AddFilter(search, query);

        query = query.Include(k => k.Subkategorije);

        if (!string.IsNullOrWhiteSpace(search.Naziv))
            query = query.Where(x => x.Naziv.StartsWith(search.Naziv));

        return query;
    }

    public override Model.Kategorija GetById(int id)
    {
        var entity = Context.Kategorije
            .Include(k => k.Subkategorije)
            .FirstOrDefault(k => k.KategorijaId == id);

        return entity == null ? null! : Mapper.Map<Model.Kategorija>(entity);
    }

}
