using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PlantCare.Model.Requests;
public class ObavijestUpdateRequest
{
    public string Naslov { get; set; } = null!;
    public string Sadrzaj { get; set; } = null!;
}
