using MapsterMapper;
using Microsoft.EntityFrameworkCore;
using PlantCare.Model;
using PlantCare.Model.Requests;
using PlantCare.Model.SearchObjects;
using PlantCare.Services.Database;
using System.Linq;

namespace PlantCare.Services;

public class KomentarService
    : BaseCRUDService<
        Model.Komentar,
        KomentarSearchObject,
        Database.Komentar,
        KomentarInsertRequest,
        KomentarUpdateRequest>,
      IKomentarService
{
    public KomentarService(PlantCareContext ctx, IMapper mapper)
        : base(ctx, mapper)
    {
    }

    protected override IQueryable<Database.Komentar> AddFilter(
        KomentarSearchObject search,
        IQueryable<Database.Komentar> query)
    {
        query = base.AddFilter(search, query);

        if (search.PostId.HasValue)
            query = query.Where(x => x.PostId == search.PostId.Value);

        if (search.KorisnikId.HasValue)
            query = query.Where(x => x.KorisnikId == search.KorisnikId.Value);

        if (search.DatumOd.HasValue)
            query = query.Where(x => x.DatumKreiranja >= search.DatumOd.Value);

        if (search.DatumDo.HasValue)
            query = query.Where(x => x.DatumKreiranja <= search.DatumDo.Value);

        return query;
    }

    public override PagedResult<Model.Komentar> GetPaged(KomentarSearchObject search)
    {
        var query = AddFilter(search, Context.Komentari
            .Include(x => x.Korisnik)
            .Include(x => x.Post));

        var page = search.Page ?? 1;
        var pageSize = search.PageSize ?? 10;

        var list = query
            .OrderBy(x => x.KomentarId)
            .Skip((page - 1) * pageSize)
            .Take(pageSize)
            .ToList();

        var result = list.Select(x => new Model.Komentar
        {
            KomentarId = x.KomentarId,
            Sadrzaj = x.Sadrzaj,
            DatumKreiranja = x.DatumKreiranja,
            KorisnickoIme = x.Korisnik?.KorisnickoIme,
            PostNaslov = x.Post?.Naslov
        }).ToList();

        return new PagedResult<Model.Komentar>
        {
            Count = query.Count(),
            ResultList = result
        };
    }

    public override Model.Komentar GetById(int id)
    {
        var entity = Context.Komentari
            .Include(x => x.Korisnik)
            .Include(x => x.Post)
            .FirstOrDefault(x => x.KomentarId == id);

        if (entity == null)
            return null;

        return new Model.Komentar
        {
            KomentarId = entity.KomentarId,
            Sadrzaj = entity.Sadrzaj,
            DatumKreiranja = entity.DatumKreiranja,
            KorisnickoIme = entity.Korisnik?.KorisnickoIme,
            PostNaslov = entity.Post?.Naslov
        };
    }


}
