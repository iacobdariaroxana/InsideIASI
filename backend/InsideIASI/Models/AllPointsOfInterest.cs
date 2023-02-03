using Newtonsoft.Json;

namespace InsideIASI.Models
{
    [Serializable]
    public class AllPointsOfInterest
    {
        [JsonProperty("results")]
        public IEnumerable<PointOfInterest> PointsOfInterests { get; set; }
    }
}
