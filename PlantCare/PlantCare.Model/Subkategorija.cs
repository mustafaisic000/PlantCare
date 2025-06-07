using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PlantCare.Model;
public class Subkategorija
{
    public int SubkategorijaId { get; set; }
    public string Naziv { get; set; } = null!;
    public int KategorijaId { get; set; }
}

