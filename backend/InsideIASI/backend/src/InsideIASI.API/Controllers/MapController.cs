using InsideIASI.Entities;
using InsideIASI.Models.PlacesDistance;
using InsideIASI.Models.PointOfInterest;
using InsideIASI.Services;
using Microsoft.AspNetCore.Mvc;

namespace InsideIASI.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class MapController : ControllerBase
    {
        private readonly IMapService _mapService;
        public MapController(IMapService mapService)
        {
            _mapService = mapService;
        }

        [HttpGet]
        [Route("pois")]
        public async Task<IActionResult> GetPointsOfInterest([FromQuery] PointOfInterestRequestModel pointOfInterestRequestModel)
        {
            var pois = await _mapService.GetPointsOfInterestAsync(pointOfInterestRequestModel);

            return Ok(pois);
        }


        [HttpGet]
        [Route("distance")]
        public async Task<IActionResult> GetDistance([FromQuery] DistanceRequestModel distanceRequestModel)
        {
            var distance = await _mapService.GetDistanceFromUserLocation(distanceRequestModel);

            return Ok(distance);
        }
    }
}
