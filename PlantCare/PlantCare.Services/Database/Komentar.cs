using System.ComponentModel.DataAnnotations;

namespace PlantCare.Service.Database;
public class Komentar
{
    [Key]
    public int KomentarId { get; set; }      

    [Required]
    public string Sadrzaj { get; set; }      

    public DateTime DatumKreiranja { get; set; } = DateTime.Now;  

    // Strani ključevi
    [Required]
    public int KorisnikId { get; set; }     
    public virtual Korisnik Korisnik { get; set; }

    [Required]
    public int PostId { get; set; }         
    public virtual Post Post { get; set; }
}
