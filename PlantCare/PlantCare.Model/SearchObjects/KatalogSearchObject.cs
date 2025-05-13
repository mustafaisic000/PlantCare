using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PlantCare.Model.SearchObjects;

public class KatalogSearchObject : BaseSearchObject
{
    public string? Naslov { get; set; }          
    public int? KorisnikId { get; set; }        
    public DateTime? DatumOd { get; set; }       
    public DateTime? DatumDo { get; set; }       
}