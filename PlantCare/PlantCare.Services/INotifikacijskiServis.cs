using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PlantCare.Services
{
    public interface INotifikacijskiServis
    {
        Task PosaljiPoruku(string poruka);
    }
}

