using System.ComponentModel.DataAnnotations;

namespace PlantCare.Services.Database;

public partial class Subkategorija
{
    [Key]
    public int SubkategorijaId { get; set; }    

    [Required, MaxLength(100)]
    public string Naziv { get; set; }          

    [Required]
    public int KategorijaId { get; set; }
    public virtual Kategorija Kategorija { get; set; } = null!;
}
