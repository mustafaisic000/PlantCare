using Microsoft.EntityFrameworkCore;
using PlantCare.Services.Database;
using PlantCare.Services.Helper;
using System;
using System.Collections.Generic;



namespace PlantCare.Services.Database;

public partial class PlantCareContext: DbContext
{
    public PlantCareContext()
    {

    }
    public PlantCareContext(DbContextOptions<PlantCareContext> options):base(options) { }

    public DbSet<Korisnik> Korisnici { get; set; }
    public DbSet<Uloga> Uloge { get; set; }
    public DbSet<Post> Postovi { get; set; }
    public DbSet<Kategorija> Kategorije { get; set; }
    public DbSet<Subkategorija> Subkategorije { get; set; }
    public DbSet<Katalog> Katalog { get; set; }
    public DbSet<Komentar> Komentari { get; set; }
    public DbSet<Lajk> Lajkovi { get; set; }
    public DbSet<Notifikacija> Notifikacije { get; set; }
    public DbSet<Obavijest> Obavijesti { get; set; }
    public DbSet<Report> Reporti { get; set; }
    public DbSet<Uplata> Uplate { get; set; }
    public DbSet<KatalogPost> KatalogPostovi { get; set; }
    public DbSet<OmiljeniPost> OmiljeniPostovi { get; set; }


    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        modelBuilder.Entity<Korisnik>()
            .HasOne(k => k.Uloga)
            .WithMany(u => u.Korisnici)
            .HasForeignKey(k => k.UlogaId)
            .OnDelete(DeleteBehavior.Restrict);

        modelBuilder.Entity<Uplata>()
            .Property(u => u.Iznos)
            .HasPrecision(18, 2);

        modelBuilder.Entity<KatalogPost>()
            .HasOne(kp => kp.Katalog)
            .WithMany(k => k.KatalogPostovi)
            .HasForeignKey(kp => kp.KatalogId)
            .OnDelete(DeleteBehavior.Restrict);

        modelBuilder.Entity<KatalogPost>()
            .HasOne(kp => kp.Post)
            .WithMany(p => p.KatalogPostovi)
            .HasForeignKey(kp => kp.PostId)
            .OnDelete(DeleteBehavior.Restrict);

        modelBuilder.Entity<Komentar>()
            .HasOne(c => c.Post)
            .WithMany(p => p.Komentari)
            .HasForeignKey(c => c.PostId)
           .OnDelete(DeleteBehavior.Restrict);

        modelBuilder.Entity<Komentar>()
            .HasOne(c => c.Korisnik)
            .WithMany(k => k.Komentari)
            .HasForeignKey(c => c.KorisnikId)
            .OnDelete(DeleteBehavior.Cascade);

        modelBuilder.Entity<Lajk>()
            .HasOne(l => l.Post)
            .WithMany(p => p.Lajkovi)
            .HasForeignKey(l => l.PostId)
            .OnDelete(DeleteBehavior.Restrict); 

        modelBuilder.Entity<Lajk>()         
            .HasOne(l => l.Korisnik)
            .WithMany(k => k.Lajkovi)
            .HasForeignKey(l => l.KorisnikId)
            .OnDelete(DeleteBehavior.Cascade);

        modelBuilder.Entity<Report>()
            .HasOne(r => r.Post)
            .WithMany(p => p.Reports)       
            .HasForeignKey(r => r.PostId)
            .OnDelete(DeleteBehavior.Restrict);

        modelBuilder.Entity<Report>()
            .HasOne(r => r.Korisnik)
            .WithMany(k => k.Reports)
            .HasForeignKey(r => r.KorisnikId)
            .OnDelete(DeleteBehavior.Cascade);

        modelBuilder.Entity<OmiljeniPost>()
            .HasOne(op => op.Korisnik)
            .WithMany(k => k.OmiljeniPostovi)   
            .HasForeignKey(op => op.KorisnikId)
            .OnDelete(DeleteBehavior.Cascade); 

