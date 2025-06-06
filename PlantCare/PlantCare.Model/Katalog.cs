﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PlantCare.Model;

public class Katalog
{
    public int KatalogId { get; set; }
    public string Naslov { get; set; } = null!;
    public string? Opis { get; set; }
    public DateTime DatumOd { get; set; }
    public DateTime DatumDo { get; set; }

    public int KorisnikId { get; set; }
    public Korisnik Korisnik { get; set; } = null!;

    public virtual ICollection<KatalogPost> KatalogPostovi { get; set; } = new List<KatalogPost>();
}
