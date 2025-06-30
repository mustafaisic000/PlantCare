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
        var userName =   Context.Korisnici.Find(request.KorisnikId);


        var objToInsert = new NotifikacijaInsertRequest
        {
            KoPrima = "Desktop",
            KorisnikId = request.KorisnikId,
            Naslov = "Nova uplata",
            Sadrzaj = $"{userName!.KorisnickoIme} je postao/la premium korisnik"
        };

         _servis.Insert(objToInsert);

        return  base.Insert(request);
    }

}
