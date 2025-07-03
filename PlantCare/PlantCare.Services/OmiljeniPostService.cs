using MapsterMapper;
using Microsoft.EntityFrameworkCore;
using PlantCare.Model;
using PlantCare.Model.Requests;
using PlantCare.Model.SearchObjects;
using PlantCare.Services.Database;
using System.Linq;

namespace PlantCare.Services;

public class OmiljeniPostService
    : BaseCRUDService<
        Model.OmiljeniPost,
        OmiljeniPostSearchObject,
        Database.OmiljeniPost,
        OmiljeniPostInsertRequest,
        OmiljeniPostUpdateRequest>,
      IOmiljeniPostService
{
    public OmiljeniPostService(PlantCareContext ctx, IMapper mapper)
        : base(ctx, mapper)
    {
    }

    protected override IQueryable<Database.OmiljeniPost> AddFilter(
        OmiljeniPostSearchObject search,
        IQueryable<Database.OmiljeniPost> query)
    {
        query = base.AddFilter(search, query);

        query = query
             .Include(x => x.Korisnik)
             .Include(x => x.Post);

        if (search.KorisnikId.HasValue)
            query = query.Where(x => x.KorisnikId == search.KorisnikId.Value);

        if (search.PostId.HasValue)
            query = query.Where(x => x.PostId == search.PostId.Value);

        return query;
    }

    public void Delete(int id)
    {
        var entity = Context.Set<Database.OmiljeniPost>().Find(id);
        if (entity == null)
            throw new Exception("Omiljeni post nije pronađen");

        Context.Remove(entity);
        Context.SaveChanges();
    }

}
