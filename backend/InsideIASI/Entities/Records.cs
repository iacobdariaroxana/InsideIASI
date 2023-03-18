
namespace InsideIASI.Entities
{
    public record Point(double Lat, double Lng);
    public record Geometry(Point Location);
    public record OpeningHours(bool Open_Now);
    public record Distance (string text);
    public record Duration(string text);
}
