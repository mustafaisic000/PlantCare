using PlantCare.Services.Database;
using System.ComponentModel.DataAnnotations;

namespace PlantCare.Service.Database;

public partial class Post
{
    [Key]
    public int PostId { get; set; }          

    [Required, MaxLength(200)]
    public string Naslov { get; set; }        

    [Required]
    public string Sadrzaj { get; set; }      

    public byte[]? Slika { get; set; }    

    public DateTime DatumKreiranja { get; set; } = DateTime.Now; 

    [Required]
    public int KorisnikId { get; set; }
    public virtual Korisnik Korisnik { get; set; } = null!;
    public bool Premium { get; set; }

    [Required]
    public int SubkategorijaId { get; set; }
    public virtual Subkategorija Subkategorija { get; set; } = null!;
    public virtual ICollection<Komentar> Komentari { get; set; } = new List<Komentar>();    
    public virtual ICollection<Lajk> Lajkovi { get; set; } = new List<Lajk>();       
    public virtual ICollection<Report> Reports { get; set; } = new List<Report>();
    public virtual ICollection<KatalogPost> KatalogPostovi { get; set; } = new List<KatalogPost>();
}
