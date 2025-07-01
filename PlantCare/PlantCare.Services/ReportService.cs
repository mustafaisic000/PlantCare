using MapsterMapper;
using Microsoft.EntityFrameworkCore;
using PlantCare.Model;
using PlantCare.Model.Requests;
using PlantCare.Model.SearchObjects;
using PlantCare.Services.Database;
using System.Linq;

namespace PlantCare.Services;

public class ReportService
    : BaseCRUDService<
        Model.Report,
        ReportSearchObject,
        Database.Report,
        ReportInsertRequest,
        ReportUpdateRequest>,
      IReportService
{
    public ReportService(PlantCareContext ctx, IMapper mapper)
        : base(ctx, mapper)
    {
    }

    protected override IQueryable<Database.Report> AddFilter(
        ReportSearchObject search,
        IQueryable<Database.Report> query)
    {
        query = base.AddFilter(search, query);

        query = query
            .Include(x => x.Korisnik)
            .Include(x => x.Post);

        if (search.PostId.HasValue)
            query = query.Where(x => x.PostId == search.PostId.Value);

        if (!string.IsNullOrWhiteSpace(search.Naslov))
        {
            query = query.Where(r =>
                r.Post.Naslov.ToLower().Contains(search.Naslov.ToLower()));
        }

        return query;
    }

    protected override void BeforeInsert(ReportInsertRequest request, Database.Report entity)
    {
        var post = Context.Postovi.FirstOrDefault(p => p.PostId == request.PostId);
        if (post == null)
            throw new Exception("Ne postoji post sa tim ID-om.");

        entity.KorisnikId = post.KorisnikId;

        entity.BrojKomentara = Context.Komentari.Count(k => k.PostId == post.PostId);
        entity.BrojLajkova = Context.Lajkovi.Count(l => l.PostId == post.PostId);
        entity.BrojOmiljenih = Context.OmiljeniPostovi.Count(o => o.PostId == post.PostId);
        entity.Datum = DateTime.Now;
    }

    public void Delete(int id)
    {
        var entity = Context.Set<Database.Report>().Find(id);
        if (entity == null)
            throw new Exception("Report not found");

        Context.Remove(entity);
        Context.SaveChanges();
    }


}
