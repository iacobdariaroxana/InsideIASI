using InsideIASI.Application.Models.Address;
using InsideIASI.Application.Models.Place;
using InsideIASI.Application.Models.PlacesDistance;
using InsideIASI.Application.Services;
using Microsoft.AspNetCore.Mvc;

namespace InsideIASI.API.Controllers;

[ApiController]
[Route("[controller]")]
public class MapsController : ControllerBase
{
    private readonly IMapService _mapService;
    public MapsController(IMapService mapService)
    {
        _mapService = mapService;
    }

    [HttpGet]
    [Route("places")]
    public async Task<IActionResult> GetPlaces([FromQuery] PlaceRequestModel placeRequestModel)
    {
        var pois = await _mapService.GetPlacesAsync(placeRequestModel);

        return Ok(pois);
    }


    [HttpGet]
    [Route("distance")]
    public async Task<IActionResult> GetDistance([FromQuery] DistanceRequestModel distanceRequestModel)
    {
        var distance = await _mapService.GetDistanceFromUserLocation(distanceRequestModel);

        return Ok(distance);
    }

    [HttpGet]
    [Route("address")]
    public async Task<IActionResult> GetAddress([FromQuery] AddressRequestModel addressRequestModel)
    {
        var address = await _mapService.GetAddressByLongitudinalCoordinates(addressRequestModel);
        return Ok(address);
    }
}

