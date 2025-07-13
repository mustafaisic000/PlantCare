using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace PlantCare.Services.Migrations
{
    /// <inheritdoc />
    public partial class updateSmall : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AlterColumn<decimal>(
                name: "Iznos",
                table: "Transakcije25062025",
                type: "decimal(18,2)",
                nullable: false,
                oldClrType: typeof(float),
                oldType: "real");

            migrationBuilder.UpdateData(
                table: "Transakcije25062025",
                keyColumn: "Transakcija25062025Id",
                keyValue: 1,
                column: "Iznos",
                value: 100m);

            migrationBuilder.UpdateData(
                table: "Transakcije25062025",
                keyColumn: "Transakcija25062025Id",
                keyValue: 2,
                column: "Iznos",
                value: 100m);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AlterColumn<float>(
                name: "Iznos",
                table: "Transakcije25062025",
                type: "real",
                nullable: false,
                oldClrType: typeof(decimal),
                oldType: "decimal(18,2)");

            migrationBuilder.UpdateData(
                table: "Transakcije25062025",
                keyColumn: "Transakcija25062025Id",
                keyValue: 1,
                column: "Iznos",
                value: 100f);

            migrationBuilder.UpdateData(
                table: "Transakcije25062025",
                keyColumn: "Transakcija25062025Id",
                keyValue: 2,
                column: "Iznos",
                value: 100f);
        }
    }
}
