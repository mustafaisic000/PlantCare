using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PlantCare.Model.SearchObjects;

public class OmiljeniPostSearchObject : BaseSearchObject
{
    public int? KorisnikId { get; set; }   
    public int? PostId { get; set; }        
}
