using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PlantCare.Model.SearchObjects;

public class LajkSearchObject : BaseSearchObject
{
    public int? PostId { get; set; }        
    public int? KorisnikId { get; set; }   
  
}