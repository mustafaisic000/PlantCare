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

    public virtual ICollection<Subkategorija> Subkategorije { get; set; } = new List<Subkategorija>();
}
