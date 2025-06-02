// PlantCare.Services/KatalogPostService.cs
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


        if (search.KatalogId.HasValue)
            query = query.Where(x => x.KatalogId == search.KatalogId.Value);

        if (search.PostId.HasValue)
            query = query.Where(x => x.PostId == search.PostId.Value);

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


}
