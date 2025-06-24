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

        query = query.Include(x => x.Korisnik);

        if (!string.IsNullOrWhiteSpace(search.Naslov))
            query = query.Where(x => x.Naslov.Contains(search.Naslov));

        return query;
    }

    public void Delete(int id)
    {
        var entity = Context.Set<Database.Obavijest>().Find(id);
        if (entity == null)
            throw new Exception("Obavijest not found");

        Context.Set<Database.Obavijest>().Remove(entity);
        Context.SaveChanges();
    }

}