        modelBuilder.Entity<OmiljeniPost>()
            .HasOne(op => op.Post)
            .WithMany(p => p.OmiljeniPostovi)   
            .HasForeignKey(op => op.PostId)
            .OnDelete(DeleteBehavior.Restrict);  


        base.OnModelCreating(modelBuilder);

        // ── Roles ───────────────────────────────────────────────────────────
        modelBuilder.Entity<Uloga>().HasData(
            new Uloga
            {
                UlogaId = 1,
                Naziv = "Administrator",
                Opis = "Ima potpunu kontrolu nad sistemom, uključujući korisnike, objave, kataloge i administraciju."
            },
            new Uloga
            {
                UlogaId = 2,
                Naziv = "Premium User",
                Opis = "Korisnik sa premium pretplatom. Ima pristup ekskluzivnim sadržajima i dodatnim funkcijama."
            },
            new Uloga
            {
                UlogaId = 3,
                Naziv = "User",
                Opis = "Standardni korisnik sa osnovnim mogućnostima korištenja platforme."
            }
        );

        // ── Users ───────────────────────────────────────────────────────────
        modelBuilder.Entity<Korisnik>().HasData(
            new Korisnik
            {
                KorisnikId = 1,
                Ime = "Ana",
                Prezime = "Admin",
                Email = "ana.admin@plantcare.com",
                Telefon = null,
                KorisnickoIme = "ana_admin",
                DatumRodjenja = new DateTime(1991, 4, 12),
                LozinkaHash = "tPW/IOLa2TZIKYSA50IDeaJKYtg=",
                LozinkaSalt = "2G2wAwYkdFgpMleomcwelg==",
                Status = true,
                Slika = SlikaHelper.GetSlika(0),
                UlogaId = 1
            },
            new Korisnik
            {
                KorisnikId = 2,
                Ime = "Marko",
                Prezime = "Mod",
                Email = "marko.mod@plantcare.com",
                Telefon = null,
                KorisnickoIme = "marko_mod",
                LozinkaHash = "tPW/IOLa2TZIKYSA50IDeaJKYtg=",
                DatumRodjenja = new DateTime(1995, 4, 12),
                LozinkaSalt = "2G2wAwYkdFgpMleomcwelg==",
                Slika = SlikaHelper.GetSlika(1),
                Status = true,
                UlogaId = 2
            },
            new Korisnik
            {
                KorisnikId = 3,
                Ime = "Ivan",
                Prezime = "Ivić",
                Email = "ivan.ivic@plantcare.com",
                Telefon = null,
                KorisnickoIme = "ivan",
                LozinkaHash = "tPW/IOLa2TZIKYSA50IDeaJKYtg=",
                DatumRodjenja = new DateTime(1995, 4, 12),
                LozinkaSalt = "2G2wAwYkdFgpMleomcwelg==",
                Status = true,
                Slika = SlikaHelper.GetSlika(2),
                UlogaId = 3
            },
            new Korisnik
            {
                KorisnikId = 4,
                Ime = "Maja",
                Prezime = "Majić",
                Email = "maja.majic@plantcare.com",
                Telefon = null,
                KorisnickoIme = "majam",
                LozinkaHash = "tPW/IOLa2TZIKYSA50IDeaJKYtg=",
                LozinkaSalt = "2G2wAwYkdFgpMleomcwelg==",
                DatumRodjenja = new DateTime(2001, 4, 11),
                Status = true,
                Slika = SlikaHelper.GetSlika(3),
                UlogaId = 3
            },
            new Korisnik
            {
                KorisnikId = 5,
                Ime = "Sara",
                Prezime = "Sarić",
                Email = "sara.saric@plantcare.com",
                Telefon = null,
                KorisnickoIme = "saras",
                LozinkaHash = "tPW/IOLa2TZIKYSA50IDeaJKYtg=",
                LozinkaSalt = "2G2wAwYkdFgpMleomcwelg==",
                DatumRodjenja = new DateTime(2000, 4, 12),
                Slika = SlikaHelper.GetSlika(4),
                Status = true,
                UlogaId = 3
            }
        );

        
        modelBuilder.Entity<Kategorija>().HasData(
            new Kategorija { KategorijaId = 1, Naziv = "Sobne biljke" },
            new Kategorija { KategorijaId = 2, Naziv = "Vrtne biljke" },
            new Kategorija { KategorijaId = 3, Naziv = "Savjeti za vrtlarstvo" },
            new Kategorija { KategorijaId = 4, Naziv = "Problemi u njezi biljaka" }
);


