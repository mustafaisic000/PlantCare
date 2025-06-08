using Microsoft.EntityFrameworkCore.Query;
using PlantCare.Model;
using PlantCare.Model.Requests;
using PlantCare.Model.SearchObjects;
using PlantCare.Services;

namespace PlantCare.WebAPI.Controllers
{
    public class ReportController : BaseCRUDController<Report, ReportSearchObject, ReportInsertRequest, ReportUpdateRequest>
    {
        public ReportController(IReportService service)
            : base(service)
        {
        }
    }
}
