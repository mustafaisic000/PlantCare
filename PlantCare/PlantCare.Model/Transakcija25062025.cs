using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PlantCare.Model
{
    public class Transakcija25062025
    {
        public int Transakcija25062025Id { get; set; }
        public int KorisnikId { get; set; }
        public Korisnik Korisnik { get; set; }
        public decimal Iznos { get; set; }
        public DateTime DatumTransakcije { get; set; }
        public string Opis { get; set; }
        public int KategorijaTransakcije25062025Id { get; set; }
        public KategorijaTransakcije25062025 KategorijaTransakcije25062025 { get; set; }
        public string Status { get; set; }
    }
}
