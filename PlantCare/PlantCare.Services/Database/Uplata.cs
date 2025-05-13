using System.ComponentModel.DataAnnotations;

namespace PlantCare.Service.Database;

public partial class Uplata
{
    [Key]
    public int UplataId { get; set; }      

    [Required]
    public decimal Iznos { get; set; }     

    public DateTime Datum { get; set; } = DateTime.Now;  

    [Required, MaxLength(50)]
    public string TipPretplate { get; set; }

    [Required]
    public int KorisnikId { get; set; }   
    public virtual Korisnik Korisnik { get; set; }
}