        // ── Subcategories ───────────────────────────────────────────────────
        modelBuilder.Entity<Subkategorija>().HasData(
           new Subkategorija { SubkategorijaId = 1, KategorijaId = 1, Naziv = "Sukulenti" },
           new Subkategorija { SubkategorijaId = 2, KategorijaId = 1, Naziv = "Biljke za sjenu" },
           new Subkategorija { SubkategorijaId = 3, KategorijaId = 1, Naziv = "Cvjetnice" },
           new Subkategorija { SubkategorijaId = 4, KategorijaId = 2, Naziv = "Višegodišnje biljke" },
           new Subkategorija { SubkategorijaId = 5, KategorijaId = 2, Naziv = "Povrće" },
           new Subkategorija { SubkategorijaId = 6, KategorijaId = 2, Naziv = "Cvjetne gredice" },
           new Subkategorija { SubkategorijaId = 7, KategorijaId = 3, Naziv = "Zalijevanje i đubrenje" },
           new Subkategorija { SubkategorijaId = 8, KategorijaId = 3, Naziv = "Zemlja i presađivanje" },
           new Subkategorija { SubkategorijaId = 9, KategorijaId = 3, Naziv = "Razmnožavanje biljaka" },
           new Subkategorija { SubkategorijaId = 10, KategorijaId = 4, Naziv = "Suzbijanje štetočina" },
           new Subkategorija { SubkategorijaId = 11, KategorijaId = 4, Naziv = "Žutilo listova" },
           new Subkategorija { SubkategorijaId = 12, KategorijaId = 4, Naziv = "Trulež korijena" }



        );

