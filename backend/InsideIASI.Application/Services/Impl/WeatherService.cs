using InsideIASI.Application.Exceptions;
using InsideIASI.Application.Models.Weather;
using Newtonsoft.Json;
using System.Net.Http.Headers;
using System.Text;

namespace InsideIASI.Application.Services.Impl;

public class WeatherService : IWeatherService
{
    private readonly HttpClient _httpClient;
    public WeatherService(HttpClient httpClient)
    {
        _httpClient = httpClient;
    }
    public async Task<WeatherResponseModel> GetCurrentWeatherAsync(WeatherRequestModel weatherRequestModel)
    {
        var key = System.Configuration.ConfigurationManager.AppSettings["TomorrowApiKey"];
        var url = $"https://api.tomorrow.io/v4/timelines?apikey={key}";
        //WeatherResponseModel weather = new();
        _httpClient.DefaultRequestHeaders.Accept.Add(new MediaTypeWithQualityHeaderValue("application/json"));
        var stringContent = new StringContent(JsonConvert.SerializeObject(weatherRequestModel), Encoding.UTF8, "application/json");
        HttpResponseMessage response = await _httpClient.PostAsync(url, stringContent);

        if (response.IsSuccessStatusCode)
        {
            var jsonString = await response.Content.ReadAsStringAsync();
            var weather = JsonConvert.DeserializeObject<WeatherResponseModel>(jsonString);
            if (weather == null)
            {
                throw new InvalidWeatherResponseException();
            }
            return weather;
        }
        throw new WeatherException("Something went wrong while calling the Tommorrow.io API");
    }
}
