using InsideIASI.Application.Models.Weather;
using InsideIASI.Application.Services;
using Microsoft.AspNetCore.Mvc;

namespace InsideIASI.API.Controllers;

[ApiController]
[Route("[controller]")]
public class WeatherController: ControllerBase
{
    private readonly IWeatherService _weatherService;
    public WeatherController(IWeatherService weatherService)
    {
        _weatherService = weatherService;
    }

    [HttpPost]
    public async Task<IActionResult> GetCurrentWeather([FromBody] WeatherRequestModel weatherRequestModel)
    {
        var weather = await _weatherService.GetCurrentWeather(weatherRequestModel);
        return Ok(weather);
    }
}
