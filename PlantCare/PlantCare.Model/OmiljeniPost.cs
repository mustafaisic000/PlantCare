using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PlantCare.Model;
public class OmiljeniPost
{
    public int OmiljeniPostId { get; set; }
    public int KorisnikId { get; set; }
    public string KorisnikIme { get; set; } = null!;
    public int PostId { get; set; }
    public string PostNaslov { get; set; } = null!;
}

