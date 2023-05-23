using InsideIASI.Application.Exceptions;
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
    public async Task<IActionResult> GetPlacesAsync([FromQuery] PlaceRequestModel placeRequestModel)
    {
        var pois = await _mapService.GetPlacesAsync(placeRequestModel);
        return Ok(pois);
    }


    [HttpGet]
    [Route("distance")]
    public async Task<IActionResult> GetDistanceAsync([FromQuery] DistanceRequestModel distanceRequestModel)
    {
        try
        {
            var distance = await _mapService.GetDistanceFromUserLocationAsync(distanceRequestModel);
            return Ok(distance);
        }
        catch (DistanceException e) { return NotFound(e.Message); }
    }

    [HttpGet]
    [Route("address")]
    public async Task<IActionResult> GetAddressAsync([FromQuery] AddressRequestModel addressRequestModel)
    {
        try
        {
            var address = await _mapService.GetAddressByLongitudinalCoordinatesAsync(addressRequestModel);
            return Ok(address);
        }
        catch (AddressException e) { return NotFound(e.Message); };
    }
}

