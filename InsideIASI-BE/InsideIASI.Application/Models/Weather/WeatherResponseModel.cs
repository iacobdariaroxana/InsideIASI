using InsideIASI.Application.Entities;
using Newtonsoft.Json;

namespace InsideIASI.Application.Models.Weather;

[Serializable]
public class WeatherResponseModel
{
    [JsonProperty("data")]
    public Data? Data { get; set; }
}
