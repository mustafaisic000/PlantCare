using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PlantCare.Services.Database
{
    public class KategorijaTransakcije25062025
    {
        public int KategorijaTransakcije25062025Id { get; set; }
        public string NazivKategorije { get; set; }
        public string Tip { get; set; }
        public ICollection<Transakcija25062025> Transakcije { get; set; }

    }
}
