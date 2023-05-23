using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace InsideIASI.DataAccess.Migrations
{
    /// <inheritdoc />
    public partial class LinkColumnForPointsOfInterest : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AddColumn<string>(
                name: "Link",
                table: "PointsOfInterest",
                type: "text",
                nullable: false,
                defaultValue: "");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropColumn(
                name: "Link",
                table: "PointsOfInterest");
        }
    }
}
