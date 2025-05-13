using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PlantCare.Model;

public class Uloga
{
    public int UlogaId { get; set; }
    public string Naziv { get; set; } = null!;
    public string? Opis { get; set; }
}
