using Newtonsoft.Json;

namespace InsideIASI.Application.Models.Place;

[Serializable]
public class ResultResponseModel
{
    [JsonProperty("results")]
    public IEnumerable<PlaceResponseModel>? Places { get; set; }
}
