using InsideIASI.Models.PlacesDistance;
using InsideIASI.Models.PointOfInterest;

namespace InsideIASI.Services
{
    public interface IMapService
    {
        Task<IEnumerable<PointOfInterestResponseModel>> GetPointsOfInterestAsync(PointOfInterestRequestModel pointOfInterestRequestModel);
        Task<InfoResponseModel> GetDistanceFromUserLocation(DistanceRequestModel distanceRequestModel);
    }
}
