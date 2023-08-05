
using InsideIASI.Application.Exceptions;
using InsideIASI.Application.Models.Image;
using InsideIASI.DataAccess.Entities;
using InsideIASI.DataAccess.Repositories;
using Newtonsoft.Json;
using System.Net.Http.Headers;
using System.Text;

namespace InsideIASI.Application.Services.Impl;

public class ImagePredictionService : IImagePredictionService
{
    private readonly IPointOfInterestRepository _pointOfInterestRepository;
    private readonly HttpClient _httpClient;

    public ImagePredictionService(IPointOfInterestRepository pointOfInterestRepository, HttpClient httpClient)
    {
        _pointOfInterestRepository = pointOfInterestRepository;
        _httpClient = httpClient;
    }

    public async Task<PointOfInterest> PredictImageAsync(ImageRequestModel imageRequestModel)
    {
        var url = "https://insideiasi-nn.azurewebsites.net/predict";
        _httpClient.DefaultRequestHeaders.Accept.Add(new MediaTypeWithQualityHeaderValue("application/json"));

        var stringContent = new StringContent(JsonConvert.SerializeObject(imageRequestModel), Encoding.UTF8, "application/json");
        HttpResponseMessage response = await _httpClient.PostAsync(url, stringContent);


        if (response.IsSuccessStatusCode)
        {
            var jsonString = await response.Content.ReadAsStringAsync();
            var image = JsonConvert.DeserializeObject<ImageResponseModel>(jsonString);
            if (image != null)
            {
                var pointOfInterest = await _pointOfInterestRepository.GetByNameAsync(image.Label);
                if (pointOfInterest == null) { throw new PointOfInterestNotFoundException(image.Label); }
                return pointOfInterest;
            }
        }
        throw new ImagePredictionException("Something went wrong while calling the image classifier API");
    }
}
