
namespace InsideIASI.Application.Models.OpeningHour;

public class OpeningHourResponseModel
{
    public int Id { get; set; }

    public string Day { get; set; } = string.Empty;

    public string OpeningTime { get; set; } = string.Empty;

    public string ClosingTime { get; set; } = string.Empty;

    public int PointOfInterestId { get; set; }
}
