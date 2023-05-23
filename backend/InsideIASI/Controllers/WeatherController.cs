using InsideIASI.Application.Exceptions;
using InsideIASI.Application.Models.Weather;
using InsideIASI.Application.Services;
using Microsoft.AspNetCore.Mvc;

namespace InsideIASI.API.Controllers;

[ApiController]
[Route("[controller]")]
public class WeatherController : ControllerBase
{
    private readonly IWeatherService _weatherService;
    public WeatherController(IWeatherService weatherService)
    {
        _weatherService = weatherService;
    }

    [HttpPost]
    public async Task<IActionResult> GetCurrentWeatherAsync([FromBody] WeatherRequestModel weatherRequestModel)
    {
        try
        {
            var weather = await _weatherService.GetCurrentWeatherAsync(weatherRequestModel);
            return Ok(weather);
        }
        catch (InvalidWeatherResponseException e) { return NotFound(e.Message); }
        catch (WeatherException e) { return BadRequest(e.Message); }
    }
}
