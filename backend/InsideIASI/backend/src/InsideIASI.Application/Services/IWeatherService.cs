
using InsideIASI.Models.Weather;

namespace InsideIASI.Services
{
    public interface IWeatherService
    {
        Task<WeatherResponseModel> GetCurrentWeather(WeatherRequestModel weatherRequestModel);
    }
}
