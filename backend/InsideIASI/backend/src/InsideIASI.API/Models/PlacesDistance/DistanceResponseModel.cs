using Newtonsoft.Json;

namespace InsideIASI.Models.PlacesDistance
{
    [Serializable]
    public class DistanceResponseModel
    {
        [JsonProperty("elements")]
        public IEnumerable<InfoResponseModel>? Infos { get; set; }
    }
}
