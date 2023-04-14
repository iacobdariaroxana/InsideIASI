using InsideIASI.Entities;
using Newtonsoft.Json;

namespace InsideIASI.Models.Weather
{
    [Serializable]
    public class WeatherResponseModel
    {
        [JsonProperty("data")]
        public Data? Data { get; set; }
    }

    
    //public class Data
    //{
    //    [JsonProperty("timelines")]
    //    IEnumerable<Timeline>? Timelines { get; set; }
    //}

    //[Serializable]
    //public class Timeline
    //{
    //    [JsonProperty("timestep")]
    //    string? Timestep { get; set; }

    //    [JsonProperty("endTime")]
    //    DateTime? EndTime { get; set; }

    //    [JsonProperty("startTime")]
    //    DateTime? StartTime { get; set; }

    //    [JsonProperty("intervals")]
    //    IEnumerable<Interval>? Intervals { get; set; }
    //}

    //[Serializable]
    //public class Interval
    //{
    //    [JsonProperty("startTime")]
    //    string? startTime { get; set; }

    //    [JsonProperty("values")]
    //    IEnumerable<Value>? Values;
    //}

    //[Serializable]
    //public class Value
    //{
    //    [JsonProperty("humidity")]
    //    double? Humidity;

    //    [JsonProperty("precipitationProbability")]
    //    int? PrecipitationProbability;

    //    [JsonProperty("temperature")]
    //    double? Temperature;
    //}
}

