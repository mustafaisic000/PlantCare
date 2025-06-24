// File: PlantCare.Services/SubkategorijaService.cs
using MapsterMapper;
using Microsoft.EntityFrameworkCore;
using PlantCare.Model;
using PlantCare.Model.Requests;
using PlantCare.Model.SearchObjects;
using PlantCare.Services.Database;
using System.Linq;

namespace PlantCare.Services;

public class SubkategorijaService
    : BaseCRUDService<
        Model.Subkategorija,
        SubkategorijaSearchObject,
        Database.Subkategorija,
        SubkategorijaInsertRequest,
        SubkategorijaUpdateRequest>,
      ISubkategorijaService
{

    private readonly IEmailService _emailService;
    public SubkategorijaService(PlantCareContext ctx, IMapper mapper, IEmailService emailService)
        : base(ctx, mapper)
    {
        _emailService=emailService;
    }

    protected override IQueryable<Database.Subkategorija> AddFilter(
        SubkategorijaSearchObject search,
        IQueryable<Database.Subkategorija> query)
    {
        query = base.AddFilter(search, query);

        query = query.Include(x => x.Kategorija);

        if (!string.IsNullOrWhiteSpace(search.Naziv))
            query = query.Where(x => x.Naziv.StartsWith(search.Naziv));

        if (search.KategorijaId.HasValue)
            query = query.Where(x => x.KategorijaId == search.KategorijaId.Value);

        return query;
    }

    public void Delete(int id)
    {
        var subkategorija = Context.Subkategorije.Find(id);
        if (subkategorija == null)
            throw new Exception("Subkategorija nije pronađena.");

        // Provjera da li postoji neki post sa ovom subkategorijom
        var hasPosts = Context.Postovi.Any(p => p.SubkategorijaId == id);
        if (hasPosts)
            throw new Exception("Subkategorija se ne može obrisati jer sadrži postove.");

        Context.Subkategorije.Remove(subkategorija);
        Context.SaveChanges();
    }


}
