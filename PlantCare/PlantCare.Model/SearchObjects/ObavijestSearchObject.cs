using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PlantCare.Model.SearchObjects;

public class ObavijestSearchObject : BaseSearchObject
{
    public int? KorisnikId { get; set; }    
    public string? Naslov { get; set; }      
    public DateTime? DatumOd { get; set; }
    public DateTime? DatumDo { get; set; }
}
