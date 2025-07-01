using MapsterMapper;
using Microsoft.EntityFrameworkCore;
using PlantCare.Model;
using PlantCare.Model.Requests;
using PlantCare.Model.SearchObjects;
using PlantCare.Services.Database;
using System.Linq;

namespace PlantCare.Services;

public class LajkService
  : BaseCRUDService<
      Model.Lajk,
      LajkSearchObject,
      Database.Lajk,
      LajkInsertRequest,
      LajkUpdateRequest>,
    ILajkService
{
    public LajkService(PlantCareContext ctx, IMapper mapper)
      : base(ctx, mapper)
    {
    }

    protected override IQueryable<Database.Lajk> AddFilter(
        LajkSearchObject search,
        IQueryable<Database.Lajk> query)
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

    public void Delete(int lajkId, int korisnikId)
    {
        var entity = Context.Lajkovi.FirstOrDefault(x => x.LajkId == lajkId);

        if (entity == null)
            throw new Exception("Lajk nije pronađen");

        if (entity.KorisnikId != korisnikId)
            throw new Exception("Nemate pravo da obrišete ovaj lajk");

        Context.Lajkovi.Remove(entity);
        Context.SaveChanges();
    }

    public int GetLajkCountByPost(int postId)
    {
        return Context.Lajkovi.Count(x => x.PostId == postId);
    }

}
