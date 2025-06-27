// PlantCare.Services/PostService.cs
using Mapster;
using MapsterMapper;
using Microsoft.EntityFrameworkCore;
using PlantCare.Model;
using PlantCare.Model.Requests;
using PlantCare.Model.SearchObjects;
using PlantCare.Services.Database;
using System.Linq;

namespace PlantCare.Services;

public class PostService
    : BaseCRUDService<
        Model.Post,
        PostSearchObject,
        Database.Post,
        PostInsertRequest,
        PostUpdateRequest>,
      IPostService
{
    public PostService(PlantCareContext ctx, IMapper mapper)
        : base(ctx, mapper)
    {
    }

    protected override IQueryable<Database.Post> AddFilter(
        PostSearchObject search,
        IQueryable<Database.Post> query)
    {
        query = base.AddFilter(search, query);

        query = query
             .Include(x => x.Korisnik)
             .Include(x => x.Subkategorija);

        if (!string.IsNullOrWhiteSpace(search.FTS))
        {
            query = query.Where(x =>
                x.Naslov.Contains(search.FTS) ||
                x.Sadrzaj.Contains(search.FTS));
        }

        if (!string.IsNullOrWhiteSpace(search.Naslov))
            query = query.Where(x => x.Naslov.Contains(search.Naslov));

        if (search.KorisnikId.HasValue)
            query = query.Where(x => x.KorisnikId == search.KorisnikId.Value);

        if (search.Premium.HasValue)
            query = query.Where(x => x.Premium == search.Premium.Value);

        if (search.SubkategorijaId.HasValue)
            query = query.Where(x => x.SubkategorijaId == search.SubkategorijaId.Value);

        if (search.Status.HasValue)
            query = query.Where(x => x.Status == search.Status.Value);

        if (search.SubkategorijaIdList != null && search.SubkategorijaIdList.Any())
            query = query.Where(x => search.SubkategorijaIdList.Contains(x.SubkategorijaId));

        if (search.KategorijaId.HasValue)
        {
            query = query.Where(x => x.Subkategorija.KategorijaId == search.KategorijaId.Value);
        }


        return query;
    }

    public void SoftDelete(int id)
    {
        var entity = Context.Postovi.Find(id);
        if (entity == null)
            throw new Exception("Post nije pronađen.");

        entity.Status = false;
        Context.SaveChanges();
    }

    public override Model.Post GetById(int id)

    {
        var entity = Context.Postovi
            .Include(x => x.Korisnik)
            .Include(x => x.Subkategorija)
            .FirstOrDefault(x => x.PostId == id);

        if (entity == null)
            throw new Exception("Post nije pronađen");

        return entity.Adapt<Model.Post>();
    }


}
