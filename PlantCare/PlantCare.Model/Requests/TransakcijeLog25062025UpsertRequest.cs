using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PlantCare.Model.Requests
{
    public class TransakcijeLog25062025UpsertRequest
    {
        public string StaraVrijednost { get; set; }
        public string NovaVrijednost { get; set; }
        public DateTime DatumIzmjene { get; set; }
        public int KorisnikId { get; set; }
    }
}