        // ── Posts ────────────────────────────────────────────────────────────
        modelBuilder.Entity<Post>().HasData(
            new Post
            {
                PostId = 1,
                Naslov = "Pomoć sa sukulentima",
                Sadrzaj = "Listovi mojih sukulenata postali su mekani i prozirni. Mislim da ih previše zalijevam. Šta da radim prije nego se potpuno raspadnu?",
                DatumKreiranja = new DateTime(2024, 3, 1, 10, 0, 0),
                KorisnikId = 3,
                SubkategorijaId = 1,
                Slika = SlikaHelper.GetSlika(5),
                Premium = false,
                Status = true
            },
            new Post
            {
                PostId = 2,
                Naslov = "Moje iskustvo sa višegodišnjim biljkama",
                Sadrzaj = "Prošle godine sam posadio lavandu i ruzmarin. Prezimili su bez problema, a zahtijevaju minimalnu njegu. Preporučujem svakome.",
                DatumKreiranja = new DateTime(2024, 4, 3, 9, 15, 0),
                KorisnikId = 4,
                SubkategorijaId = 4,
                Slika = SlikaHelper.GetSlika(6),
                Premium = false,
                Status = true
            },
            new Post
            {
                PostId = 3,
                Naslov = "Biljne vaške – prirodno rješenje?",
                Sadrzaj = "Na ružama sam primijetila biljne vaške. Čula sam da sapunica pomaže. Ima li neko iskustvo s tim?",
                DatumKreiranja = new DateTime(2024, 5, 2, 11, 30, 0),
                KorisnikId = 5,
                SubkategorijaId = 10,
                Slika = SlikaHelper.GetSlika(7),
                Premium = false,
                Status = true
            },
            new Post
            {
                PostId = 4,
                Naslov = "Koliko često zalijevati mentu u tegli?",
                Sadrzaj = "Imam mentu na prozoru, ali nisam siguran kad je previše vode. Ponekad uvene iako je zemlja vlažna.",
                DatumKreiranja = new DateTime(2024, 5, 20, 12, 0, 0),
                KorisnikId = 2,
                SubkategorijaId = 7,
                Slika = SlikaHelper.GetSlika(8),
                Premium = false,
                Status = true
            },
            new Post
            {
                PostId = 5,
                Naslov = "Kako presađujem monsteru",
                Sadrzaj = "Koristim mješavinu zemlje za sobne biljke, perlita i malo kokosovog vlakna. Presađujem jednom godišnje u proljeće.",
                DatumKreiranja = new DateTime(2024, 6, 5, 14, 20, 0),
                KorisnikId = 4,
                SubkategorijaId = 8,
                Slika = SlikaHelper.GetSlika(9),
                Premium = false,
                Status = true
            },

            // ───── Premium postovi sa edukativnim savjetima ───────────────
            new Post
            {
                PostId = 6,
                Naslov = "Kako pravilno njegovati sukulente tokom godine",
                Sadrzaj = "Sukulenti trebaju mnogo svjetlosti, ali ne direktno sunce u podne. U proljeće i ljeto ih zalijevajte svakih 10-14 dana, a zimi samo jednom mjesečno. Koristite propusnu zemlju sa dodatkom pijeska ili perlita.",
                DatumKreiranja = new DateTime(2024, 2, 15, 8, 30, 0),
                KorisnikId = 1,
                SubkategorijaId = 1,
                Slika = SlikaHelper.GetSlika(10),
                Premium = true,
                Status = true
            },
            new Post
            {
                PostId = 7,
                Naslov = "Top 5 višegodišnjih biljaka za početnike",
                Sadrzaj = "Lavanda, žalfija, domaća metvica, hosta i dan-noć su otporne višegodišnje biljke. Pogodne su za klimu BiH i zahtijevaju minimalno održavanje nakon sadnje.",
                DatumKreiranja = new DateTime(2024, 3, 28, 10, 45, 0),
                KorisnikId = 1,
                SubkategorijaId = 4,
                Slika = SlikaHelper.GetSlika(11),
                Premium = true,
                Status = true
            },
            new Post
            {
                PostId = 8,
                Naslov = "Razmnožavanje sobnih biljaka: 3 provjerene metode",
                Sadrzaj = "Reznice u vodi, podjela korijena i slojevanje su tri najčešća načina razmnožavanja biljaka. Najlakši način za početnike je puštanje korijena u vodi iz zdravog lista ili stabljike.",
                DatumKreiranja = new DateTime(2024, 4, 14, 13, 10, 0),
                KorisnikId = 1,
                SubkategorijaId = 9,
                Slika = SlikaHelper.GetSlika(12),
                Premium = true,
                Status = true
            },
            new Post
            {
                PostId = 9,
                Naslov = "Cvjetnice koje uspijevaju u stanu",
                Sadrzaj = "Spatifilum, anthurium i afrička ljubičica odlično uspijevaju u zatvorenim prostorima. Potrebna im je filtrirana svjetlost, umjerena vlaga i redovno uklanjanje osušenih cvjetova.",
                DatumKreiranja = new DateTime(2024, 5, 10, 16, 0, 0),
                KorisnikId = 1,
                SubkategorijaId = 3,
                Slika = SlikaHelper.GetSlika(13),
                Premium = true,
                Status = true
            },
            new Post
            {
                PostId = 10,
                Naslov = "Kako spriječiti trulež korijena",
                Sadrzaj = "Trulež korijena se najčešće javlja zbog prekomjernog zalijevanja i loše drenaže. Obavezno koristite posude s rupama i izbjegavajte zalijevanje ako je zemlja još vlažna. Uklonite zaražene dijelove čim ih primijetite.",
                DatumKreiranja = new DateTime(2024, 6, 22, 10, 0, 0),
                KorisnikId = 1,
                SubkategorijaId = 12,
                Slika = SlikaHelper.GetSlika(14),
                Premium = true,
                Status = true
            }
        );

