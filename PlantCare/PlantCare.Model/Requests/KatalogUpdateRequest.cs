namespace PlantCare.Model.Requests;

public class KatalogUpdateRequest
{
    public string Naslov { get; set; } = null!;
    public string? Opis { get; set; }
    public bool Aktivan { get; set; }
}