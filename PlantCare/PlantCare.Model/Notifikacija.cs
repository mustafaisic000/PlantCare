using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PlantCare.Model;
public class Notifikacija
{
    public int NotifikacijaId { get; set; }
    public string Naslov { get; set; } = null!;
    public string Sadrzaj { get; set; } = null!;
    public DateTime Datum { get; set; }
    public string KorisnikIme { get; set; } = null!;
    public string KorisnikPrezime { get; set; } = null!;
    public int? PostId { get; set; }
    public string? PostNaslov { get; set; }
    public bool Procitano { get; set; }
}
