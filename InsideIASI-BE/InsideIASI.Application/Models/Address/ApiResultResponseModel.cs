using Newtonsoft.Json;

namespace InsideIASI.Application.Models.Address;

[Serializable]
public class ApiResultResponseModel
{
    [JsonProperty("results")]
    public IEnumerable<AddressResponseModel>? Addresses { get; set; }
}
