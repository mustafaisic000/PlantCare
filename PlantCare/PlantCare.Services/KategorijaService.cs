using MapsterMapper;
using Microsoft.EntityFrameworkCore;
using PlantCare.Model;
using PlantCare.Model.DTO;
using PlantCare.Model.Requests;
using PlantCare.Model.SearchObjects;
using PlantCare.Services.Database;
using System.Linq;

namespace PlantCare.Services;

public class KategorijaService
   : BaseCRUDService<
       Model.Kategorija,
       KategorijaSearchObject,
       Database.Kategorija,
       KategorijaInsertRequest,
       KategorijaUpdateRequest>,
     IKategorijaService
{
    public KategorijaService(PlantCareContext ctx, IMapper mapper)
        : base(ctx, mapper)
    {
    }

    protected override IQueryable<Database.Kategorija> AddFilter(
        KategorijaSearchObject search,
        IQueryable<Database.Kategorija> query)
    {
        query = base.AddFilter(search, query);

        if (!string.IsNullOrWhiteSpace(search.Naziv))
            query = query.Where(x => x.Naziv.StartsWith(search.Naziv));

        return query;
    }

    public PagedResult<KategorijaBasic> GetBasic(KategorijaSearchObject search)
    {
        var query = AddFilter(search, Context.Kategorije);

        var page = search.Page ?? 1;
        var pageSize = search.PageSize ?? 10;

        var paged = query
            .OrderBy(k => k.KategorijaId)
            .Skip((page - 1) * pageSize)
            .Take(pageSize)
            .ToList();

        var count = query.Count();

        return new PagedResult<KategorijaBasic>
        {
            Count = count,
            ResultList = Mapper.Map<List<KategorijaBasic>>(paged)
        };
    }

    public override Model.Kategorija GetById(int id)
    {
        var entity = Context.Kategorije
            .Include(k => k.Subkategorije)
            .FirstOrDefault(k => k.KategorijaId == id);

        return entity == null ? null! : Mapper.Map<Model.Kategorija>(entity);
    }

    public KategorijeWithSubkategorijeBasicPaged GetWithSubsPaged(int id, BaseSearchObject subSearch)
    {
        var kategorija = Context.Kategorije
            .Include(k => k.Subkategorije)
            .FirstOrDefault(k => k.KategorijaId == id);

        if (kategorija == null)
            return null!;

        var subQuery = kategorija.Subkategorije.AsQueryable();

        var page = subSearch.Page ?? 1;
        var pageSize = subSearch.PageSize ?? 10;

        var pagedSubs = subQuery
            .OrderBy(s => s.SubkategorijaId)
            .Skip((page - 1) * pageSize)
            .Take(pageSize)
            .Select(s => new SubkategorijaBasic
            {
                SubkategorijaId = s.SubkategorijaId,
                Naziv = s.Naziv
            })
            .ToList();

        var count = subQuery.Count();

        return new KategorijeWithSubkategorijeBasicPaged
        {
            KategorijaId = kategorija.KategorijaId,
            Naziv = kategorija.Naziv,
            Subkategorije = new PagedResult<SubkategorijaBasic>
            {
                Count = count,
                ResultList = pagedSubs
            }
        };
    }
}
