using System.Collections.Generic;        
using System.ComponentModel.DataAnnotations;

namespace PlantCare.Services.Database;

public class Kategorija
{
    [Key]
    public int KategorijaId { get; set; }      

    [Required, MaxLength(100)]
    public string Naziv { get; set; }         

    public virtual ICollection<Subkategorija> Subkategorije { get; set; } = new List<Subkategorija>();
}

