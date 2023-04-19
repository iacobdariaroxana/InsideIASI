using InsideIASI.Models.Weather;
using InsideIASI.Services;
using Microsoft.AspNetCore.Mvc;

namespace InsideIASI.Controllers
{
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
}
