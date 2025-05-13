using System;
using System.Collections.Generic;
using Microsoft.EntityFrameworkCore;
using PlantCare.Service.Database;



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

        base.OnModelCreating(modelBuilder);
    }


}
