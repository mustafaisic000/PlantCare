using PlantCare.Model.DTO;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PlantCare.Model;
public class Kategorija
{
    public int KategorijaId { get; set; }
    public string Naziv { get; set; } = null!;
    public List<SubkategorijaBasic>? Subkategorije { get; set; }
}
