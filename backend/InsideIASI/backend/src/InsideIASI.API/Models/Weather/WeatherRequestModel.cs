namespace InsideIASI.Models.Weather
{
    public class WeatherRequestModel
    {
        public String? Location { get; set; }

        public IEnumerable<String>? Fields { get; set; }

        public String? Units { get; set; }

        public IEnumerable<String>? Timesteps;

        public string? StartTime { get; set; }

        public string? EndTime { get; set; }

    }
}
