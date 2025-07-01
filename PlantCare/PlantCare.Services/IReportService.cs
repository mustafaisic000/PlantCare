using PlantCare.Model;
using PlantCare.Model.Requests;
using PlantCare.Model.SearchObjects;

namespace PlantCare.Services;

public interface IReportService
    : ICRUDService<
        Report,
        ReportSearchObject,
        ReportInsertRequest,
        ReportUpdateRequest>
{
    void Delete(int id);
}
