using InsideIASI.Application.Models.Address;
using InsideIASI.Application.Models.Place;
using InsideIASI.Application.Models.PlacesDistance;
using Newtonsoft.Json;
using System.Net.Http.Headers;

namespace InsideIASI.Application.Services.Impl;


public class MapService : IMapService
{
    private readonly HttpClient _httpClient;
    public MapService(HttpClient httpClient)
    {
        _httpClient = httpClient;
    }

    public async Task<IEnumerable<PlaceResponseModel>> GetPlacesAsync(PlaceRequestModel placeRequestModel)
    {
        var pois = new List<PlaceResponseModel>();

        var key = System.Configuration.ConfigurationManager.AppSettings["GoogleMapsKey"];

        foreach (var keyword in placeRequestModel.Query.Split(','))
        {
            var url = $"https://maps.googleapis.com/maps/api/place/nearbysearch/json?keyword={keyword}&location={placeRequestModel.Latitude},{placeRequestModel.Longitude}&rankby=distance&key={key}";
            _httpClient.DefaultRequestHeaders.Accept.Add(new MediaTypeWithQualityHeaderValue("application/json"));
            HttpResponseMessage response = await _httpClient.GetAsync(url);

            if (response.IsSuccessStatusCode)
            {                   
                var jsonString = await response.Content.ReadAsStringAsync();
                var placesList = JsonConvert.DeserializeObject<ResultResponseModel>(jsonString);

                if (placesList != null && placesList.Places != null)
                {
                    pois.AddRange(placesList.Places);
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

    public async Task<AddressResponseModel> GetAddressByLongitudinalCoordinates(AddressRequestModel addressRequestModel)
    {
        var address = new AddressResponseModel();

        var key = System.Configuration.ConfigurationManager.AppSettings["GoogleMapsKey"];

        var url = $"https://maps.googleapis.com/maps/api/geocode/json?latlng={addressRequestModel.Latitude}, {addressRequestModel.Longitude}&key={key}&result_type=route";

        _httpClient.DefaultRequestHeaders.Accept.Add(new MediaTypeWithQualityHeaderValue("application/json"));
        HttpResponseMessage response = await _httpClient.GetAsync(url);
        if (response.IsSuccessStatusCode)
        {
            var jsonString = await response.Content.ReadAsStringAsync();
            var addresses = JsonConvert.DeserializeObject<ApiResultResponseModel>(jsonString);
            if (addresses != null)
            {
                Console.WriteLine(addresses.Addresses.First().Address);
                address = addresses.Addresses.First();
            }
        }
        return address;
    }
}
