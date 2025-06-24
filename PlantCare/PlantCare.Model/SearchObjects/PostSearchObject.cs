using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PlantCare.Model.SearchObjects;

public class PostSearchObject : BaseSearchObject
{
    public string? FTS { get; set; }
    public string? Naslov { get; set; }         
    public int? KorisnikId { get; set; }      
    public bool? Premium { get; set; }        
    public int? SubkategorijaId { get; set; }   
    public bool? Status { get; set; }
}
