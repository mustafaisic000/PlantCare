using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PlantCare.Model;

public class PagedResult<T>
{
    public int? Count { get; set; }
    public IList<T> ResultList { get; set; }
}