using System.Collections.Generic;
using PlantCare.Service.Database;

namespace PlantCare.Service.Database
{
    public partial class Uloga
    {
        public int UlogaId { get; set; }
        public string Naziv { get; set; } = null!;
        public string? Opis { get; set; }
        public virtual ICollection<Korisnik> Korisnici { get; set; } = new List<Korisnik>();
    }
}
