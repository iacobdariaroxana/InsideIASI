using InsideIASI.Application.Models.Address;
using InsideIASI.Application.Models.Place;
using InsideIASI.Application.Models.PlacesDistance;

namespace InsideIASI.Application.Services;

public interface IMapService
{
    Task<IEnumerable<PlaceResponseModel>> GetPlacesAsync(PlaceRequestModel placeRequestModel);

    Task<InfoResponseModel> GetDistanceFromUserLocationAsync(DistanceRequestModel distanceRequestModel);

    Task<AddressResponseModel> GetAddressByLongitudinalCoordinatesAsync(AddressRequestModel addressRequestModel);

}
