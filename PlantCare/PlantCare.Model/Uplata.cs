using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PlantCare.Model;

public class Uplata
{
    public int UplataId { get; set; }
    public decimal Iznos { get; set; }
    public DateTime Datum { get; set; }
    public string TipPretplate { get; set; } = null!;
    public int KorisnikId { get; set; }
    public string KorisnikIme { get; set; } = null!;
}

