using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

#pragma warning disable CA1814 // Prefer jagged arrays over multidimensional

namespace PlantCare.Services.Migrations
{
    /// <inheritdoc />
    public partial class finalExam : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.CreateTable(
                name: "Kategorije25062025",
                columns: table => new
                {
                    KategorijaTransakcije25062025Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    NazivKategorije = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    Tip = table.Column<string>(type: "nvarchar(max)", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Kategorije25062025", x => x.KategorijaTransakcije25062025Id);
                });

            migrationBuilder.CreateTable(
                name: "TransakcijeLog25062025",
                columns: table => new
                {
                    TransakcijeLog25062025Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    StaraVrijednost = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    NovaVrijednost = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    DatumIzmjene = table.Column<DateTime>(type: "datetime2", nullable: false),
                    KorisnikId = table.Column<int>(type: "int", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_TransakcijeLog25062025", x => x.TransakcijeLog25062025Id);
                    table.ForeignKey(
                        name: "FK_TransakcijeLog25062025_Korisnici_KorisnikId",
                        column: x => x.KorisnikId,
                        principalTable: "Korisnici",
                        principalColumn: "KorisnikId",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "Limiti25062025",
                columns: table => new
                {
                    FinansijskiLimit25062025Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    KorisnikId = table.Column<int>(type: "int", nullable: false),
                    KategorijaTransakcije25062025Id = table.Column<int>(type: "int", nullable: false),
                    Limit = table.Column<decimal>(type: "decimal(18,2)", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Limiti25062025", x => x.FinansijskiLimit25062025Id);
                    table.ForeignKey(
                        name: "FK_Limiti25062025_Kategorije25062025_KategorijaTransakcije25062025Id",
                        column: x => x.KategorijaTransakcije25062025Id,
                        principalTable: "Kategorije25062025",
                        principalColumn: "KategorijaTransakcije25062025Id",
                        onDelete: ReferentialAction.Cascade);
                    table.ForeignKey(
                        name: "FK_Limiti25062025_Korisnici_KorisnikId",
                        column: x => x.KorisnikId,
                        principalTable: "Korisnici",
                        principalColumn: "KorisnikId",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "Transakcije25062025",
                columns: table => new
                {
                    Transakcija25062025Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    KorisnikId = table.Column<int>(type: "int", nullable: false),
                    Iznos = table.Column<float>(type: "real", nullable: false),
                    DatumTransakcije = table.Column<DateTime>(type: "datetime2", nullable: false),
                    Opis = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    KategorijaTransakcije25062025Id = table.Column<int>(type: "int", nullable: false),
                    Status = table.Column<string>(type: "nvarchar(max)", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Transakcije25062025", x => x.Transakcija25062025Id);
                    table.ForeignKey(
                        name: "FK_Transakcije25062025_Kategorije25062025_KategorijaTransakcije25062025Id",
                        column: x => x.KategorijaTransakcije25062025Id,
                        principalTable: "Kategorije25062025",
                        principalColumn: "KategorijaTransakcije25062025Id",
                        onDelete: ReferentialAction.Cascade);
                    table.ForeignKey(
                        name: "FK_Transakcije25062025_Korisnici_KorisnikId",
                        column: x => x.KorisnikId,
                        principalTable: "Korisnici",
                        principalColumn: "KorisnikId",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.InsertData(
                table: "Kategorije25062025",
                columns: new[] { "KategorijaTransakcije25062025Id", "NazivKategorije", "Tip" },
                values: new object[,]
                {
                    { 1, "Hrana", "Rashod" },
                    { 2, "Prevoz", "Rashod" }
                });

            migrationBuilder.InsertData(
                table: "Limiti25062025",
                columns: new[] { "FinansijskiLimit25062025Id", "KategorijaTransakcije25062025Id", "KorisnikId", "Limit" },
                values: new object[,]
                {
                    { 1, 1, 2, 300m },
                    { 2, 2, 2, 300m }
                });

            migrationBuilder.InsertData(
                table: "Transakcije25062025",
                columns: new[] { "Transakcija25062025Id", "DatumTransakcije", "Iznos", "KategorijaTransakcije25062025Id", "KorisnikId", "Opis", "Status" },
                values: new object[,]
                {
                    { 1, new DateTime(2025, 6, 6, 0, 0, 0, 0, DateTimeKind.Unspecified), 100f, 1, 2, "Test", "Planirano" },
                    { 2, new DateTime(2025, 6, 6, 0, 0, 0, 0, DateTimeKind.Unspecified), 100f, 2, 2, "Test 1", "Planirano" }
                });

            migrationBuilder.CreateIndex(
                name: "IX_Limiti25062025_KategorijaTransakcije25062025Id",
                table: "Limiti25062025",
                column: "KategorijaTransakcije25062025Id");

            migrationBuilder.CreateIndex(
                name: "IX_Limiti25062025_KorisnikId",
                table: "Limiti25062025",
                column: "KorisnikId");

            migrationBuilder.CreateIndex(
                name: "IX_Transakcije25062025_KategorijaTransakcije25062025Id",
                table: "Transakcije25062025",
                column: "KategorijaTransakcije25062025Id");

            migrationBuilder.CreateIndex(
                name: "IX_Transakcije25062025_KorisnikId",
                table: "Transakcije25062025",
                column: "KorisnikId");

            migrationBuilder.CreateIndex(
                name: "IX_TransakcijeLog25062025_KorisnikId",
                table: "TransakcijeLog25062025",
                column: "KorisnikId");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropTable(
                name: "Limiti25062025");

            migrationBuilder.DropTable(
                name: "Transakcije25062025");

            migrationBuilder.DropTable(
                name: "TransakcijeLog25062025");

            migrationBuilder.DropTable(
                name: "Kategorije25062025");
        }
    }
}
