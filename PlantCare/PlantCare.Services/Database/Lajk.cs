using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;

namespace PlantCare.Service.Database;
public class Lajk
{
    [Key]
    public int LajkId { get; set; }         

    [Required]
    public int KorisnikId { get; set; }    
    public virtual Korisnik Korisnik { get; set; }

    [Required]
    public int PostId { get; set; }         
    public virtual Post Post { get; set; }

    public DateTime Datum { get; set; } = DateTime.Now;  
}