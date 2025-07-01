namespace PlantCare.Model.Requests;

public class KatalogInsertRequest
{
    public string Naslov { get; set; } = null!;
    public string? Opis { get; set; }
    public bool Aktivan { get; set; }
    public int KorisnikId { get; set; }
}