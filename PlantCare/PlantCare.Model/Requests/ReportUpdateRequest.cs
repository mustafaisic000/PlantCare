namespace PlantCare.Model.Requests;

public class ReportUpdateRequest
{
    public int KorisnikId { get; set; }
    public int PostId { get; set; }
    public int BrojLajkova { get; set; }
    public int BrojOmiljenih { get; set; }
    // leave Datum on the server side (it stays at insertion value)
}
