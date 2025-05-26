using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

#pragma warning disable CA1814 // Prefer jagged arrays over multidimensional

namespace PlantCare.Services.Migrations
{
    /// <inheritdoc />
    public partial class addedseeders : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
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
                table: "KatalogPost",
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
                name: "IX_OmiljeniPost_KorisnikId",
                table: "OmiljeniPost",
                column: "KorisnikId");

            migrationBuilder.CreateIndex(
                name: "IX_OmiljeniPost_PostId",
                table: "OmiljeniPost",
                column: "PostId");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropTable(
                name: "OmiljeniPost");

            migrationBuilder.DeleteData(
                table: "KatalogPost",
                keyColumn: "KatalogPostId",
                keyValue: 1);

            migrationBuilder.DeleteData(
                table: "KatalogPost",
                keyColumn: "KatalogPostId",
                keyValue: 2);

            migrationBuilder.DeleteData(
                table: "KatalogPost",
                keyColumn: "KatalogPostId",
                keyValue: 3);

            migrationBuilder.DeleteData(
                table: "KatalogPost",
                keyColumn: "KatalogPostId",
                keyValue: 4);

            migrationBuilder.DeleteData(
                table: "KatalogPost",
                keyColumn: "KatalogPostId",
                keyValue: 5);

            migrationBuilder.DeleteData(
                table: "KatalogPost",
                keyColumn: "KatalogPostId",
                keyValue: 6);

            migrationBuilder.DeleteData(
                table: "Komentari",
                keyColumn: "KomentarId",
                keyValue: 1);

            migrationBuilder.DeleteData(
                table: "Komentari",
                keyColumn: "KomentarId",
                keyValue: 2);

            migrationBuilder.DeleteData(
                table: "Komentari",
                keyColumn: "KomentarId",
                keyValue: 3);

            migrationBuilder.DeleteData(
                table: "Komentari",
                keyColumn: "KomentarId",
                keyValue: 4);

            migrationBuilder.DeleteData(
                table: "Komentari",
                keyColumn: "KomentarId",
                keyValue: 5);

            migrationBuilder.DeleteData(
                table: "Komentari",
                keyColumn: "KomentarId",
                keyValue: 6);

            migrationBuilder.DeleteData(
                table: "Lajkovi",
                keyColumn: "LajkId",
                keyValue: 1);

            migrationBuilder.DeleteData(
                table: "Lajkovi",
                keyColumn: "LajkId",
                keyValue: 2);

            migrationBuilder.DeleteData(
                table: "Lajkovi",
                keyColumn: "LajkId",
                keyValue: 3);

            migrationBuilder.DeleteData(
                table: "Lajkovi",
                keyColumn: "LajkId",
                keyValue: 4);

            migrationBuilder.DeleteData(
                table: "Lajkovi",
                keyColumn: "LajkId",
                keyValue: 5);

            migrationBuilder.DeleteData(
                table: "Lajkovi",
                keyColumn: "LajkId",
                keyValue: 6);

            migrationBuilder.DeleteData(
                table: "Lajkovi",
                keyColumn: "LajkId",
                keyValue: 7);

            migrationBuilder.DeleteData(
                table: "Notifikacije",
                keyColumn: "NotifikacijaId",
                keyValue: 1);

            migrationBuilder.DeleteData(
                table: "Notifikacije",
                keyColumn: "NotifikacijaId",
                keyValue: 2);

            migrationBuilder.DeleteData(
                table: "Notifikacije",
                keyColumn: "NotifikacijaId",
                keyValue: 3);

            migrationBuilder.DeleteData(
                table: "Notifikacije",
                keyColumn: "NotifikacijaId",
                keyValue: 4);

            migrationBuilder.DeleteData(
                table: "Notifikacije",
                keyColumn: "NotifikacijaId",
                keyValue: 5);

            migrationBuilder.DeleteData(
                table: "Obavijesti",
                keyColumn: "ObavijestId",
                keyValue: 1);

            migrationBuilder.DeleteData(
                table: "Obavijesti",
                keyColumn: "ObavijestId",
                keyValue: 2);

            migrationBuilder.DeleteData(
                table: "Obavijesti",
                keyColumn: "ObavijestId",
                keyValue: 3);

            migrationBuilder.DeleteData(
                table: "Reporti",
                keyColumn: "ReportId",
                keyValue: 1);

            migrationBuilder.DeleteData(
                table: "Reporti",
                keyColumn: "ReportId",
                keyValue: 2);

            migrationBuilder.DeleteData(
                table: "Subkategorije",
                keyColumn: "SubkategorijaId",
                keyValue: 3);

            migrationBuilder.DeleteData(
                table: "Subkategorije",
                keyColumn: "SubkategorijaId",
                keyValue: 6);

            migrationBuilder.DeleteData(
                table: "Subkategorije",
                keyColumn: "SubkategorijaId",
                keyValue: 8);

            migrationBuilder.DeleteData(
                table: "Subkategorije",
                keyColumn: "SubkategorijaId",
                keyValue: 10);

            migrationBuilder.DeleteData(
                table: "Subkategorije",
                keyColumn: "SubkategorijaId",
                keyValue: 11);

            migrationBuilder.DeleteData(
                table: "Subkategorije",
                keyColumn: "SubkategorijaId",
                keyValue: 12);

            migrationBuilder.DeleteData(
                table: "Uplate",
                keyColumn: "UplataId",
                keyValue: 1);

            migrationBuilder.DeleteData(
                table: "Uplate",
                keyColumn: "UplataId",
                keyValue: 2);

            migrationBuilder.DeleteData(
                table: "Uplate",
                keyColumn: "UplataId",
                keyValue: 3);

            migrationBuilder.DeleteData(
                table: "Katalog",
                keyColumn: "KatalogId",
                keyValue: 1);

            migrationBuilder.DeleteData(
                table: "Katalog",
                keyColumn: "KatalogId",
                keyValue: 2);

            migrationBuilder.DeleteData(
                table: "Katalog",
                keyColumn: "KatalogId",
                keyValue: 3);

            migrationBuilder.DeleteData(
                table: "Katalog",
                keyColumn: "KatalogId",
                keyValue: 4);

            migrationBuilder.DeleteData(
                table: "Katalog",
                keyColumn: "KatalogId",
                keyValue: 5);

            migrationBuilder.DeleteData(
                table: "Katalog",
                keyColumn: "KatalogId",
                keyValue: 6);

            migrationBuilder.DeleteData(
                table: "Kategorije",
                keyColumn: "KategorijaId",
                keyValue: 4);

            migrationBuilder.DeleteData(
                table: "Postovi",
                keyColumn: "PostId",
                keyValue: 1);

            migrationBuilder.DeleteData(
                table: "Postovi",
                keyColumn: "PostId",
                keyValue: 2);

            migrationBuilder.DeleteData(
                table: "Postovi",
                keyColumn: "PostId",
                keyValue: 3);

            migrationBuilder.DeleteData(
                table: "Postovi",
                keyColumn: "PostId",
                keyValue: 4);

            migrationBuilder.DeleteData(
                table: "Postovi",
                keyColumn: "PostId",
                keyValue: 5);

            migrationBuilder.DeleteData(
                table: "Postovi",
                keyColumn: "PostId",
                keyValue: 6);

            migrationBuilder.DeleteData(
                table: "Korisnici",
                keyColumn: "KorisnikId",
                keyValue: 1);

            migrationBuilder.DeleteData(
                table: "Korisnici",
                keyColumn: "KorisnikId",
                keyValue: 2);

            migrationBuilder.DeleteData(
                table: "Korisnici",
                keyColumn: "KorisnikId",
                keyValue: 3);

            migrationBuilder.DeleteData(
                table: "Korisnici",
                keyColumn: "KorisnikId",
                keyValue: 4);

            migrationBuilder.DeleteData(
                table: "Korisnici",
                keyColumn: "KorisnikId",
                keyValue: 5);

            migrationBuilder.DeleteData(
                table: "Subkategorije",
                keyColumn: "SubkategorijaId",
                keyValue: 1);

            migrationBuilder.DeleteData(
                table: "Subkategorije",
                keyColumn: "SubkategorijaId",
                keyValue: 2);

            migrationBuilder.DeleteData(
                table: "Subkategorije",
                keyColumn: "SubkategorijaId",
                keyValue: 4);

            migrationBuilder.DeleteData(
                table: "Subkategorije",
                keyColumn: "SubkategorijaId",
                keyValue: 5);

            migrationBuilder.DeleteData(
                table: "Subkategorije",
                keyColumn: "SubkategorijaId",
                keyValue: 7);

            migrationBuilder.DeleteData(
                table: "Subkategorije",
                keyColumn: "SubkategorijaId",
                keyValue: 9);

            migrationBuilder.DeleteData(
                table: "Kategorije",
                keyColumn: "KategorijaId",
                keyValue: 1);

            migrationBuilder.DeleteData(
                table: "Kategorije",
                keyColumn: "KategorijaId",
                keyValue: 2);

            migrationBuilder.DeleteData(
                table: "Kategorije",
                keyColumn: "KategorijaId",
                keyValue: 3);

            migrationBuilder.DeleteData(
                table: "Uloge",
                keyColumn: "UlogaId",
                keyValue: 1);

            migrationBuilder.DeleteData(
                table: "Uloge",
                keyColumn: "UlogaId",
                keyValue: 2);

            migrationBuilder.DeleteData(
                table: "Uloge",
                keyColumn: "UlogaId",
                keyValue: 3);
        }
    }
}
