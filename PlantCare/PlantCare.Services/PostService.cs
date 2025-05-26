// PlantCare.Services/PostService.cs
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

        return query;
    }
}
