using System;              
using System.ComponentModel.DataAnnotations;

namespace PlantCare.Services.Database;

public partial class Notifikacija
{
    [Key]
    public int NotifikacijaId { get; set; }    

    [Required, MaxLength(200)]
    public string Naslov { get; set; }
    public string Sadrzaj { get; set; }

    public DateTime Datum { get; set; } = DateTime.Now; 

    [Required]
    public int KorisnikId { get; set; }      
    public virtual Korisnik Korisnik { get; set; } = null!;

    public int? PostId { get; set; }
    public virtual Post? Post { get; set; }
    public bool Procitano { get; set; } = false; 
}
