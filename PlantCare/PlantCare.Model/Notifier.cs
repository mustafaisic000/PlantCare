using System;
using System.Collections.Generic;
using System.Text;

namespace PlantCare.Model
{
    public class Notifier
    {
        public Notifier()
        {
        }
        public string Email { get; set; } = null!;
        public DateTime Datum { get; set; }
        public string Tekst { get; set; } = null!;
        public string Naslov { get; set; } = null!;
    }
}

