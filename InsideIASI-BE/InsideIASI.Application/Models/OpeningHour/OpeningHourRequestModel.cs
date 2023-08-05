
namespace InsideIASI.Application.Models.OpeningHour;

public class OpeningHourRequestModel
{
    public string Day { get; set; }

    public string OpeningTime { get; set; }

    public string ClosingTime { get; set; }

    public int PointOfInterestId { get; set; }
}
