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
    public int KorisnikId { get; set; }
    public string KorisnickoIme { get; set; }=null!;
}

