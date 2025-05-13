using PlantCare.Service.Database;
using System.ComponentModel.DataAnnotations;

namespace PlantCare.Services.Database;

public partial class Katalog
{
    [Key]
    public int KatalogId { get; set; }

    [Required, MaxLength(100)]
    public string Naslov { get; set; }

    public string Opis { get; set; }

    public DateTime DatumOd { get; set; }

    public DateTime DatumDo { get; set; }

    [Required]
    public int KorisnikId { get; set; }  
    public virtual Korisnik Korisnik { get; set; }

    public virtual ICollection<KatalogPost> KatalogPostovi { get; set; } = new List<KatalogPost>();
}
