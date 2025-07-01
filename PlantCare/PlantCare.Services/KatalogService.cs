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

        query = query
       .Include(x => x.Korisnik)
       .Include(x => x.KatalogPostovi)
           .ThenInclude(kp => kp.Post);

        if (!string.IsNullOrWhiteSpace(search.Naslov))
            query = query.Where(x => x.Naslov.Contains(search.Naslov));

        return query;
    }

    public override Model.Katalog GetById(int id)
    {
        var entity = Context.Set<Database.Katalog>()
            .Include(k => k.Korisnik)
            .Include(k => k.KatalogPostovi)
                .ThenInclude(kp => kp.Post)
            .FirstOrDefault(k => k.KatalogId == id);

        return Mapper.Map<Model.Katalog>(entity);
    }

    public void Delete(int id)
    {
        var katalog = Context.Set<Database.Katalog>()
            .Include(k => k.KatalogPostovi)
            .FirstOrDefault(k => k.KatalogId == id);

        if (katalog == null)
            throw new Exception("Katalog not found");

        // First remove all related KatalogPost entries
        Context.RemoveRange(katalog.KatalogPostovi);

        // Then remove the katalog itself
        Context.Remove(katalog);

        Context.SaveChanges();
    }


}