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
    private readonly INotifikacijaService _notificationservice;

    public ObavijestService(PlantCareContext ctx, IMapper mapper, INotifikacijaService notificationservice)
        : base(ctx, mapper)
    {
        _notificationservice=notificationservice;
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

    public override Model.Obavijest Insert(ObavijestInsertRequest request)
    {
        var entity = base.Insert(request);

        if (request.Aktivan)
        {
            var insertObj = new NotifikacijaInsertRequest
            {
                KorisnikId = request.KorisnikId,
                Naslov = "Nova obavijest",
                Sadrzaj = "Imate novu obavijest od administratora",
                KoPrima = "Mobilna"
            };

            _notificationservice.Insert(insertObj);
        }

        return entity;
    }

    public override Model.Obavijest Update(int id, ObavijestUpdateRequest request)
    {
        var oldEntity = Context.Obavijesti.AsNoTracking().FirstOrDefault(x => x.ObavijestId == id);
        var updated = base.Update(id, request);

        if (oldEntity != null && !oldEntity.Aktivan && request.Aktivan)
        {
            var insertObj = new NotifikacijaInsertRequest
            {
                KorisnikId = oldEntity.KorisnikId,
                Naslov = "Obavijest je aktivirana",
                Sadrzaj = "Administrator je aktivirao obavijest",
                KoPrima = "Mobilna"
            };

            _notificationservice.Insert(insertObj);
        }

        return updated;
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
