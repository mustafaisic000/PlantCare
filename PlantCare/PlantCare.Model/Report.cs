using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PlantCare.Model;

public class Report
{
    public int ReportId { get; set; }
    public DateTime Datum { get; set; }
    public int KorisnikId { get; set; }
    public string KorisnikIme { get; set; } = null!;
    public int PostId { get; set; }
    public string PostNaslov { get; set; } = null!;
    public int BrojLajkova { get; set; }
    public int BrojOmiljenih { get; set; }
}
