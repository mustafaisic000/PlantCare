using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PlantCare.Model;

public class Komentar
{
    public int KomentarId { get; set; }
    public string Sadrzaj { get; set; } = null!;
    public DateTime DatumKreiranja { get; set; }
    public int KorisnikId { get; set; }
    public string KorisnickoIme { get; set; } = null!;
    public string PostNaslov { get; set; } = null!;
}
