namespace InsideIASI.DataAccess.Entities;

public class PointOfInterest: Entity
{
    public String Name { get; set; } = string.Empty;

    public string Info0 { get; set; } = string.Empty;

    public string Info1 { get; set; } = string.Empty;

    public string Info2 { get; set; } = string.Empty;

    public string Info3 { get; set; } = string.Empty;

    public IEnumerable<OpeningHour> OpeningHours { get; set; }

    public string Link { get; set; } = string.Empty;

}
