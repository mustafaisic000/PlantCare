using System;                           
using System.ComponentModel.DataAnnotations;
namespace PlantCare.Services.Database;

public class Obavijest
{
    [Key]
    public int ObavijestId { get; set; }      

    [Required, MaxLength(100)]
    public string Naslov { get; set; }       

    [Required]
    public string Sadrzaj { get; set; }
    [Required]
    public bool Aktivan { get; set; }
    [Required]
    public int KorisnikId { get; set; }
    public virtual Korisnik Korisnik { get; set; }
}
