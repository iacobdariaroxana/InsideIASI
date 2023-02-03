using InsideIASI.Entities;
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

        [HttpGet(Name = "GetPointsOfInterest")]
        public async Task<IActionResult> Get(double latitude, double longitude, string query)
        {
            var pois = await _mapService.GetPointsOfInterestAsync(query, latitude, longitude);
            return Ok(pois);
        }
    }
}
