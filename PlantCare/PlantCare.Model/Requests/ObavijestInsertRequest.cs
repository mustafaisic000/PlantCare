using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PlantCare.Model.Requests;
public class ObavijestInsertRequest
{
    public string? Naslov { get; set; }
    public string? Sadrzaj { get; set; }
    public int? KorisnikId { get; set; }
}
