using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PlantCare.Model.Requests;
public class SubkategorijaUpdateRequest
{
    public string Naziv { get; set; } = null!;      
    public int KategorijaId { get; set; }    
}
