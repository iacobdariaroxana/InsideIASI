using InsideIASI.Entities;
using Microsoft.AspNetCore.Components.Web.Virtualization;
using Newtonsoft.Json;

namespace InsideIASI.Models
{
    [Serializable]
    public class PointOfInterest
    {
        [JsonProperty("formatted_address")]
        public string Address { get; set; }

        public string Name { get; set; }

        public Geometry Geometry { get; set; }

        public string Place_Id { get; set; }

        public double Rating { get; set; }

        public string Icon { get; set; }
    }
}
