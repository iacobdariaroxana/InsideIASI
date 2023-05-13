using Newtonsoft.Json;

namespace InsideIASI.Application.Models.PlacesDistance;

[Serializable]
public class RowResponseModel
{
    [JsonProperty("rows")]
    public IEnumerable<DistanceResponseModel>? Distances { get; set; }
}