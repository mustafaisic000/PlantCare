using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PlantCare.Model.Requests;

public class ReportInsertRequest
{
    public int? KorisnikId { get; set; }
    public int? PostId { get; set; }
    public int? BrojLajkova { get; set; }
    public int? BrojOmiljenih { get; set; }
}
