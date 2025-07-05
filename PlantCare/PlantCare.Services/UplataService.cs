using MapsterMapper;
using Microsoft.EntityFrameworkCore;
using PlantCare.Model;
using PlantCare.Model.Requests;
using PlantCare.Model.SearchObjects;
using PlantCare.Services.Database;
using System.Linq;

namespace PlantCare.Services;

public class UplataService
    : BaseCRUDService<
        Model.Uplata,
        UplataSearchObject,
        Database.Uplata,
        UplataInsertRequest,
        UplataUpdateRequest>,
      IUplataService
{
    private readonly INotifikacijaService _servis;
    public UplataService(PlantCareContext ctx, IMapper mapper, INotifikacijaService servis)
        : base(ctx, mapper)
    {
        _servis=servis;
    }

    protected override IQueryable<Database.Uplata> AddFilter(
        UplataSearchObject search,
        IQueryable<Database.Uplata> query)
    {
        query = base.AddFilter(search, query);

        query = query.Include(x => x.Korisnik);

        if (search.KorisnikId.HasValue)
            query = query.Where(x => x.KorisnikId == search.KorisnikId.Value);

        return query;
    }

    public  override Model.Uplata Insert(UplataInsertRequest request)
    {
        var korisnik = Context.Korisnici.Find(request.KorisnikId);
        var userName =   Context.Korisnici.Find(request.KorisnikId);


        var admini = Context.Korisnici
     .Where(x => x.UlogaId == 1 && x.Status == true)
     .ToList();

        foreach (var admin in admini)
        {
            var objToInsert = new NotifikacijaInsertRequest
            {
                KoPrima = "Desktop",
                KorisnikId = admin.KorisnikId, 
                Naslov = "Nova uplata",
                Sadrzaj = $"{userName!.KorisnickoIme} je postao/la premium korisnik"
            };

            _servis.Insert(objToInsert);
        }


        var entity = Mapper.Map<Database.Uplata>(request);
        entity.Datum = DateTime.Now; 
        entity.KorisnikId = korisnik.KorisnikId;  

        Context.Uplate.Add(entity);
        Context.SaveChanges();

        var response = Mapper.Map<Model.Uplata>(entity);
        response.KorisnickoIme = korisnik.KorisnickoIme; 

        return response;
    }

}
