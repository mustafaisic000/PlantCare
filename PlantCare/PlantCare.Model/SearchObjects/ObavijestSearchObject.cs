using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PlantCare.Model.SearchObjects;

public class ObavijestSearchObject : BaseSearchObject
{
    public int? KorisnikId { get; set; }     // obavijesti poslane od određenog korisnika
    public string? Naslov { get; set; }      // pretraga po naslovu
    public DateTime? DatumOd { get; set; }
    public DateTime? DatumDo { get; set; }
}
