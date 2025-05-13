using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PlantCare.Model.SearchObjects;

public class KorisnikSearchObject : BaseSearchObject
{
    public string? Ime { get; set; }
    public string? Prezime { get; set; }
    public string? Email { get; set; }
    public string? KorisnickoIme { get; set; }
    public int? UlogaId { get; set; }
    public bool? Status { get; set; }
    public bool IncludeUloga { get; set; }
}
