using Newtonsoft.Json;
using Newtonsoft.Json.Serialization;

namespace InsideIASI.backend.src.InsideIASI.API.Models.Address
{
    [Serializable]
    public class AddressResponseModel
    {
        [JsonProperty("formatted_address")]
        public String? Address { get; set; }
    }
}
