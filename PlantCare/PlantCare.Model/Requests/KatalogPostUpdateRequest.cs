using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PlantCare.Model.Requests;

public class KatalogPostUpdateRequest
{
    public int? KatalogId { get; set; }
    public int? PostId { get; set; }
}