        modelBuilder.Entity<Komentar>().HasData(
            new Komentar
            {
                KomentarId = 1,
                Sadrzaj = "Imao sam isti problem. Pusti da se zemlja potpuno osuši prije nego što ponovo zaliješ i trebalo bi pomoći.",
                DatumKreiranja = new DateTime(2024, 3, 2, 12, 0, 0),
                KorisnikId = 4,
                PostId = 1
            },
            new Komentar
            {
                KomentarId = 2,
                Sadrzaj = "Sukulenti zaista ne vole stalnu vlagu. Zalijevaj ih tek kad primijetiš da je zemlja potpuno suha.",
                DatumKreiranja = new DateTime(2024, 3, 3, 9, 15, 0),
                KorisnikId = 5,
                PostId = 1
            },

            new Komentar
            {
                KomentarId = 3,
                Sadrzaj = "Slažem se! I meni su lavanda i ruzmarin preživjeli zimu bez ikakvih problema.",
                DatumKreiranja = new DateTime(2024, 4, 4, 10, 30, 0),
                KorisnikId = 3,
                PostId = 2
            },

            new Komentar
            {
                KomentarId = 4,
                Sadrzaj = "Sapunica (blagi deterdžent i voda) mi je pomogla kod vaški, ali moraš paziti da ne spališ biljku.",
                DatumKreiranja = new DateTime(2024, 5, 3, 8, 20, 0),
                KorisnikId = 1,
                PostId = 3
            },

            new Komentar
            {
                KomentarId = 5,
                Sadrzaj = "Menta ne voli previše vode. Ja je zalijevam samo kad listovi počnu malo da se opuštaju.",
                DatumKreiranja = new DateTime(2024, 5, 21, 17, 45, 0),
                KorisnikId = 5,
                PostId = 4
            },

            new Komentar
            {
                KomentarId = 6,
                Sadrzaj = "Kombinacija perlita i kokosovog vlakna zvuči odlično! Probaću to sljedeći put kad presađujem.",
                DatumKreiranja = new DateTime(2024, 6, 6, 15, 30, 0),
                KorisnikId = 2,
                PostId = 5
            },

            new Komentar
            {
                KomentarId = 7,
                Sadrzaj = "Odličan vodič! Nisam znao da zimi treba zalijevati samo jednom mjesečno.",
                DatumKreiranja = new DateTime(2024, 2, 16, 9, 10, 0),
                KorisnikId = 3,
                PostId = 6
            },

            new Komentar
            {
                KomentarId = 8,
                Sadrzaj = "Super izbor biljaka! Hosta mi je baš draga jer traži malo pažnje.",
                DatumKreiranja = new DateTime(2024, 3, 29, 11, 0, 0),
                KorisnikId = 4,
                PostId = 7
            },

            new Komentar
            {
                KomentarId = 9,
                Sadrzaj = "Nikad nisam probao slojevanje, zvuči zanimljivo. Hvala na objašnjenju!",
                DatumKreiranja = new DateTime(2024, 4, 15, 14, 10, 0),
                KorisnikId = 5,
                PostId = 8
            },

            new Komentar
            {
                KomentarId = 10,
                Sadrzaj = "Afrička ljubičica mi uspijeva već dvije godine, totalno se slažem sa listom.",
                DatumKreiranja = new DateTime(2024, 5, 11, 18, 20, 0),
                KorisnikId = 2,
                PostId = 9
            }
        );

        modelBuilder.Entity<Lajk>().HasData(
            new Lajk { LajkId = 1, KorisnikId = 4, PostId = 1, Datum = new DateTime(2024, 3, 1, 12, 30, 0) },
            new Lajk { LajkId = 2, KorisnikId = 5, PostId = 1, Datum = new DateTime(2024, 3, 1, 13, 0, 0) },
            new Lajk { LajkId = 3, KorisnikId = 3, PostId = 2, Datum = new DateTime(2024, 4, 10, 10, 0, 0) },
            new Lajk { LajkId = 4, KorisnikId = 1, PostId = 5, Datum = new DateTime(2024, 5, 6, 11, 0, 0) },
            new Lajk { LajkId = 5, KorisnikId = 3, PostId = 5, Datum = new DateTime(2024, 5, 6, 11, 30, 0) },
            new Lajk { LajkId = 6, KorisnikId = 5, PostId = 4, Datum = new DateTime(2024, 5, 5, 15, 0, 0) },
            new Lajk { LajkId = 7, KorisnikId = 2, PostId = 6, Datum = new DateTime(2024, 7, 1, 12, 0, 0) }
        );

