using MapsterMapper;
using Microsoft.EntityFrameworkCore;
using PlantCare.Model;
using PlantCare.Model.Requests;
using PlantCare.Model.SearchObjects;
using PlantCare.Services.Database;
using System.Linq;

namespace PlantCare.Services;

public class UlogaService
    : BaseCRUDService<
         Model.Uloga,
         UlogaSearchObject,
         Database.Uloga,
         UlogaInsertRequest,
         UlogaUpdateRequest>,
      IUlogaService
{
    public UlogaService(PlantCareContext ctx, IMapper mapper)
        : base(ctx, mapper)
    {
    }

    protected override IQueryable<Database.Uloga> AddFilter(
     UlogaSearchObject search,
     IQueryable<Database.Uloga> query)
    {
        query = base.AddFilter(search, query);

        if (!string.IsNullOrWhiteSpace(search.Naziv))
            query = query.Where(x => x.Naziv.StartsWith(search.Naziv));

        return query;
    }

    protected override void BeforeInsert(
        UlogaInsertRequest request,
        Database.Uloga entity)
    {

    }

    public override void BeforeUpdate(
        UlogaUpdateRequest request,
        Database.Uloga entity)
    {

    }
}
