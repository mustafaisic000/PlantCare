using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PlantCare.Services.Database
{
    public class FinansijskiLimit25062025
    {
        public int FinansijskiLimit25062025Id { get; set; }
        public int KorisnikId { get; set; }
        public Korisnik Korisnik { get; set; }
        public int KategorijaTransakcije25062025Id { get; set; }
        public KategorijaTransakcije25062025 KategorijaTransakcije25062025 { get; set; }
        public decimal Limit { get; set; }
    }
}