        modelBuilder.Entity<Notifikacija>().HasData(
    new Notifikacija
    {
        NotifikacijaId = 1,
        Naslov = "Novi lajk",
        Sadrzaj = "Vaš post je dobio novi lajk.",
        Datum = new DateTime(2024, 3, 1, 12, 30, 0),
        KorisnikId = 3,
        PostId = 1,
        Procitano = false
    },
    new Notifikacija
    {
        NotifikacijaId = 2,
        Naslov = "Novi komentar",
        Sadrzaj = "Vaš post je komentarisao drugi korisnik.",
        Datum = new DateTime(2024, 4, 11, 16, 0, 0),
        KorisnikId = 4,
        PostId = 2,
        Procitano = false
    },
    new Notifikacija
    {
        NotifikacijaId = 3,
        Naslov = "Novi komentar",
        Sadrzaj = "Dobili ste novi komentar.",
        Datum = new DateTime(2024, 6, 16, 11, 0, 0),
        KorisnikId = 2,
        PostId = 5,
        Procitano = false
    },
    new Notifikacija
    {
        NotifikacijaId = 4,
        Naslov = "Novi komentar",
        Sadrzaj = "Neko je komentarisao vaš post.",
        Datum = new DateTime(2024, 7, 2, 15, 0, 0),
        KorisnikId = 1,
        PostId = 6,
        Procitano = false
    },
    new Notifikacija
    {
        NotifikacijaId = 5,
        Naslov = "Novi komentar",
        Sadrzaj = "Vaš post je upravo komentiran.",
        Datum = new DateTime(2024, 5, 6, 9, 0, 0),
        KorisnikId = 4,
        PostId = 4,
        Procitano = false
    }
);


        // ── Announcements ────────────────────────────────────────────────────
        modelBuilder.Entity<Obavijest>().HasData(
             new Obavijest
             {
                 ObavijestId = 1,
                 Naslov = "Dobrodošli na PlantCare",
                 Sadrzaj = "Pozdrav i dobrodošli na PlantCare! Ova platforma je namijenjena ljubiteljima biljaka za razmjenu savjeta, postavljanje pitanja i međusobnu pomoć u njezi biljaka.",
                 Aktivan = true,
                 KorisnikId = 1
             },
             new Obavijest
             {
                 ObavijestId = 2,
                 Naslov = "Proljetni događaj u zajednici",
                 Sadrzaj = "Pridružite se našem proljetnom događaju 15. maja! Podijelite svoj napredak i savjete s drugima. Najbolji vrtovi osvajaju nagrade!",
                 Aktivan = true,
                 KorisnikId = 1
             },
             new Obavijest
             {
                 ObavijestId = 3,
                 Naslov = "Najavljena tehnička održavanja",
                 Sadrzaj = "Platforma PlantCare će biti privremeno nedostupna 1. juna od 00:00 sati zbog planiranog održavanja. Hvala na strpljenju!",
                 Aktivan = false,
                 KorisnikId = 1
             }
         );


        // ── Favorites ────────────────────────────────────────────────────────
        modelBuilder.Entity<OmiljeniPost>().HasData(
            new OmiljeniPost { OmiljeniPostId = 1, KorisnikId = 3, PostId = 2 },
            new OmiljeniPost { OmiljeniPostId = 2, KorisnikId = 4, PostId = 5 },
            new OmiljeniPost { OmiljeniPostId = 3, KorisnikId = 5, PostId = 1 }
        );

