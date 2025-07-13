using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PlantCare.Model
{
    public class TransakcijeLog25062025
    {
        public int TransakcijeLog25062025Id { get; set; }
        public string StaraVrijednost { get; set; }
        public string NovaVrijednost { get; set; }
        public DateTime DatumIzmjene { get; set; }
        public int KorisnikId { get; set; }
        public Korisnik Korisnik { get; set; }
    }
}
