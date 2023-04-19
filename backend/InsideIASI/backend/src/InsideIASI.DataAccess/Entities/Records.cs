
namespace InsideIASI.Entities
{
    public record Point(double Lat, double Lng);

    public record Geometry(Point Location);

    public record OpeningHours(bool Open_Now);

    public record Distance(string text);

    public record Duration(string text);

    public record Values(double Humidity, int PrecipitationProbability, double Temperature);

    public record Interval(DateTime StartTime, Values Values);

    public record Timeline(string Timestep, DateTime EndTime, DateTime StartTime, List<Interval> Intervals);

    public record Data(List<Timeline> Timelines);


}
