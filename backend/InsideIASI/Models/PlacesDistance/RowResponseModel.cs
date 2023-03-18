using Newtonsoft.Json;

namespace InsideIASI.Models.PlacesDistance
{
    [Serializable]
    public class RowResponseModel
    {
        [JsonProperty("rows")]
        public IEnumerable<DistanceResponseModel>? Distances { get; set; }
    }
}