        // ── Reports ─────────────────────────────────────────────────────────
        modelBuilder.Entity<Report>().HasData(
     new Report
     {
         ReportId = 1,
         PostId = 4,
         KorisnikId = 5,
         Datum = new DateTime(2024, 5, 6, 10, 0, 0),
         BrojLajkova = 13,
         BrojOmiljenih = 7,
         BrojKomentara = 5
     },
     new Report
     {
         ReportId = 2,
         PostId = 3,
         KorisnikId = 3,
         Datum = new DateTime(2024, 2, 21, 14, 0, 0),
         BrojLajkova = 4,
         BrojOmiljenih = 2,
         BrojKomentara = 1
     },
     new Report
     {
         ReportId = 3,
         PostId = 2,
         KorisnikId = 2,
         Datum = new DateTime(2024, 6, 10, 9, 30, 0),
         BrojLajkova = 9,
         BrojOmiljenih = 3,
         BrojKomentara = 6
     }
 );


        // ── Payments ────────────────────────────────────────────────────────
        modelBuilder.Entity<Uplata>().HasData(
            new Uplata
            {
                UplataId = 1,
                KorisnikId = 3,
                Iznos = 19.99m,
                Datum = new DateTime(2024, 2, 15, 13, 0, 0),
            },
            new Uplata
            {
                UplataId = 2,
                KorisnikId = 5,
                Iznos = 9.99m,
                Datum = new DateTime(2024, 4, 10, 11, 30, 0),
            },
            new Uplata
            {
                UplataId = 3,
                KorisnikId = 4,
                Iznos = 14.50m,
                Datum = new DateTime(2024, 7, 22, 17, 45, 0),
            }
        );

        // ── Catalog ─────────────────────────────────────────────────────────
        modelBuilder.Entity<Katalog>().HasData(
            new Katalog
            {
                KatalogId = 1,
                Naslov = "Biljka mjeseca – Aloe Vera",
                Opis = "Zbog otpornosti i koristi za njegu kože, Aloe Vera je biljka juna.",
                Aktivan=true,
                KorisnikId = 1
            },
            new Katalog
            {
                KatalogId = 2,
                Naslov = "Najviše lajkova – Sukulenti",
                Opis = "Postovi o sukulentima su izazvali najveću pažnju i reakcije korisnika.",
                Aktivan = false,
                KorisnikId = 1
            },
            new Katalog
            {
                KatalogId = 3,
                Naslov = "Preporuka urednika",
                Opis = "Odabrani postovi koji sadrže korisne, provjerene i edukativne savjete za uzgoj biljaka.",
                Aktivan = false,
                KorisnikId = 1
            },
            new Katalog
            {
                KatalogId = 4,
                Naslov = "Najljepša ruža u vrtu",
                Opis = "Estetski najljepši post o ružama koji je zabilježen ovog mjeseca.",
                Aktivan = false,
                KorisnikId = 1
            }
        );

        modelBuilder.Entity<KatalogPost>().HasData(
    // Biljka mjeseca – Aloe Vera
            new KatalogPost { KatalogPostId = 1, KatalogId = 1, PostId = 6 }, // Premium savjet za sukulente
            new KatalogPost { KatalogPostId = 2, KatalogId = 1, PostId = 1 }, // Forum post o sukulentima

            // Najviše lajkova – Sukulenti
            new KatalogPost { KatalogPostId = 3, KatalogId = 2, PostId = 1 },
            new KatalogPost { KatalogPostId = 4, KatalogId = 2, PostId = 2 },

            // Preporuka urednika
            new KatalogPost { KatalogPostId = 5, KatalogId = 3, PostId = 5 }, // Presađivanje monstere
            new KatalogPost { KatalogPostId = 6, KatalogId = 3, PostId = 8 }, // Premium razmnožavanje
            new KatalogPost { KatalogPostId = 7, KatalogId = 3, PostId = 10 }, // Premium trulež korijena

            // Najljepša ruža
            new KatalogPost { KatalogPostId = 8, KatalogId = 4, PostId = 5 } // Post o vašima na ruži
);


    }
}
