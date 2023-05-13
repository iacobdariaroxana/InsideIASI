
using InsideIASI.Application.Models.Image;
using InsideIASI.DataAccess.Entities;

namespace InsideIASI.Application.Services;

public interface IImagePredictionService
{
    Task<PointOfInterest> PredictImage(ImageRequestModel imageRequestModel);
}
