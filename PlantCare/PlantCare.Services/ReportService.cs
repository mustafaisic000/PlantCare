// PlantCare.Services/ReportService.cs
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

        if (search.PostId.HasValue)
            query = query.Where(x => x.PostId == search.PostId.Value);

        return query;
    }
}
