using System;                   
using System.ComponentModel.DataAnnotations;

namespace PlantCare.Services.Database;

public class Report
{
    [Key]
    public int ReportId { get; set; }

    public DateTime Datum { get; set; } = DateTime.Now;

    [Required]
    public int KorisnikId { get; set; }
    public virtual Korisnik Korisnik { get; set; }

    [Required]
    public int PostId { get; set; }
    public virtual Post Post { get; set; }
    public int BrojLajkova { get; set; } = 0;
    public int BrojOmiljenih { get; set; } = 0;
    public int BrojKomentara { get; set; } = 0;
}