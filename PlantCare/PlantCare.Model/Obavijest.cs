using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PlantCare.Model;

public class Obavijest
{
    public int ObavijestId { get; set; }
    public string Naslov { get; set; } = null!;
    public string Sadrzaj { get; set; } = null!;
    public DateTime Datum { get; set; }

    public int KorisnikId { get; set; }
    public string KorisnickoIme { get; set; } = null!;

}
