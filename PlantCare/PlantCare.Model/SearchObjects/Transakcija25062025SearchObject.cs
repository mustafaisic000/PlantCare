using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PlantCare.Model.SearchObjects
{
    public class Transakcija25062025SearchObject: BaseSearchObject
    {
        public int? KategorijaTransakcije25062025Id { get; set; }
        public DateTime? DatumTransakcijeOD { get; set; }
        public DateTime? DatumTransakcijeDO { get; set; }
    }
}
