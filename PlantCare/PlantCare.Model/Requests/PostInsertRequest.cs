using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PlantCare.Model.Requests;

public class PostInsertRequest
{
    public string Naslov { get; set; } = null!;
    public string Sadrzaj { get; set; } = null!;
    public byte[]? Slika { get; set; }
    public int KorisnikId { get; set; }
    public bool Premium { get; set; }
    public int SubkategorijaId { get; set; }
}

