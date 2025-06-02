using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PlantCare.Model.DTO
{
    public class KategorijeWithSubkategorijeBasicPaged
    {
        public int KategorijaId { get; set; }
        public string Naziv { get; set; }
        public PagedResult<SubkategorijaBasic> Subkategorije { get; set; }
    }
}
