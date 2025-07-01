using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PlantCare.Model.SearchObjects;

public class KorisnikSearchObject : BaseSearchObject
{
    public string? ImeGTE { get; set; }
    public string? PrezimeGTE { get; set; }
    public string? Email { get; set; }
    public string? KorisnickoImeGTE { get; set; }
    public int? UlogaId { get; set; }
    public bool? Status { get; set; }
    public bool? IncludeUloga { get; set; }
}
