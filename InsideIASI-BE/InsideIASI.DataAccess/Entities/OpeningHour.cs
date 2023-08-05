namespace InsideIASI.DataAccess.Entities;

public class OpeningHour: Entity
{
    public string Day { get; set; } = string.Empty;

    public string OpeningTime { get; set; } = string.Empty;

    public string ClosingTime { get; set; } = string.Empty;

    public PointOfInterest PointOfInterest { get; set; }

    public int PointOfInterestId { get; set; }

}
