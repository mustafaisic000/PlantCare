﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PlantCare.Model.Requests;

public class KorisnikMobileUpdateRequest
{
    public string? KorisnickoIme { get; set; }
    public string? Ime { get; set; }
    public string? Prezime { get; set; }
    public string? Telefon { get; set; }
    public string? Email { get; set; }
    public string? DatumRodjenja { get; set; }
    public string? Lozinka { get; set; }     
    public string? LozinkaPotvrda { get; set; }
    public byte[]? Slika { get; set; }
}
