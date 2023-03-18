using InsideIASI.Entities;
using Microsoft.AspNetCore.Components.Web.Virtualization;
using Newtonsoft.Json;

namespace InsideIASI.Models.PointOfInterest
{
    [Serializable]
    public class PointOfInterestResponseModel
    {
        [JsonProperty("vicinity")]
        public string? Address { get; set; }

        public string? Name { get; set; }

        public Geometry? Geometry { get; set; }

        [JsonProperty("place_id")]
        public string? PlaceId { get; set; }

        public double? Rating { get; set; }

        public string? Icon { get; set; }

        [JsonProperty("opening_hours")]
        public OpeningHours? OpeningHours { get; set; }
    }
}
