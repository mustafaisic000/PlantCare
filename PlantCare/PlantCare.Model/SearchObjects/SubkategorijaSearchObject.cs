using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PlantCare.Model.SearchObjects;

public class SubkategorijaSearchObject : BaseSearchObject
{
    public string? Naziv { get; set; }        
    public int? KategorijaId { get; set; }    
}