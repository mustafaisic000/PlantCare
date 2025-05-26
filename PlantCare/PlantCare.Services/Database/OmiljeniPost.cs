using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using PlantCare.Services.Database;

namespace PlantCare.Services.Database;

public partial class OmiljeniPost
{
    public int OmiljeniPostId { get; set; }
    public int KorisnikId { get; set; }
    public virtual Korisnik Korisnik { get; set; } = null!;
    public int PostId { get; set; }
    public virtual Post Post { get; set; } = null!;
}
