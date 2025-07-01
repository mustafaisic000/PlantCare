using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PlantCare.Model;
public class KatalogPost
{
    public int KatalogPostId { get; set; }
    public int PostId { get; set; }
    public string PostNaslov { get; set; } = null!;
    public byte[]? PostSlika { get; set; }
    public bool Premium { get; set; }
}
