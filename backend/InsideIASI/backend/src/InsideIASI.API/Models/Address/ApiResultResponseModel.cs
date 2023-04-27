using Newtonsoft.Json;

namespace InsideIASI.backend.src.InsideIASI.API.Models.Address
{
    [Serializable]
    public class ApiResultResponseModel
    {
        [JsonProperty("results")]
        public IEnumerable<AddressResponseModel>? Addresses { get; set; }
    }
}
