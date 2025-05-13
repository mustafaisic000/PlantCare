using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PlantCare.Model.Requests;

public class UplataInsertRequest
{
    public decimal? Iznos { get; set; }
    public string? TipPretplate { get; set; }
    public int? KorisnikId { get; set; }
}
