using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PlantCare.Model;
public class KatalogPost
{
    public int KatalogPostId { get; set; }
    public int KatalogId { get; set; }
    public int PostId { get; set; }

    public virtual Katalog Katalog { get; set; } = null!;
    public virtual Post Post { get; set; } = null!;
}
