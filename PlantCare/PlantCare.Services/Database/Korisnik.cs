using System;
using System.Collections.Generic;
using PlantCare.Model;

namespace PlantCare.Services.Database;

public partial class Korisnik
{
    public int KorisnikId { get; set; }
    public string Ime { get; set; } = null!;
    public string Prezime { get; set; } = null!;
    public DateTime? DatumRodjenja { get; set; }
    public string? Email { get; set; }
    public string? Telefon { get; set; }
    public string KorisnickoIme { get; set; } = null!;
    public string LozinkaHash { get; set; } = null!;
    public string LozinkaSalt { get; set; } = null!;
    public bool Status { get; set; } = true;
    public byte[]? Slika { get; set; }
    public int UlogaId { get; set; }
    public virtual Uloga Uloga { get; set; } = null!;


    public virtual ICollection<Post> Postovi { get; set; }  = new List<Post>();
    public virtual ICollection<Komentar> Komentari { get; set; } = new List<Komentar>();
    public virtual ICollection<Lajk> Lajkovi { get; set; }  = new List<Lajk>();
    public virtual ICollection<Notifikacija> Notifikacije { get; set; } = new List<Notifikacija>();
    public virtual ICollection<Obavijest> Obavijesti { get; set; }  = new List<Obavijest>();
    public virtual ICollection<Report> Reports { get; set; } = new List<Report>();
    public virtual ICollection<Uplata> Uplate { get; set; } = new List<Uplata>();

    public virtual ICollection<OmiljeniPost> OmiljeniPostovi { get; set; } = new List<OmiljeniPost>();
}
