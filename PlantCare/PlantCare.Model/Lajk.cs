using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PlantCare.Model;
public class Lajk
{
    public int LajkId { get; set; }
    public int KorisnikId { get; set; }
    public string KorisnickoIme { get; set; } = null!;
    public int PostId { get; set; }
    public string PostNaslov { get; set; } = null!;
    public DateTime Datum { get; set; }
}
