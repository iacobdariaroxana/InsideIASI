using Microsoft.EntityFrameworkCore.Migrations;
using Npgsql.EntityFrameworkCore.PostgreSQL.Metadata;

#nullable disable

namespace InsideIASI.DataAccess.Migrations
{
    /// <inheritdoc />
    public partial class PointOfInterestOpeningHoursRelationship : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.CreateTable(
                name: "PointsOfInterest",
                columns: table => new
                {
                    Id = table.Column<int>(type: "integer", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    Name = table.Column<string>(type: "text", nullable: false),
                    Info0 = table.Column<string>(type: "text", nullable: false),
                    Info1 = table.Column<string>(type: "text", nullable: false),
                    Info2 = table.Column<string>(type: "text", nullable: false),
                    Info3 = table.Column<string>(type: "text", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_PointsOfInterest", x => x.Id);
                });

            migrationBuilder.CreateTable(
                name: "OpeningHours",
                columns: table => new
                {
                    Id = table.Column<int>(type: "integer", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    Day = table.Column<string>(type: "text", nullable: false),
                    OpeningTime = table.Column<string>(type: "text", nullable: false),
                    ClosingTime = table.Column<string>(type: "text", nullable: false),
                    PointOfInterestId = table.Column<int>(type: "integer", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_OpeningHours", x => x.Id);
                    table.ForeignKey(
                        name: "FK_OpeningHours_PointsOfInterest_PointOfInterestId",
                        column: x => x.PointOfInterestId,
                        principalTable: "PointsOfInterest",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateIndex(
                name: "IX_OpeningHours_PointOfInterestId",
                table: "OpeningHours",
                column: "PointOfInterestId");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropTable(
                name: "OpeningHours");

            migrationBuilder.DropTable(
                name: "PointsOfInterest");
        }
    }
}
