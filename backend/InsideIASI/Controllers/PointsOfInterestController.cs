using InsideIASI.Application.Exceptions;
using InsideIASI.Application.Models.PointOfInterest;
using InsideIASI.Application.Services;
using Microsoft.AspNetCore.Mvc;

namespace InsideIASI.API.Controllers;

[ApiController]
[Route("[controller]")]
public class PointsOfInterestController : ControllerBase
{
    private readonly IPointOfInterestService _pointOfInterestService;

    public PointsOfInterestController(IPointOfInterestService pointOfInterestService)
    {
        _pointOfInterestService = pointOfInterestService;
    }

    [HttpPost]
    public async Task<IActionResult> CreateAsync([FromBody] PointOfInterestRequestModel pointOfInterest)
    {
        var result = await _pointOfInterestService.CreateAsync(pointOfInterest);
        return Ok(result);
    }

    [HttpGet("{name}")]
    public async Task<IActionResult> GetByNameAsync(string name)
    {
        try
        {
            var result = await _pointOfInterestService.GetByNameAsync(name);
            return Ok(result);
        }
        catch (PointOfInterestNotFoundException e) { return NotFound(e.Message); }

    }

    [HttpGet]
    public async Task<IActionResult> GetAllAsync()
    {
        var result = await _pointOfInterestService.GetAllAsync();

        return Ok(result);
    }
}
