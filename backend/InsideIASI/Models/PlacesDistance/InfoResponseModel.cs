using InsideIASI.Entities;
using Newtonsoft.Json;

namespace InsideIASI.Models.PlacesDistance
{
    [Serializable]
    public class InfoResponseModel
    {
        [JsonProperty("distance")]
        public Distance? NumberOfKilometers { get; set; }

        [JsonProperty("duration")]
        public Duration? EstimatedTime { get; set; }
    }
}