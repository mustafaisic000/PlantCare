using MapsterMapper;
using Microsoft.EntityFrameworkCore;
using PlantCare.Model;
using PlantCare.Model.Requests;
using PlantCare.Model.SearchObjects;
using PlantCare.Services.Database;
using System.Linq;

namespace PlantCare.Services;

public class NotifikacijaService
    : BaseCRUDService<
        Model.Notifikacija,
        NotifikacijaSearchObject,
        Database.Notifikacija,
        NotifikacijaInsertRequest,
        NotifikacijaUpdateRequest>,
      INotifikacijaService
{

    private readonly INotifikacijskiServis _notifikacijskiServisSignalR;
    public NotifikacijaService(PlantCareContext ctx, IMapper mapper, INotifikacijskiServis notifikacijskiServisSignalR)
        : base(ctx, mapper)
    {
        _notifikacijskiServisSignalR=notifikacijskiServisSignalR;
    }

    protected override IQueryable<Database.Notifikacija> AddFilter(
        NotifikacijaSearchObject search,
        IQueryable<Database.Notifikacija> query)
    {
        query = base.AddFilter(search, query);

        query = query.Include(x => x.Korisnik);

        if (search.KorisnikId.HasValue)
            query = query.Where(x => x.KorisnikId == search.KorisnikId.Value);

        if (search.Procitano.HasValue)
            query = query.Where(x => x.Procitano == search.Procitano.Value);

        if (!string.IsNullOrWhiteSpace(search.Naslov))
            query = query.Where(x => x.Naslov.Contains(search.Naslov));

        if (!string.IsNullOrWhiteSpace(search.KoPrima))
            query = query.Where(n => n.KoPrima == search.KoPrima);

        query = query.OrderByDescending(x => x.Datum);
        return query;
    }



    public override Model.Notifikacija Insert(NotifikacijaInsertRequest request)
    {
        _notifikacijskiServisSignalR.PosaljiPoruku(request.KoPrima);
        return base.Insert(request);
    }

    public void Delete(int id)
    {
        var entity = Context.Set<Database.Notifikacija>().Find(id);
        if (entity == null)
            throw new Exception("Notifikacija nije pronađena");

        Context.Remove(entity);
        Context.SaveChanges();
    }

    public void MarkAsRead(int id)
    {
        var entity = Context.Set<Database.Notifikacija>().Find(id);
        if (entity == null)
            throw new Exception("Notifikacija nije pronađena");

        entity.Procitano = true;
        Context.SaveChanges();
    }


}