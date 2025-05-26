namespace PlantCare.Model.Requests;

public class UplataUpdateRequest
{
    public decimal Iznos { get; set; }
    public string TipPretplate { get; set; } = null!;
    public int KorisnikId { get; set; }

}
