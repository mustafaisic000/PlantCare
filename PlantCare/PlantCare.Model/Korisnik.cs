using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PlantCare.Model;

public class Korisnik
{
    public int KorisnikId { get; set; }
    public string Ime { get; set; } = null!;
    public string Prezime { get; set; } = null!;
    public DateTime? DatumRodjenja { get; set; }
    public string? Email { get; set; }
    public string? Telefon { get; set; }
    public string KorisnickoIme { get; set; } = null!;
    public bool Status { get; set; }
    public byte[]? Slika { get; set; }
    public int UlogaId { get; set; }
    public string UlogaNaziv { get; set; } = null!;
}
