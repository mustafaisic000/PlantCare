using System;                
using System.Collections.Generic;     
using System.ComponentModel.DataAnnotations;
namespace PlantCare.Services.Database
{
    public partial class Uloga
    {
        public int UlogaId { get; set; }
        public string Naziv { get; set; } = null!;
        public string? Opis { get; set; }
        public virtual ICollection<Korisnik> Korisnici { get; set; } = new List<Korisnik>();
    }
}
