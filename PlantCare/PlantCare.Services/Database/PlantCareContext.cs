using System;
using System.Collections.Generic;
using Microsoft.EntityFrameworkCore;
using PlantCare.Services.Database;



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
            new Uloga { UlogaId = 1, Naziv = "Administrator" },
            new Uloga { UlogaId = 2, Naziv = "Premium User" },
            new Uloga { UlogaId = 3, Naziv = "User" }
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
                LozinkaHash = "tPW/IOLa2TZIKYSA50IDeaJKYtg=",
                LozinkaSalt = "2G2wAwYkdFgpMleomcwelg==",
                Status = true,
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
                LozinkaSalt = "2G2wAwYkdFgpMleomcwelg==",
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
                LozinkaSalt = "2G2wAwYkdFgpMleomcwelg==",
                Status = true,
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
                Status = true,
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
                Status = true,
                UlogaId = 3
            }
        );

        // ── Categories ──────────────────────────────────────────────────────
        modelBuilder.Entity<Kategorija>().HasData(
            new Kategorija { KategorijaId = 1, Naziv = "Indoor Plants" },
            new Kategorija { KategorijaId = 2, Naziv = "Outdoor Plants" },
            new Kategorija { KategorijaId = 3, Naziv = "Gardening Tips" },
            new Kategorija { KategorijaId = 4, Naziv = "Plant Care Issues" }
        );

        // ── Subcategories ───────────────────────────────────────────────────
        modelBuilder.Entity<Subkategorija>().HasData(
            new Subkategorija { SubkategorijaId = 1, KategorijaId = 1, Naziv = "Succulents" },
            new Subkategorija { SubkategorijaId = 2, KategorijaId = 1, Naziv = "Low-light Plants" },
            new Subkategorija { SubkategorijaId = 3, KategorijaId = 1, Naziv = "Flowering Houseplants" },
            new Subkategorija { SubkategorijaId = 4, KategorijaId = 2, Naziv = "Perennials" },
            new Subkategorija { SubkategorijaId = 5, KategorijaId = 2, Naziv = "Seasonal Vegetables" },
            new Subkategorija { SubkategorijaId = 6, KategorijaId = 2, Naziv = "Flower Beds" },
            new Subkategorija { SubkategorijaId = 7, KategorijaId = 3, Naziv = "Watering & Fertilizing" },
            new Subkategorija { SubkategorijaId = 8, KategorijaId = 3, Naziv = "Soil & Repotting" },
            new Subkategorija { SubkategorijaId = 9, KategorijaId = 3, Naziv = "Propagation Techniques" },
            new Subkategorija { SubkategorijaId = 10, KategorijaId = 4, Naziv = "Pest Control" },
            new Subkategorija { SubkategorijaId = 11, KategorijaId = 4, Naziv = "Yellowing Leaves" },
            new Subkategorija { SubkategorijaId = 12, KategorijaId = 4, Naziv = "Root Rot & Overwatering" }
        );

        // ── Posts ────────────────────────────────────────────────────────────
        modelBuilder.Entity<Post>().HasData(
            new Post
            {
                PostId = 1,
                Naslov = "Help with my succulents",
                Sadrzaj = "My succulents have soft leaves and I think I'm overwatering them. Any advice on how to help them recover?",
                DatumKreiranja = new DateTime(2024, 3, 1, 10, 0, 0),
                KorisnikId = 3,
                SubkategorijaId = 1,
                Premium = false
            },
            new Post
            {
                PostId = 2,
                Naslov = "Best flowers for spring",
                Sadrzaj = "Looking for suggestions on the best flowers to plant this spring that are easy to maintain and bloom brightly.",
                DatumKreiranja = new DateTime(2024, 4, 10, 9, 30, 0),
                KorisnikId = 4,
                SubkategorijaId = 4,
                Premium = false
            },
            new Post
            {
                PostId = 3,
                Naslov = "Watering schedule for herbs",
                Sadrzaj = "I'm growing a variety of herbs on my balcony. How often should I water them to keep them healthy?",
                DatumKreiranja = new DateTime(2024, 2, 20, 8, 45, 0),
                KorisnikId = 5,
                SubkategorijaId = 7,
                Premium = false
            },
            new Post
            {
                PostId = 4,
                Naslov = "Tomato plant issues",
                Sadrzaj = "My tomato plant's leaves are wilting and have brown spots. What could be the issue and how can I treat it?",
                DatumKreiranja = new DateTime(2024, 5, 5, 14, 0, 0),
                KorisnikId = 4,
                SubkategorijaId = 5,
                Premium = false
            },
            new Post
            {
                PostId = 5,
                Naslov = "Dealing with aphids",
                Sadrzaj = "I've noticed a lot of small green insects (aphids) on my rose bushes. What's the best way to get rid of them without harming the plants?",
                DatumKreiranja = new DateTime(2024, 6, 15, 16, 30, 0),
                KorisnikId = 2,
                SubkategorijaId = 9,
                Premium = false
            },
            new Post
            {
                PostId = 6,
                Naslov = "New tropical plant varieties",
                Sadrzaj = "Check out these newly available tropical plant varieties – they have unique foliage and are great for indoor growing!",
                DatumKreiranja = new DateTime(2024, 7, 1, 11, 0, 0),
                KorisnikId = 1,
                SubkategorijaId = 2,
                Premium = true
            }
        );

        // ── Comments ─────────────────────────────────────────────────────────
        modelBuilder.Entity<Komentar>().HasData(
            new Komentar
            {
                KomentarId = 1,
                Sadrzaj = "I had the same issue with mine. Let the soil dry out completely before watering again and it helped.",
                DatumKreiranja = new DateTime(2024, 3, 2, 12, 0, 0),
                KorisnikId = 4,
                PostId = 1
            },
            new Komentar
            {
                KomentarId = 2,
                Sadrzaj = "Try watering less frequently. Succulents need much less water than other plants.",
                DatumKreiranja = new DateTime(2024, 3, 3, 9, 15, 0),
                KorisnikId = 5,
                PostId = 1
            },
            new Komentar
            {
                KomentarId = 3,
                Sadrzaj = "Great tips! I'll try this on my rose bushes.",
                DatumKreiranja = new DateTime(2024, 6, 16, 10, 0, 0),
                KorisnikId = 3,
                PostId = 5
            },
            new Komentar
            {
                KomentarId = 4,
                Sadrzaj = "Beautiful selection of flowers!",
                DatumKreiranja = new DateTime(2024, 4, 11, 15, 45, 0),
                KorisnikId = 5,
                PostId = 2
            },
            new Komentar
            {
                KomentarId = 5,
                Sadrzaj = "Have you checked the soil pH? Sometimes nutrient deficiencies can cause those spots.",
                DatumKreiranja = new DateTime(2024, 5, 6, 8, 30, 0),
                KorisnikId = 1,
                PostId = 4
            },
            new Komentar
            {
                KomentarId = 6,
                Sadrzaj = "These are amazing, thanks for sharing!",
                DatumKreiranja = new DateTime(2024, 7, 2, 14, 20, 0),
                KorisnikId = 4,
                PostId = 6
            }
        );

        // ── Likes ─────────────────────────────────────────────────────────────
        modelBuilder.Entity<Lajk>().HasData(
            new Lajk { LajkId = 1, KorisnikId = 4, PostId = 1, Datum = new DateTime(2024, 3, 1, 12, 30, 0) },
            new Lajk { LajkId = 2, KorisnikId = 5, PostId = 1, Datum = new DateTime(2024, 3, 1, 13, 0, 0) },
            new Lajk { LajkId = 3, KorisnikId = 3, PostId = 2, Datum = new DateTime(2024, 4, 10, 10, 0, 0) },
            new Lajk { LajkId = 4, KorisnikId = 1, PostId = 5, Datum = new DateTime(2024, 5, 6, 11, 0, 0) },
            new Lajk { LajkId = 5, KorisnikId = 3, PostId = 5, Datum = new DateTime(2024, 5, 6, 11, 30, 0) },
            new Lajk { LajkId = 6, KorisnikId = 5, PostId = 4, Datum = new DateTime(2024, 5, 5, 15, 0, 0) },
            new Lajk { LajkId = 7, KorisnikId = 2, PostId = 6, Datum = new DateTime(2024, 7, 1, 12, 0, 0) }
        );

        // ── Notifications ───────────────────────────────────────────────────
        modelBuilder.Entity<Notifikacija>().HasData(
            new Notifikacija
            {
                NotifikacijaId = 1,
                Naslov = "New Like",
                Sadrzaj = "Maja liked your post 'Help with my succulents'.",
                Datum = new DateTime(2024, 3, 1, 12, 30, 0),
                KorisnikId = 3,
                PostId = 1,
                Procitano = false
            },
            new Notifikacija
            {
                NotifikacijaId = 2,
                Naslov = "New Comment",
                Sadrzaj = "Sara commented on your post 'Best flowers for spring'.",
                Datum = new DateTime(2024, 4, 11, 16, 0, 0),
                KorisnikId = 4,
                PostId = 2,
                Procitano = false
            },
            new Notifikacija
            {
                NotifikacijaId = 3,
                Naslov = "New Comment",
                Sadrzaj = "Ivan commented on your post 'Dealing with aphids'.",
                Datum = new DateTime(2024, 6, 16, 11, 0, 0),
                KorisnikId = 2,
                PostId = 5,
                Procitano = false
            },
            new Notifikacija
            {
                NotifikacijaId = 4,
                Naslov = "New Comment",
                Sadrzaj = "Maja commented on your post 'New tropical plant varieties'.",
                Datum = new DateTime(2024, 7, 2, 15, 0, 0),
                KorisnikId = 1,
                PostId = 6,
                Procitano = false
            },
            new Notifikacija
            {
                NotifikacijaId = 5,
                Naslov = "New Comment",
                Sadrzaj = "Ana commented on your post 'Tomato plant issues'.",
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
                Naslov = "Welcome to PlantCare",
                Sadrzaj = "Hello and welcome to PlantCare! This platform is for plant lovers to share tips, ask questions, and help each other grow thriving plants.",
                Datum = new DateTime(2024, 1, 1, 0, 0, 0),
                KorisnikId = 1
            },
            new Obavijest
            {
                ObavijestId = 2,
                Naslov = "Community Gardening Event",
                Sadrzaj = "Join our spring gardening event on May 15th! Share your progress and tips with the community. Prizes await the best garden!",
                Datum = new DateTime(2024, 4, 1, 0, 0, 0),
                KorisnikId = 1
            },
            new Obavijest
            {
                ObavijestId = 3,
                Naslov = "Scheduled Maintenance",
                Sadrzaj = "PlantCare will undergo maintenance on June 1st at 12:00 AM UTC for about 2 hours. Thank you for your patience during this time.",
                Datum = new DateTime(2024, 5, 20, 0, 0, 0),
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
                BrojLajkova = 0,
                BrojOmiljenih = 0
            },
            new Report
            {
                ReportId = 2,
                PostId = 3,
                KorisnikId = 3,
                Datum = new DateTime(2024, 2, 21, 14, 0, 0),
                BrojLajkova = 0,
                BrojOmiljenih = 0
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
                TipPretplate = "Monthly"
            },
            new Uplata
            {
                UplataId = 2,
                KorisnikId = 5,
                Iznos = 9.99m,
                Datum = new DateTime(2024, 4, 10, 11, 30, 0),
                TipPretplate = "Basic"
            },
            new Uplata
            {
                UplataId = 3,
                KorisnikId = 4,
                Iznos = 14.50m,
                Datum = new DateTime(2024, 7, 22, 17, 45, 0),
                TipPretplate = "Premium"
            }
        );

        // ── Catalog ─────────────────────────────────────────────────────────
        modelBuilder.Entity<Katalog>().HasData(
            new Katalog
            {
                KatalogId = 1,
                Naslov = "Rose",
                Opis = "",
                DatumOd = new DateTime(2024, 1, 1),
                DatumDo = new DateTime(2024, 12, 31),
                KorisnikId = 1
            },
            new Katalog
            {
                KatalogId = 2,
                Naslov = "Tulip",
                Opis = "",
                DatumOd = new DateTime(2024, 1, 1),
                DatumDo = new DateTime(2024, 12, 31),
                KorisnikId = 1
            },
            new Katalog
            {
                KatalogId = 3,
                Naslov = "Aloe Vera",
                Opis = "",
                DatumOd = new DateTime(2024, 1, 1),
                DatumDo = new DateTime(2024, 12, 31),
                KorisnikId = 1
            },
            new Katalog
            {
                KatalogId = 4,
                Naslov = "Monstera Deliciosa",
                Opis = "",
                DatumOd = new DateTime(2024, 1, 1),
                DatumDo = new DateTime(2024, 12, 31),
                KorisnikId = 1
            },
            new Katalog
            {
                KatalogId = 5,
                Naslov = "Tomato",
                Opis = "",
                DatumOd = new DateTime(2024, 1, 1),
                DatumDo = new DateTime(2024, 12, 31),
                KorisnikId = 1
            },
            new Katalog
            {
                KatalogId = 6,
                Naslov = "Basil",
                Opis = "",
                DatumOd = new DateTime(2024, 1, 1),
                DatumDo = new DateTime(2024, 12, 31),
                KorisnikId = 1
            }
        );

        // ── Catalog-Post Links ───────────────────────────────────────────────
        modelBuilder.Entity<KatalogPost>().HasData(
            new KatalogPost { KatalogPostId = 1, KatalogId = 3, PostId = 1 },
            new KatalogPost { KatalogPostId = 2, KatalogId = 2, PostId = 2 },
            new KatalogPost { KatalogPostId = 3, KatalogId = 6, PostId = 3 },
            new KatalogPost { KatalogPostId = 4, KatalogId = 5, PostId = 4 },
            new KatalogPost { KatalogPostId = 5, KatalogId = 1, PostId = 5 },
            new KatalogPost { KatalogPostId = 6, KatalogId = 4, PostId = 6 }
        );
    }
}
