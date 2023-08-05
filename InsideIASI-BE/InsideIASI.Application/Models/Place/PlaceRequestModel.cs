namespace InsideIASI.Application.Models.Place;

public class PlaceRequestModel
{
    public double Latitude { get; set; }

    public double Longitude { get; set; } 

    public string Query { get; set; } = string.Empty;
}
