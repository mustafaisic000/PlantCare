using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PlantCare.Model.SearchObjects;

public class KatalogPostSearchObject : BaseSearchObject
{
    public string PostNaslov { get; set; } = null!;
    public bool Status { get; set; } 
}