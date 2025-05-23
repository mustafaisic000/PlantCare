﻿// <auto-generated />
using System;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Infrastructure;
using Microsoft.EntityFrameworkCore.Metadata;
using Microsoft.EntityFrameworkCore.Migrations;
using Microsoft.EntityFrameworkCore.Storage.ValueConversion;
using PlantCare.Services.Database;

#nullable disable

namespace PlantCare.Services.Migrations
{
    [DbContext(typeof(PlantCareContext))]
    [Migration("20250419201938_InitialSetup")]
    partial class InitialSetup
    {
        /// <inheritdoc />
        protected override void BuildTargetModel(ModelBuilder modelBuilder)
        {
#pragma warning disable 612, 618
            modelBuilder
                .HasAnnotation("ProductVersion", "9.0.4")
                .HasAnnotation("Relational:MaxIdentifierLength", 128);

            SqlServerModelBuilderExtensions.UseIdentityColumns(modelBuilder);

            modelBuilder.Entity("PlantCare.Service.Database.Komentar", b =>
                {
                    b.Property<int>("KomentarId")
                        .ValueGeneratedOnAdd()
                        .HasColumnType("int");

                    SqlServerPropertyBuilderExtensions.UseIdentityColumn(b.Property<int>("KomentarId"));

                    b.Property<DateTime>("DatumKreiranja")
                        .HasColumnType("datetime2");

                    b.Property<int>("KorisnikId")
                        .HasColumnType("int");

                    b.Property<int>("PostId")
                        .HasColumnType("int");

                    b.Property<string>("Sadrzaj")
                        .IsRequired()
                        .HasColumnType("nvarchar(max)");

                    b.HasKey("KomentarId");

                    b.HasIndex("KorisnikId");

                    b.HasIndex("PostId");

                    b.ToTable("Komentari");
                });

            modelBuilder.Entity("PlantCare.Service.Database.Korisnik", b =>
                {
                    b.Property<int>("KorisnikId")
                        .ValueGeneratedOnAdd()
                        .HasColumnType("int");

                    SqlServerPropertyBuilderExtensions.UseIdentityColumn(b.Property<int>("KorisnikId"));

                    b.Property<DateTime?>("DatumRodjenja")
                        .HasColumnType("datetime2");

                    b.Property<string>("Email")
                        .HasColumnType("nvarchar(max)");

                    b.Property<string>("Ime")
                        .IsRequired()
                        .HasColumnType("nvarchar(max)");

                    b.Property<string>("KorisnickoIme")
                        .IsRequired()
                        .HasColumnType("nvarchar(max)");

                    b.Property<string>("LozinkaHash")
                        .IsRequired()
                        .HasColumnType("nvarchar(max)");

                    b.Property<string>("LozinkaSalt")
                        .IsRequired()
                        .HasColumnType("nvarchar(max)");

                    b.Property<string>("Prezime")
                        .IsRequired()
                        .HasColumnType("nvarchar(max)");

                    b.Property<bool>("Status")
                        .HasColumnType("bit");

                    b.Property<string>("Telefon")
                        .HasColumnType("nvarchar(max)");

                    b.Property<int>("UlogaId")
                        .HasColumnType("int");

                    b.HasKey("KorisnikId");

                    b.HasIndex("UlogaId");

                    b.ToTable("Korisnici");
                });

            modelBuilder.Entity("PlantCare.Service.Database.Lajk", b =>
                {
                    b.Property<int>("LajkId")
                        .ValueGeneratedOnAdd()
                        .HasColumnType("int");

                    SqlServerPropertyBuilderExtensions.UseIdentityColumn(b.Property<int>("LajkId"));

                    b.Property<DateTime>("Datum")
                        .HasColumnType("datetime2");

                    b.Property<int>("KorisnikId")
                        .HasColumnType("int");

                    b.Property<int>("PostId")
                        .HasColumnType("int");

                    b.HasKey("LajkId");

                    b.HasIndex("KorisnikId");

                    b.HasIndex("PostId");

                    b.ToTable("Lajkovi");
                });

            modelBuilder.Entity("PlantCare.Service.Database.Notifikacija", b =>
                {
                    b.Property<int>("NotifikacijaId")
                        .ValueGeneratedOnAdd()
                        .HasColumnType("int");

                    SqlServerPropertyBuilderExtensions.UseIdentityColumn(b.Property<int>("NotifikacijaId"));

                    b.Property<DateTime>("Datum")
                        .HasColumnType("datetime2");

                    b.Property<int>("KorisnikId")
                        .HasColumnType("int");

                    b.Property<string>("Naslov")
                        .IsRequired()
                        .HasMaxLength(200)
                        .HasColumnType("nvarchar(200)");

                    b.Property<int?>("PostId")
                        .HasColumnType("int");

                    b.Property<bool>("Procitano")
                        .HasColumnType("bit");

                    b.Property<string>("Sadrzaj")
                        .IsRequired()
                        .HasColumnType("nvarchar(max)");

                    b.HasKey("NotifikacijaId");

                    b.HasIndex("KorisnikId");

                    b.HasIndex("PostId");

                    b.ToTable("Notifikacije");
                });

            modelBuilder.Entity("PlantCare.Service.Database.Obavijest", b =>
                {
                    b.Property<int>("ObavijestId")
                        .ValueGeneratedOnAdd()
                        .HasColumnType("int");

                    SqlServerPropertyBuilderExtensions.UseIdentityColumn(b.Property<int>("ObavijestId"));

                    b.Property<DateTime>("Datum")
                        .HasColumnType("datetime2");

                    b.Property<int>("KorisnikId")
                        .HasColumnType("int");

                    b.Property<string>("Naslov")
                        .IsRequired()
                        .HasMaxLength(100)
                        .HasColumnType("nvarchar(100)");

                    b.Property<string>("Sadrzaj")
                        .IsRequired()
                        .HasColumnType("nvarchar(max)");

                    b.HasKey("ObavijestId");

                    b.HasIndex("KorisnikId");

                    b.ToTable("Obavijesti");
                });

            modelBuilder.Entity("PlantCare.Service.Database.Post", b =>
                {
                    b.Property<int>("PostId")
                        .ValueGeneratedOnAdd()
                        .HasColumnType("int");

                    SqlServerPropertyBuilderExtensions.UseIdentityColumn(b.Property<int>("PostId"));

                    b.Property<DateTime>("DatumKreiranja")
                        .HasColumnType("datetime2");

                    b.Property<int>("KorisnikId")
                        .HasColumnType("int");

                    b.Property<string>("Naslov")
                        .IsRequired()
                        .HasMaxLength(200)
                        .HasColumnType("nvarchar(200)");

                    b.Property<bool>("Premium")
                        .HasColumnType("bit");

                    b.Property<string>("Sadrzaj")
                        .IsRequired()
                        .HasColumnType("nvarchar(max)");

                    b.Property<byte[]>("Slika")
                        .HasColumnType("varbinary(max)");

                    b.Property<int>("SubkategorijaId")
                        .HasColumnType("int");

                    b.HasKey("PostId");

                    b.HasIndex("KorisnikId");

                    b.HasIndex("SubkategorijaId");

                    b.ToTable("Postovi");
                });

            modelBuilder.Entity("PlantCare.Service.Database.Report", b =>
                {
                    b.Property<int>("ReportId")
                        .ValueGeneratedOnAdd()
                        .HasColumnType("int");

                    SqlServerPropertyBuilderExtensions.UseIdentityColumn(b.Property<int>("ReportId"));

                    b.Property<int>("BrojLajkova")
                        .HasColumnType("int");

                    b.Property<int>("BrojOmiljenih")
                        .HasColumnType("int");

                    b.Property<DateTime>("Datum")
                        .HasColumnType("datetime2");

                    b.Property<int>("KorisnikId")
                        .HasColumnType("int");

                    b.Property<int>("PostId")
                        .HasColumnType("int");

                    b.HasKey("ReportId");

                    b.HasIndex("KorisnikId");

                    b.HasIndex("PostId");

                    b.ToTable("Reporti");
                });

            modelBuilder.Entity("PlantCare.Service.Database.Uloga", b =>
                {
                    b.Property<int>("UlogaId")
                        .ValueGeneratedOnAdd()
                        .HasColumnType("int");

                    SqlServerPropertyBuilderExtensions.UseIdentityColumn(b.Property<int>("UlogaId"));

                    b.Property<string>("Naziv")
                        .IsRequired()
                        .HasColumnType("nvarchar(max)");

                    b.Property<string>("Opis")
                        .HasColumnType("nvarchar(max)");

                    b.HasKey("UlogaId");

                    b.ToTable("Uloge");
                });

            modelBuilder.Entity("PlantCare.Service.Database.Uplata", b =>
                {
                    b.Property<int>("UplataId")
                        .ValueGeneratedOnAdd()
                        .HasColumnType("int");

                    SqlServerPropertyBuilderExtensions.UseIdentityColumn(b.Property<int>("UplataId"));

                    b.Property<DateTime>("Datum")
                        .HasColumnType("datetime2");

                    b.Property<decimal>("Iznos")
                        .HasPrecision(18, 2)
                        .HasColumnType("decimal(18,2)");

                    b.Property<int>("KorisnikId")
                        .HasColumnType("int");

                    b.Property<string>("TipPretplate")
                        .IsRequired()
                        .HasMaxLength(50)
                        .HasColumnType("nvarchar(50)");

                    b.HasKey("UplataId");

                    b.HasIndex("KorisnikId");

                    b.ToTable("Uplate");
                });

            modelBuilder.Entity("PlantCare.Services.Database.Katalog", b =>
                {
                    b.Property<int>("KatalogId")
                        .ValueGeneratedOnAdd()
                        .HasColumnType("int");

                    SqlServerPropertyBuilderExtensions.UseIdentityColumn(b.Property<int>("KatalogId"));

                    b.Property<DateTime>("DatumDo")
                        .HasColumnType("datetime2");

                    b.Property<DateTime>("DatumOd")
                        .HasColumnType("datetime2");

                    b.Property<int>("KorisnikId")
                        .HasColumnType("int");

                    b.Property<string>("Naslov")
                        .IsRequired()
                        .HasMaxLength(100)
                        .HasColumnType("nvarchar(100)");

                    b.Property<string>("Opis")
                        .IsRequired()
                        .HasColumnType("nvarchar(max)");

                    b.HasKey("KatalogId");

                    b.HasIndex("KorisnikId");

                    b.ToTable("Katalog");
                });

            modelBuilder.Entity("PlantCare.Services.Database.KatalogPost", b =>
                {
                    b.Property<int>("KatalogPostId")
                        .ValueGeneratedOnAdd()
                        .HasColumnType("int");

                    SqlServerPropertyBuilderExtensions.UseIdentityColumn(b.Property<int>("KatalogPostId"));

                    b.Property<int>("KatalogId")
                        .HasColumnType("int");

                    b.Property<int>("PostId")
                        .HasColumnType("int");

                    b.HasKey("KatalogPostId");

                    b.HasIndex("KatalogId");

                    b.HasIndex("PostId");

                    b.ToTable("KatalogPost");
                });

            modelBuilder.Entity("PlantCare.Services.Database.Kategorija", b =>
                {
                    b.Property<int>("KategorijaId")
                        .ValueGeneratedOnAdd()
                        .HasColumnType("int");

                    SqlServerPropertyBuilderExtensions.UseIdentityColumn(b.Property<int>("KategorijaId"));

                    b.Property<string>("Naziv")
                        .IsRequired()
                        .HasMaxLength(100)
                        .HasColumnType("nvarchar(100)");

                    b.HasKey("KategorijaId");

                    b.ToTable("Kategorije");
                });

            modelBuilder.Entity("PlantCare.Services.Database.Subkategorija", b =>
                {
                    b.Property<int>("SubkategorijaId")
                        .ValueGeneratedOnAdd()
                        .HasColumnType("int");

                    SqlServerPropertyBuilderExtensions.UseIdentityColumn(b.Property<int>("SubkategorijaId"));

                    b.Property<int>("KategorijaId")
                        .HasColumnType("int");

                    b.Property<string>("Naziv")
                        .IsRequired()
                        .HasMaxLength(100)
                        .HasColumnType("nvarchar(100)");

                    b.HasKey("SubkategorijaId");

                    b.HasIndex("KategorijaId");

                    b.ToTable("Subkategorije");
                });

            modelBuilder.Entity("PlantCare.Service.Database.Komentar", b =>
                {
                    b.HasOne("PlantCare.Service.Database.Korisnik", "Korisnik")
                        .WithMany("Komentari")
                        .HasForeignKey("KorisnikId")
                        .OnDelete(DeleteBehavior.Cascade)
                        .IsRequired();

                    b.HasOne("PlantCare.Service.Database.Post", "Post")
                        .WithMany("Komentari")
                        .HasForeignKey("PostId")
                        .OnDelete(DeleteBehavior.Restrict)
                        .IsRequired();

                    b.Navigation("Korisnik");

                    b.Navigation("Post");
                });

            modelBuilder.Entity("PlantCare.Service.Database.Korisnik", b =>
                {
                    b.HasOne("PlantCare.Service.Database.Uloga", "Uloga")
                        .WithMany("Korisnici")
                        .HasForeignKey("UlogaId")
                        .OnDelete(DeleteBehavior.Restrict)
                        .IsRequired();

                    b.Navigation("Uloga");
                });

            modelBuilder.Entity("PlantCare.Service.Database.Lajk", b =>
                {
                    b.HasOne("PlantCare.Service.Database.Korisnik", "Korisnik")
                        .WithMany("Lajkovi")
                        .HasForeignKey("KorisnikId")
                        .OnDelete(DeleteBehavior.Cascade)
                        .IsRequired();

                    b.HasOne("PlantCare.Service.Database.Post", "Post")
                        .WithMany("Lajkovi")
                        .HasForeignKey("PostId")
                        .OnDelete(DeleteBehavior.Restrict)
                        .IsRequired();

                    b.Navigation("Korisnik");

                    b.Navigation("Post");
                });

            modelBuilder.Entity("PlantCare.Service.Database.Notifikacija", b =>
                {
                    b.HasOne("PlantCare.Service.Database.Korisnik", "Korisnik")
                        .WithMany("Notifikacije")
                        .HasForeignKey("KorisnikId")
                        .OnDelete(DeleteBehavior.Cascade)
                        .IsRequired();

                    b.HasOne("PlantCare.Service.Database.Post", "Post")
                        .WithMany()
                        .HasForeignKey("PostId");

                    b.Navigation("Korisnik");

                    b.Navigation("Post");
                });

            modelBuilder.Entity("PlantCare.Service.Database.Obavijest", b =>
                {
                    b.HasOne("PlantCare.Service.Database.Korisnik", "Korisnik")
                        .WithMany("Obavijesti")
                        .HasForeignKey("KorisnikId")
                        .OnDelete(DeleteBehavior.Cascade)
                        .IsRequired();

                    b.Navigation("Korisnik");
                });

            modelBuilder.Entity("PlantCare.Service.Database.Post", b =>
                {
                    b.HasOne("PlantCare.Service.Database.Korisnik", "Korisnik")
                        .WithMany("Postovi")
                        .HasForeignKey("KorisnikId")
                        .OnDelete(DeleteBehavior.Cascade)
                        .IsRequired();

                    b.HasOne("PlantCare.Services.Database.Subkategorija", "Subkategorija")
                        .WithMany()
                        .HasForeignKey("SubkategorijaId")
                        .OnDelete(DeleteBehavior.Cascade)
                        .IsRequired();

                    b.Navigation("Korisnik");

                    b.Navigation("Subkategorija");
                });

            modelBuilder.Entity("PlantCare.Service.Database.Report", b =>
                {
                    b.HasOne("PlantCare.Service.Database.Korisnik", "Korisnik")
                        .WithMany("Reports")
                        .HasForeignKey("KorisnikId")
                        .OnDelete(DeleteBehavior.Cascade)
                        .IsRequired();

                    b.HasOne("PlantCare.Service.Database.Post", "Post")
                        .WithMany("Reports")
                        .HasForeignKey("PostId")
                        .OnDelete(DeleteBehavior.Restrict)
                        .IsRequired();

                    b.Navigation("Korisnik");

                    b.Navigation("Post");
                });

            modelBuilder.Entity("PlantCare.Service.Database.Uplata", b =>
                {
                    b.HasOne("PlantCare.Service.Database.Korisnik", "Korisnik")
                        .WithMany("Uplate")
                        .HasForeignKey("KorisnikId")
                        .OnDelete(DeleteBehavior.Cascade)
                        .IsRequired();

                    b.Navigation("Korisnik");
                });

            modelBuilder.Entity("PlantCare.Services.Database.Katalog", b =>
                {
                    b.HasOne("PlantCare.Service.Database.Korisnik", "Korisnik")
                        .WithMany()
                        .HasForeignKey("KorisnikId")
                        .OnDelete(DeleteBehavior.Cascade)
                        .IsRequired();

                    b.Navigation("Korisnik");
                });

            modelBuilder.Entity("PlantCare.Services.Database.KatalogPost", b =>
                {
                    b.HasOne("PlantCare.Services.Database.Katalog", "Katalog")
                        .WithMany("KatalogPostovi")
                        .HasForeignKey("KatalogId")
                        .OnDelete(DeleteBehavior.Restrict)
                        .IsRequired();

                    b.HasOne("PlantCare.Service.Database.Post", "Post")
                        .WithMany("KatalogPostovi")
                        .HasForeignKey("PostId")
                        .OnDelete(DeleteBehavior.Restrict)
                        .IsRequired();

                    b.Navigation("Katalog");

                    b.Navigation("Post");
                });

            modelBuilder.Entity("PlantCare.Services.Database.Subkategorija", b =>
                {
                    b.HasOne("PlantCare.Services.Database.Kategorija", "Kategorija")
                        .WithMany("Subkategorije")
                        .HasForeignKey("KategorijaId")
                        .OnDelete(DeleteBehavior.Cascade)
                        .IsRequired();

                    b.Navigation("Kategorija");
                });

            modelBuilder.Entity("PlantCare.Service.Database.Korisnik", b =>
                {
                    b.Navigation("Komentari");

                    b.Navigation("Lajkovi");

                    b.Navigation("Notifikacije");

                    b.Navigation("Obavijesti");

                    b.Navigation("Postovi");

                    b.Navigation("Reports");

                    b.Navigation("Uplate");
                });

            modelBuilder.Entity("PlantCare.Service.Database.Post", b =>
                {
                    b.Navigation("KatalogPostovi");

                    b.Navigation("Komentari");

                    b.Navigation("Lajkovi");

                    b.Navigation("Reports");
                });

            modelBuilder.Entity("PlantCare.Service.Database.Uloga", b =>
                {
                    b.Navigation("Korisnici");
                });

            modelBuilder.Entity("PlantCare.Services.Database.Katalog", b =>
                {
                    b.Navigation("KatalogPostovi");
                });

            modelBuilder.Entity("PlantCare.Services.Database.Kategorija", b =>
                {
                    b.Navigation("Subkategorije");
                });
#pragma warning restore 612, 618
        }
    }
}
