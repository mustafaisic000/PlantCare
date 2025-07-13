using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PlantCare.Model.Requests
{
    public class FinansijskiLimit25062025UpsertRequest
    {
        public int KorisnikId { get; set; }
        public int KategorijaTransakcije25062025Id { get; set; }
        public decimal Limit { get; set; }
    }
}
