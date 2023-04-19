using InsideIASI.Models.PlacesDistance;
using InsideIASI.Models.PointOfInterest;
using Newtonsoft.Json;
using System.Net.Http.Headers;
namespace InsideIASI.Services.Impl
{
    public class MapService : IMapService
    {
        private readonly HttpClient _httpClient;
        public MapService(HttpClient httpClient)
        {
            _httpClient = httpClient;
        }

        public async Task<IEnumerable<PointOfInterestResponseModel>> GetPointsOfInterestAsync(PointOfInterestRequestModel pointOfInterestRequestModel)
        {
            var pois = new List<PointOfInterestResponseModel>();

            var key = System.Configuration.ConfigurationManager.AppSettings["GoogleMapsKey"];

            foreach (var keyword in pointOfInterestRequestModel.Query.Split(','))
            {
                var url = $"https://maps.googleapis.com/maps/api/place/nearbysearch/json?keyword={keyword}&location={pointOfInterestRequestModel.Latitude},{pointOfInterestRequestModel.Longitude}&rankby=distance&key={key}";
                _httpClient.DefaultRequestHeaders.Accept.Add(new MediaTypeWithQualityHeaderValue("application/json"));
                HttpResponseMessage response = await _httpClient.GetAsync(url);

                if (response.IsSuccessStatusCode)
                {                   
                    var jsonString = await response.Content.ReadAsStringAsync();
                    var pointsList = JsonConvert.DeserializeObject<ResultResponseModel>(jsonString);

                    if (pointsList != null && pointsList.PointsOfInterests != null)
                    {
                        pois.AddRange(pointsList.PointsOfInterests);
                    }
                }
            }

            return pois;
        }

        public async Task<InfoResponseModel> GetDistanceFromUserLocation(DistanceRequestModel distanceRequestModel)
        {
            var info = new InfoResponseModel();
            var key = System.Configuration.ConfigurationManager.AppSettings["GoogleMapsKey"];

            var url = $"https://maps.googleapis.com/maps/api/distancematrix/json?origins={distanceRequestModel.OriginLatitude}, {distanceRequestModel.OriginLongitude}&destinations={distanceRequestModel.DestLatitude}, {distanceRequestModel.DestLongitude}&mode=walking&key={key}";

            _httpClient.DefaultRequestHeaders.Accept.Add(new MediaTypeWithQualityHeaderValue("application/json"));
            HttpResponseMessage response = await _httpClient.GetAsync(url);

            if (response.IsSuccessStatusCode)
            {
                var jsonString = await response.Content.ReadAsStringAsync();
                var distancesList = JsonConvert.DeserializeObject<RowResponseModel>(jsonString);

                if (distancesList != null)
                {
                    info = distancesList.Distances.First().Infos.First();
                }
            }
            return info;
        }
    }
}
