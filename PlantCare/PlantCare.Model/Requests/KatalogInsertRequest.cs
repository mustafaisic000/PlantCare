using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PlantCare.Model.Requests;

public class KatalogInsertRequest
{
    public string? Naslov { get; set; }
    public string? Opis { get; set; }
    public DateTime? DatumOd { get; set; }
    public DateTime? DatumDo { get; set; }
    public int? KorisnikId { get; set; }
}
