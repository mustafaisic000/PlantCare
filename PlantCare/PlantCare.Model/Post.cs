using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PlantCare.Model;
public class Post
{
    public int PostId { get; set; }
    public string Naslov { get; set; } = null!;
    public string Sadrzaj { get; set; } = null!;
    public byte[]? Slika { get; set; }
    public DateTime DatumKreiranja { get; set; }
    public int KorisnikId { get; set; }
    public string KorisnickoIme { get; set; } = null!;
    public bool Premium { get; set; }
    public int SubkategorijaId { get; set; }
    public string SubkategorijaNaziv { get; set; } = null!;
}
