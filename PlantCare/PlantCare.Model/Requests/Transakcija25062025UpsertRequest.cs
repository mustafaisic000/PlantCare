using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PlantCare.Model.Requests
{
    public class Transakcija25062025UpsertRequest
    {
        public int KorisnikId { get; set; }
        public decimal Iznos { get; set; }
        public DateTime DatumTransakcije { get; set; }
        public string Opis { get; set; }
        public int KategorijaTransakcije25062025Id { get; set; }
        public string Status { get; set; }
    }
}
