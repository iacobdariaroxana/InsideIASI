using InsideIASI.Application.Models.Weather;

namespace InsideIASI.Application.Services;

public interface IWeatherService
{
    Task<WeatherResponseModel> GetCurrentWeather(WeatherRequestModel weatherRequestModel);
}

