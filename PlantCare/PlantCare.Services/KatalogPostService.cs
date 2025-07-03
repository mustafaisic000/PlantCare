using MapsterMapper;
using Microsoft.EntityFrameworkCore;
using PlantCare.Model;
using PlantCare.Model.Requests;
using PlantCare.Model.SearchObjects;
using PlantCare.Services.Database;
using System.Linq;

namespace PlantCare.Services;

public class KatalogPostService
    : BaseCRUDService<
        Model.KatalogPost,
        KatalogPostSearchObject,
        Database.KatalogPost,
        KatalogPostInsertRequest,
        KatalogPostUpdateRequest>,
      IKatalogPostService
{
    public KatalogPostService(PlantCareContext ctx, IMapper mapper)
        : base(ctx, mapper)
    {
    }

    protected override IQueryable<Database.KatalogPost> AddFilter(
        KatalogPostSearchObject search,
        IQueryable<Database.KatalogPost> query)
    {
        query = base.AddFilter(search, query);

        query = query.Include(x => x.Post);

        if (!string.IsNullOrWhiteSpace(search.PostNaslov))
            query = query.Where(x => x.Post.Naslov.Contains(search.PostNaslov));
        return query;
    }

    public override Model.KatalogPost GetById(int id)
    {
        var entity = Context.KatalogPostovi
            .Include(kp => kp.Post)
            .FirstOrDefault(kp => kp.KatalogPostId == id);

        if (entity == null)
            return null!;

        return Mapper.Map<Model.KatalogPost>(entity);
    }

    public async Task DeleteByKatalogIdAsync(int katalogId)
    {
        var entities = await Context.KatalogPostovi
            .Where(x => x.KatalogId == katalogId)
            .ToListAsync();

        Context.KatalogPostovi.RemoveRange(entities);
        await Context.SaveChangesAsync();
    }

}
