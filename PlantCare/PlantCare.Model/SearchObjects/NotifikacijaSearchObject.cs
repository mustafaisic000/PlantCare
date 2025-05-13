using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PlantCare.Model.SearchObjects;

public class NotifikacijaSearchObject : BaseSearchObject
{
    public int? KorisnikId { get; set; }    
    public int? PostId { get; set; }        
    public bool? Procitano { get; set; }     
    public string? Naslov { get; set; }     
}
