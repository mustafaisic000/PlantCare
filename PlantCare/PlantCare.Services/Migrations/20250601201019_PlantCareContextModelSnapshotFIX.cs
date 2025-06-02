using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

#pragma warning disable CA1814 // Prefer jagged arrays over multidimensional

namespace PlantCare.Services.Migrations
{
    /// <inheritdoc />
    public partial class PlantCareContextModelSnapshotFIX : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.CreateTable(
                name: "Kategorije",
                columns: table => new
                {
                    KategorijaId = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    Naziv = table.Column<string>(type: "nvarchar(100)", maxLength: 100, nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Kategorije", x => x.KategorijaId);
                });

            migrationBuilder.CreateTable(
                name: "Uloge",
                columns: table => new
                {
                    UlogaId = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    Naziv = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    Opis = table.Column<string>(type: "nvarchar(max)", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Uloge", x => x.UlogaId);
                });

            migrationBuilder.CreateTable(
                name: "Subkategorije",
                columns: table => new
                {
                    SubkategorijaId = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    Naziv = table.Column<string>(type: "nvarchar(100)", maxLength: 100, nullable: false),
                    KategorijaId = table.Column<int>(type: "int", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Subkategorije", x => x.SubkategorijaId);
                    table.ForeignKey(
                        name: "FK_Subkategorije_Kategorije_KategorijaId",
                        column: x => x.KategorijaId,
                        principalTable: "Kategorije",
                        principalColumn: "KategorijaId",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "Korisnici",
                columns: table => new
                {
                    KorisnikId = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    Ime = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    Prezime = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    DatumRodjenja = table.Column<DateTime>(type: "datetime2", nullable: true),
                    Email = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    Telefon = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    KorisnickoIme = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    LozinkaHash = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    LozinkaSalt = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    Status = table.Column<bool>(type: "bit", nullable: false),
                    UlogaId = table.Column<int>(type: "int", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Korisnici", x => x.KorisnikId);
                    table.ForeignKey(
                        name: "FK_Korisnici_Uloge_UlogaId",
                        column: x => x.UlogaId,
                        principalTable: "Uloge",
                        principalColumn: "UlogaId",
                        onDelete: ReferentialAction.Restrict);
                });

            migrationBuilder.CreateTable(
                name: "Katalog",
                columns: table => new
                {
                    KatalogId = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    Naslov = table.Column<string>(type: "nvarchar(100)", maxLength: 100, nullable: false),
                    Opis = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    DatumOd = table.Column<DateTime>(type: "datetime2", nullable: false),
                    DatumDo = table.Column<DateTime>(type: "datetime2", nullable: false),
                    KorisnikId = table.Column<int>(type: "int", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Katalog", x => x.KatalogId);
                    table.ForeignKey(
                        name: "FK_Katalog_Korisnici_KorisnikId",
                        column: x => x.KorisnikId,
                        principalTable: "Korisnici",
                        principalColumn: "KorisnikId",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "Obavijesti",
                columns: table => new
                {
                    ObavijestId = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    Naslov = table.Column<string>(type: "nvarchar(100)", maxLength: 100, nullable: false),
                    Sadrzaj = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    Datum = table.Column<DateTime>(type: "datetime2", nullable: false),
                    KorisnikId = table.Column<int>(type: "int", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Obavijesti", x => x.ObavijestId);
                    table.ForeignKey(
                        name: "FK_Obavijesti_Korisnici_KorisnikId",
                        column: x => x.KorisnikId,
                        principalTable: "Korisnici",
                        principalColumn: "KorisnikId",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "Postovi",
                columns: table => new
                {
                    PostId = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    Naslov = table.Column<string>(type: "nvarchar(200)", maxLength: 200, nullable: false),
                    Sadrzaj = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    Slika = table.Column<byte[]>(type: "varbinary(max)", nullable: true),
                    DatumKreiranja = table.Column<DateTime>(type: "datetime2", nullable: false),
                    KorisnikId = table.Column<int>(type: "int", nullable: false),
                    Premium = table.Column<bool>(type: "bit", nullable: false),
                    SubkategorijaId = table.Column<int>(type: "int", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Postovi", x => x.PostId);
                    table.ForeignKey(
                        name: "FK_Postovi_Korisnici_KorisnikId",
                        column: x => x.KorisnikId,
                        principalTable: "Korisnici",
                        principalColumn: "KorisnikId",
                        onDelete: ReferentialAction.Cascade);
                    table.ForeignKey(
                        name: "FK_Postovi_Subkategorije_SubkategorijaId",
                        column: x => x.SubkategorijaId,
                        principalTable: "Subkategorije",
                        principalColumn: "SubkategorijaId",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "Uplate",
                columns: table => new
                {
                    UplataId = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    Iznos = table.Column<decimal>(type: "decimal(18,2)", precision: 18, scale: 2, nullable: false),
                    Datum = table.Column<DateTime>(type: "datetime2", nullable: false),
                    TipPretplate = table.Column<string>(type: "nvarchar(50)", maxLength: 50, nullable: false),
                    KorisnikId = table.Column<int>(type: "int", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Uplate", x => x.UplataId);
                    table.ForeignKey(
                        name: "FK_Uplate_Korisnici_KorisnikId",
                        column: x => x.KorisnikId,
                        principalTable: "Korisnici",
                        principalColumn: "KorisnikId",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "KatalogPostovi",
                columns: table => new
                {
                    KatalogPostId = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    KatalogId = table.Column<int>(type: "int", nullable: false),
                    PostId = table.Column<int>(type: "int", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_KatalogPostovi", x => x.KatalogPostId);
                    table.ForeignKey(
                        name: "FK_KatalogPostovi_Katalog_KatalogId",
                        column: x => x.KatalogId,
                        principalTable: "Katalog",
                        principalColumn: "KatalogId",
                        onDelete: ReferentialAction.Restrict);
                    table.ForeignKey(
                        name: "FK_KatalogPostovi_Postovi_PostId",
                        column: x => x.PostId,
                        principalTable: "Postovi",
                        principalColumn: "PostId",
                        onDelete: ReferentialAction.Restrict);
                });

            migrationBuilder.CreateTable(
                name: "Komentari",
                columns: table => new
                {
                    KomentarId = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    Sadrzaj = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    DatumKreiranja = table.Column<DateTime>(type: "datetime2", nullable: false),
                    KorisnikId = table.Column<int>(type: "int", nullable: false),
                    PostId = table.Column<int>(type: "int", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Komentari", x => x.KomentarId);
                    table.ForeignKey(
                        name: "FK_Komentari_Korisnici_KorisnikId",
                        column: x => x.KorisnikId,
                        principalTable: "Korisnici",
                        principalColumn: "KorisnikId",
                        onDelete: ReferentialAction.Cascade);
                    table.ForeignKey(
                        name: "FK_Komentari_Postovi_PostId",
                        column: x => x.PostId,
                        principalTable: "Postovi",
                        principalColumn: "PostId",
                        onDelete: ReferentialAction.Restrict);
                });

            migrationBuilder.CreateTable(
                name: "Lajkovi",
                columns: table => new
                {
                    LajkId = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    KorisnikId = table.Column<int>(type: "int", nullable: false),
                    PostId = table.Column<int>(type: "int", nullable: false),
                    Datum = table.Column<DateTime>(type: "datetime2", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Lajkovi", x => x.LajkId);
                    table.ForeignKey(
                        name: "FK_Lajkovi_Korisnici_KorisnikId",
                        column: x => x.KorisnikId,
                        principalTable: "Korisnici",
                        principalColumn: "KorisnikId",
                        onDelete: ReferentialAction.Cascade);
                    table.ForeignKey(
                        name: "FK_Lajkovi_Postovi_PostId",
                        column: x => x.PostId,
                        principalTable: "Postovi",
                        principalColumn: "PostId",
                        onDelete: ReferentialAction.Restrict);
                });

            migrationBuilder.CreateTable(
                name: "Notifikacije",
                columns: table => new
                {
                    NotifikacijaId = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    Naslov = table.Column<string>(type: "nvarchar(200)", maxLength: 200, nullable: false),
                    Sadrzaj = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    Datum = table.Column<DateTime>(type: "datetime2", nullable: false),
                    KorisnikId = table.Column<int>(type: "int", nullable: false),
                    PostId = table.Column<int>(type: "int", nullable: true),
                    Procitano = table.Column<bool>(type: "bit", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Notifikacije", x => x.NotifikacijaId);
                    table.ForeignKey(
                        name: "FK_Notifikacije_Korisnici_KorisnikId",
                        column: x => x.KorisnikId,
                        principalTable: "Korisnici",
                        principalColumn: "KorisnikId",
                        onDelete: ReferentialAction.Cascade);
                    table.ForeignKey(
                        name: "FK_Notifikacije_Postovi_PostId",
                        column: x => x.PostId,
                        principalTable: "Postovi",
                        principalColumn: "PostId");
                });

            migrationBuilder.CreateTable(
                name: "OmiljeniPost",
                columns: table => new
                {
                    OmiljeniPostId = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    KorisnikId = table.Column<int>(type: "int", nullable: false),
                    PostId = table.Column<int>(type: "int", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_OmiljeniPost", x => x.OmiljeniPostId);
                    table.ForeignKey(
                        name: "FK_OmiljeniPost_Korisnici_KorisnikId",
                        column: x => x.KorisnikId,
                        principalTable: "Korisnici",
                        principalColumn: "KorisnikId",
                        onDelete: ReferentialAction.Cascade);
                    table.ForeignKey(
                        name: "FK_OmiljeniPost_Postovi_PostId",
                        column: x => x.PostId,
                        principalTable: "Postovi",
                        principalColumn: "PostId",
                        onDelete: ReferentialAction.Restrict);
                });

            migrationBuilder.CreateTable(
                name: "Reporti",
                columns: table => new
                {
                    ReportId = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    Datum = table.Column<DateTime>(type: "datetime2", nullable: false),
                    KorisnikId = table.Column<int>(type: "int", nullable: false),
                    PostId = table.Column<int>(type: "int", nullable: false),
                    BrojLajkova = table.Column<int>(type: "int", nullable: false),
                    BrojOmiljenih = table.Column<int>(type: "int", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Reporti", x => x.ReportId);
                    table.ForeignKey(
                        name: "FK_Reporti_Korisnici_KorisnikId",
                        column: x => x.KorisnikId,
                        principalTable: "Korisnici",
                        principalColumn: "KorisnikId",
                        onDelete: ReferentialAction.Cascade);
                    table.ForeignKey(
                        name: "FK_Reporti_Postovi_PostId",
                        column: x => x.PostId,
                        principalTable: "Postovi",
                        principalColumn: "PostId",
                        onDelete: ReferentialAction.Restrict);
                });

            migrationBuilder.InsertData(
                table: "Kategorije",
                columns: new[] { "KategorijaId", "Naziv" },
                values: new object[,]
                {
                    { 1, "Indoor Plants" },
                    { 2, "Outdoor Plants" },
                    { 3, "Gardening Tips" },
                    { 4, "Plant Care Issues" }
                });

            migrationBuilder.InsertData(
                table: "Uloge",
                columns: new[] { "UlogaId", "Naziv", "Opis" },
                values: new object[,]
                {
                    { 1, "Administrator", null },
                    { 2, "Premium User", null },
                    { 3, "User", null }
                });

            migrationBuilder.InsertData(
                table: "Korisnici",
                columns: new[] { "KorisnikId", "DatumRodjenja", "Email", "Ime", "KorisnickoIme", "LozinkaHash", "LozinkaSalt", "Prezime", "Status", "Telefon", "UlogaId" },
                values: new object[,]
                {
                    { 1, null, "ana.admin@plantcare.com", "Ana", "ana_admin", "tPW/IOLa2TZIKYSA50IDeaJKYtg=", "2G2wAwYkdFgpMleomcwelg==", "Admin", true, null, 1 },
                    { 2, null, "marko.mod@plantcare.com", "Marko", "marko_mod", "tPW/IOLa2TZIKYSA50IDeaJKYtg=", "2G2wAwYkdFgpMleomcwelg==", "Mod", true, null, 2 },
                    { 3, null, "ivan.ivic@plantcare.com", "Ivan", "ivan", "tPW/IOLa2TZIKYSA50IDeaJKYtg=", "2G2wAwYkdFgpMleomcwelg==", "Ivić", true, null, 3 },
                    { 4, null, "maja.majic@plantcare.com", "Maja", "majam", "tPW/IOLa2TZIKYSA50IDeaJKYtg=", "2G2wAwYkdFgpMleomcwelg==", "Majić", true, null, 3 },
                    { 5, null, "sara.saric@plantcare.com", "Sara", "saras", "tPW/IOLa2TZIKYSA50IDeaJKYtg=", "2G2wAwYkdFgpMleomcwelg==", "Sarić", true, null, 3 }
                });

            migrationBuilder.InsertData(
                table: "Subkategorije",
                columns: new[] { "SubkategorijaId", "KategorijaId", "Naziv" },
                values: new object[,]
                {
                    { 1, 1, "Succulents" },
                    { 2, 1, "Low-light Plants" },
                    { 3, 1, "Flowering Houseplants" },
                    { 4, 2, "Perennials" },
                    { 5, 2, "Seasonal Vegetables" },
                    { 6, 2, "Flower Beds" },
                    { 7, 3, "Watering & Fertilizing" },
                    { 8, 3, "Soil & Repotting" },
                    { 9, 3, "Propagation Techniques" },
                    { 10, 4, "Pest Control" },
                    { 11, 4, "Yellowing Leaves" },
                    { 12, 4, "Root Rot & Overwatering" }
                });

            migrationBuilder.InsertData(
                table: "Katalog",
                columns: new[] { "KatalogId", "DatumDo", "DatumOd", "KorisnikId", "Naslov", "Opis" },
                values: new object[,]
                {
                    { 1, new DateTime(2024, 12, 31, 0, 0, 0, 0, DateTimeKind.Unspecified), new DateTime(2024, 1, 1, 0, 0, 0, 0, DateTimeKind.Unspecified), 1, "Rose", "" },
                    { 2, new DateTime(2024, 12, 31, 0, 0, 0, 0, DateTimeKind.Unspecified), new DateTime(2024, 1, 1, 0, 0, 0, 0, DateTimeKind.Unspecified), 1, "Tulip", "" },
                    { 3, new DateTime(2024, 12, 31, 0, 0, 0, 0, DateTimeKind.Unspecified), new DateTime(2024, 1, 1, 0, 0, 0, 0, DateTimeKind.Unspecified), 1, "Aloe Vera", "" },
                    { 4, new DateTime(2024, 12, 31, 0, 0, 0, 0, DateTimeKind.Unspecified), new DateTime(2024, 1, 1, 0, 0, 0, 0, DateTimeKind.Unspecified), 1, "Monstera Deliciosa", "" },
                    { 5, new DateTime(2024, 12, 31, 0, 0, 0, 0, DateTimeKind.Unspecified), new DateTime(2024, 1, 1, 0, 0, 0, 0, DateTimeKind.Unspecified), 1, "Tomato", "" },
                    { 6, new DateTime(2024, 12, 31, 0, 0, 0, 0, DateTimeKind.Unspecified), new DateTime(2024, 1, 1, 0, 0, 0, 0, DateTimeKind.Unspecified), 1, "Basil", "" }
                });

            migrationBuilder.InsertData(
                table: "Obavijesti",
                columns: new[] { "ObavijestId", "Datum", "KorisnikId", "Naslov", "Sadrzaj" },
                values: new object[,]
                {
                    { 1, new DateTime(2024, 1, 1, 0, 0, 0, 0, DateTimeKind.Unspecified), 1, "Welcome to PlantCare", "Hello and welcome to PlantCare! This platform is for plant lovers to share tips, ask questions, and help each other grow thriving plants." },
                    { 2, new DateTime(2024, 4, 1, 0, 0, 0, 0, DateTimeKind.Unspecified), 1, "Community Gardening Event", "Join our spring gardening event on May 15th! Share your progress and tips with the community. Prizes await the best garden!" },
                    { 3, new DateTime(2024, 5, 20, 0, 0, 0, 0, DateTimeKind.Unspecified), 1, "Scheduled Maintenance", "PlantCare will undergo maintenance on June 1st at 12:00 AM UTC for about 2 hours. Thank you for your patience during this time." }
                });

            migrationBuilder.InsertData(
                table: "Postovi",
                columns: new[] { "PostId", "DatumKreiranja", "KorisnikId", "Naslov", "Premium", "Sadrzaj", "Slika", "SubkategorijaId" },
                values: new object[,]
                {
                    { 1, new DateTime(2024, 3, 1, 10, 0, 0, 0, DateTimeKind.Unspecified), 3, "Help with my succulents", false, "My succulents have soft leaves and I think I'm overwatering them. Any advice on how to help them recover?", null, 1 },
                    { 2, new DateTime(2024, 4, 10, 9, 30, 0, 0, DateTimeKind.Unspecified), 4, "Best flowers for spring", false, "Looking for suggestions on the best flowers to plant this spring that are easy to maintain and bloom brightly.", null, 4 },
                    { 3, new DateTime(2024, 2, 20, 8, 45, 0, 0, DateTimeKind.Unspecified), 5, "Watering schedule for herbs", false, "I'm growing a variety of herbs on my balcony. How often should I water them to keep them healthy?", null, 7 },
                    { 4, new DateTime(2024, 5, 5, 14, 0, 0, 0, DateTimeKind.Unspecified), 4, "Tomato plant issues", false, "My tomato plant's leaves are wilting and have brown spots. What could be the issue and how can I treat it?", null, 5 },
                    { 5, new DateTime(2024, 6, 15, 16, 30, 0, 0, DateTimeKind.Unspecified), 2, "Dealing with aphids", false, "I've noticed a lot of small green insects (aphids) on my rose bushes. What's the best way to get rid of them without harming the plants?", null, 9 },
                    { 6, new DateTime(2024, 7, 1, 11, 0, 0, 0, DateTimeKind.Unspecified), 1, "New tropical plant varieties", true, "Check out these newly available tropical plant varieties – they have unique foliage and are great for indoor growing!", null, 2 }
                });

            migrationBuilder.InsertData(
                table: "Uplate",
                columns: new[] { "UplataId", "Datum", "Iznos", "KorisnikId", "TipPretplate" },
                values: new object[,]
                {
                    { 1, new DateTime(2024, 2, 15, 13, 0, 0, 0, DateTimeKind.Unspecified), 19.99m, 3, "Monthly" },
                    { 2, new DateTime(2024, 4, 10, 11, 30, 0, 0, DateTimeKind.Unspecified), 9.99m, 5, "Basic" },
                    { 3, new DateTime(2024, 7, 22, 17, 45, 0, 0, DateTimeKind.Unspecified), 14.50m, 4, "Premium" }
                });

            migrationBuilder.InsertData(
                table: "KatalogPostovi",
                columns: new[] { "KatalogPostId", "KatalogId", "PostId" },
                values: new object[,]
                {
                    { 1, 3, 1 },
                    { 2, 2, 2 },
                    { 3, 6, 3 },
                    { 4, 5, 4 },
                    { 5, 1, 5 },
                    { 6, 4, 6 }
                });

            migrationBuilder.InsertData(
                table: "Komentari",
                columns: new[] { "KomentarId", "DatumKreiranja", "KorisnikId", "PostId", "Sadrzaj" },
                values: new object[,]
                {
                    { 1, new DateTime(2024, 3, 2, 12, 0, 0, 0, DateTimeKind.Unspecified), 4, 1, "I had the same issue with mine. Let the soil dry out completely before watering again and it helped." },
                    { 2, new DateTime(2024, 3, 3, 9, 15, 0, 0, DateTimeKind.Unspecified), 5, 1, "Try watering less frequently. Succulents need much less water than other plants." },
                    { 3, new DateTime(2024, 6, 16, 10, 0, 0, 0, DateTimeKind.Unspecified), 3, 5, "Great tips! I'll try this on my rose bushes." },
                    { 4, new DateTime(2024, 4, 11, 15, 45, 0, 0, DateTimeKind.Unspecified), 5, 2, "Beautiful selection of flowers!" },
                    { 5, new DateTime(2024, 5, 6, 8, 30, 0, 0, DateTimeKind.Unspecified), 1, 4, "Have you checked the soil pH? Sometimes nutrient deficiencies can cause those spots." },
                    { 6, new DateTime(2024, 7, 2, 14, 20, 0, 0, DateTimeKind.Unspecified), 4, 6, "These are amazing, thanks for sharing!" }
                });

            migrationBuilder.InsertData(
                table: "Lajkovi",
                columns: new[] { "LajkId", "Datum", "KorisnikId", "PostId" },
                values: new object[,]
                {
                    { 1, new DateTime(2024, 3, 1, 12, 30, 0, 0, DateTimeKind.Unspecified), 4, 1 },
                    { 2, new DateTime(2024, 3, 1, 13, 0, 0, 0, DateTimeKind.Unspecified), 5, 1 },
                    { 3, new DateTime(2024, 4, 10, 10, 0, 0, 0, DateTimeKind.Unspecified), 3, 2 },
                    { 4, new DateTime(2024, 5, 6, 11, 0, 0, 0, DateTimeKind.Unspecified), 1, 5 },
                    { 5, new DateTime(2024, 5, 6, 11, 30, 0, 0, DateTimeKind.Unspecified), 3, 5 },
                    { 6, new DateTime(2024, 5, 5, 15, 0, 0, 0, DateTimeKind.Unspecified), 5, 4 },
                    { 7, new DateTime(2024, 7, 1, 12, 0, 0, 0, DateTimeKind.Unspecified), 2, 6 }
                });

            migrationBuilder.InsertData(
                table: "Notifikacije",
                columns: new[] { "NotifikacijaId", "Datum", "KorisnikId", "Naslov", "PostId", "Procitano", "Sadrzaj" },
                values: new object[,]
                {
                    { 1, new DateTime(2024, 3, 1, 12, 30, 0, 0, DateTimeKind.Unspecified), 3, "New Like", 1, false, "Maja liked your post 'Help with my succulents'." },
                    { 2, new DateTime(2024, 4, 11, 16, 0, 0, 0, DateTimeKind.Unspecified), 4, "New Comment", 2, false, "Sara commented on your post 'Best flowers for spring'." },
                    { 3, new DateTime(2024, 6, 16, 11, 0, 0, 0, DateTimeKind.Unspecified), 2, "New Comment", 5, false, "Ivan commented on your post 'Dealing with aphids'." },
                    { 4, new DateTime(2024, 7, 2, 15, 0, 0, 0, DateTimeKind.Unspecified), 1, "New Comment", 6, false, "Maja commented on your post 'New tropical plant varieties'." },
                    { 5, new DateTime(2024, 5, 6, 9, 0, 0, 0, DateTimeKind.Unspecified), 4, "New Comment", 4, false, "Ana commented on your post 'Tomato plant issues'." }
                });

            migrationBuilder.InsertData(
                table: "OmiljeniPost",
                columns: new[] { "OmiljeniPostId", "KorisnikId", "PostId" },
                values: new object[,]
                {
                    { 1, 3, 2 },
                    { 2, 4, 5 },
                    { 3, 5, 1 }
                });

            migrationBuilder.InsertData(
                table: "Reporti",
                columns: new[] { "ReportId", "BrojLajkova", "BrojOmiljenih", "Datum", "KorisnikId", "PostId" },
                values: new object[,]
                {
                    { 1, 0, 0, new DateTime(2024, 5, 6, 10, 0, 0, 0, DateTimeKind.Unspecified), 5, 4 },
                    { 2, 0, 0, new DateTime(2024, 2, 21, 14, 0, 0, 0, DateTimeKind.Unspecified), 3, 3 }
                });

            migrationBuilder.CreateIndex(
                name: "IX_Katalog_KorisnikId",
                table: "Katalog",
                column: "KorisnikId");

            migrationBuilder.CreateIndex(
                name: "IX_KatalogPostovi_KatalogId",
                table: "KatalogPostovi",
                column: "KatalogId");

            migrationBuilder.CreateIndex(
                name: "IX_KatalogPostovi_PostId",
                table: "KatalogPostovi",
                column: "PostId");

            migrationBuilder.CreateIndex(
                name: "IX_Komentari_KorisnikId",
                table: "Komentari",
                column: "KorisnikId");

            migrationBuilder.CreateIndex(
                name: "IX_Komentari_PostId",
                table: "Komentari",
                column: "PostId");

            migrationBuilder.CreateIndex(
                name: "IX_Korisnici_UlogaId",
                table: "Korisnici",
                column: "UlogaId");

            migrationBuilder.CreateIndex(
                name: "IX_Lajkovi_KorisnikId",
                table: "Lajkovi",
                column: "KorisnikId");

            migrationBuilder.CreateIndex(
                name: "IX_Lajkovi_PostId",
                table: "Lajkovi",
                column: "PostId");

            migrationBuilder.CreateIndex(
                name: "IX_Notifikacije_KorisnikId",
                table: "Notifikacije",
                column: "KorisnikId");

            migrationBuilder.CreateIndex(
                name: "IX_Notifikacije_PostId",
                table: "Notifikacije",
                column: "PostId");

            migrationBuilder.CreateIndex(
                name: "IX_Obavijesti_KorisnikId",
                table: "Obavijesti",
                column: "KorisnikId");

            migrationBuilder.CreateIndex(
                name: "IX_OmiljeniPost_KorisnikId",
                table: "OmiljeniPost",
                column: "KorisnikId");

            migrationBuilder.CreateIndex(
                name: "IX_OmiljeniPost_PostId",
                table: "OmiljeniPost",
                column: "PostId");

            migrationBuilder.CreateIndex(
                name: "IX_Postovi_KorisnikId",
                table: "Postovi",
                column: "KorisnikId");

            migrationBuilder.CreateIndex(
                name: "IX_Postovi_SubkategorijaId",
                table: "Postovi",
                column: "SubkategorijaId");

            migrationBuilder.CreateIndex(
                name: "IX_Reporti_KorisnikId",
                table: "Reporti",
                column: "KorisnikId");

            migrationBuilder.CreateIndex(
                name: "IX_Reporti_PostId",
                table: "Reporti",
                column: "PostId");

            migrationBuilder.CreateIndex(
                name: "IX_Subkategorije_KategorijaId",
                table: "Subkategorije",
                column: "KategorijaId");

            migrationBuilder.CreateIndex(
                name: "IX_Uplate_KorisnikId",
                table: "Uplate",
                column: "KorisnikId");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropTable(
                name: "KatalogPostovi");

            migrationBuilder.DropTable(
                name: "Komentari");

            migrationBuilder.DropTable(
                name: "Lajkovi");

            migrationBuilder.DropTable(
                name: "Notifikacije");

            migrationBuilder.DropTable(
                name: "Obavijesti");

            migrationBuilder.DropTable(
                name: "OmiljeniPost");

            migrationBuilder.DropTable(
                name: "Reporti");

            migrationBuilder.DropTable(
                name: "Uplate");

            migrationBuilder.DropTable(
                name: "Katalog");

            migrationBuilder.DropTable(
                name: "Postovi");

            migrationBuilder.DropTable(
                name: "Korisnici");

            migrationBuilder.DropTable(
                name: "Subkategorije");

            migrationBuilder.DropTable(
                name: "Uloge");

            migrationBuilder.DropTable(
                name: "Kategorije");
        }
    }
}
