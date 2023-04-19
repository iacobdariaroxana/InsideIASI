using Newtonsoft.Json;

namespace InsideIASI.Models.PointOfInterest
{
    [Serializable]
    public class ResultResponseModel
    {
        [JsonProperty("results")]
        public IEnumerable<PointOfInterestResponseModel>? PointsOfInterests { get; set; }
    }
}
