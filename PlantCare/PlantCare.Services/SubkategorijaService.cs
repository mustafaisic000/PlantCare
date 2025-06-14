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

        if (!string.IsNullOrWhiteSpace(search.Naziv))
            query = query.Where(x => x.Naziv.StartsWith(search.Naziv));

        if (search.KategorijaId.HasValue)
            query = query.Where(x => x.KategorijaId == search.KategorijaId.Value);

        return query;
    }

    public override Model.Subkategorija Insert(SubkategorijaInsertRequest request)
    {
        var email="beki74gi@live.com";
        Notifier testRabbitaIMaila = new Notifier
        {
            Datum = DateTime.Now,
            Email = email,
            Naslov = "Hvala što ste se testirali RabbitMQ",
            Tekst = $"Poštovani uspjesno ste dodali naziv subkategorije koji glasi = {request.Naziv}"
        };

        _emailService.SendingObject(testRabbitaIMaila);

        return base.Insert(request);
    }
}
