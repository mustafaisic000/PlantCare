using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PlantCare.Model.SearchObjects;

public class KatalogPostSearchObject : BaseSearchObject
{
    public int? KatalogId { get; set; } 
    public int? PostId { get; set; }     
}