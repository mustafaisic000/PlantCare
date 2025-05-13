using System.ComponentModel.DataAnnotations;

namespace PlantCare.Service.Database;

public class Obavijest
{
    [Key]
    public int ObavijestId { get; set; }      

    [Required, MaxLength(100)]
    public string Naslov { get; set; }       

    [Required]
    public string Sadrzaj { get; set; }      

    public DateTime Datum { get; set; } = DateTime.Now;  

    [Required]
    public int KorisnikId { get; set; }
    public virtual Korisnik Korisnik { get; set; }
}
