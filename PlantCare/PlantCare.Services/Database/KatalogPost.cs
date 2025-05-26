using System.ComponentModel.DataAnnotations;

namespace PlantCare.Services.Database;

public partial class KatalogPost
{
    [Key]
    public int KatalogPostId { get; set; }

    [Required]
    public int KatalogId { get; set; }
    public virtual Katalog Katalog { get; set; } = null!;

    [Required]
    public int PostId { get; set; }
    public virtual Post Post { get; set; } = null!;
}
