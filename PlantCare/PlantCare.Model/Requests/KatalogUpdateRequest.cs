namespace PlantCare.Model.Requests;

public class KatalogUpdateRequest
{
    public string Naslov { get; set; } = null!;
    public string? Opis { get; set; }
    public DateTime DatumOd { get; set; }
    public DateTime DatumDo { get; set; }
    public int KorisnikId { get; set; }
}