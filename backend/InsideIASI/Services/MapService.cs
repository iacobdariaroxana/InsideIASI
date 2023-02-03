using InsideIASI.Entities;
using InsideIASI.Models;
using Newtonsoft.Json;
using System.Net.Http.Headers;
namespace InsideIASI.Services
{
    public class MapService : IMapService
    {
        private readonly HttpClient _httpClient;
        public MapService(HttpClient httpClient)
        {
            _httpClient = httpClient;
        }

        public async Task<IEnumerable<PointOfInterest>> GetPointsOfInterestAsync(string query, double latitude, double longitude)
        {
            var pois = new List<PointOfInterest>();

            var key = System.Configuration.ConfigurationManager.AppSettings["GoogleMapsKey"];
            //var url = $"https://maps.googleapis.com/maps/api/place/textsearch/json?location={latitude},{longitude}&query={query}&key={key}";

            foreach (var keyword in query.Split(','))
            {
                Console.WriteLine(keyword);
                var url = $"https://maps.googleapis.com/maps/api/place/nearbysearch/json?keyword={keyword}&location={latitude},{longitude}&rankby=distance&key={key}";
                _httpClient.DefaultRequestHeaders.Accept.Add(new MediaTypeWithQualityHeaderValue("application/json"));
                HttpResponseMessage response = await _httpClient.GetAsync(url);

                if (response.IsSuccessStatusCode)
                {
                    var jsonString = await response.Content.ReadAsStringAsync();
                    var pointsList = JsonConvert.DeserializeObject<AllPointsOfInterest>(jsonString);

                    if (pointsList != null)
                    {
                        pois.AddRange(pointsList.PointsOfInterests);
                    }
                }
            }

            return pois;
        }
    }
}
