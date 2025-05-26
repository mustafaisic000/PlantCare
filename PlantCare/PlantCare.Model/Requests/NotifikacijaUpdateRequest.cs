namespace PlantCare.Model.Requests;

public class NotifikacijaUpdateRequest
{
    public string Naslov { get; set; } = null!;
    public string Sadrzaj { get; set; } = null!;
    public int KorisnikId { get; set; }
    public int? PostId { get; set; }
    public bool Procitano { get; set; }
}