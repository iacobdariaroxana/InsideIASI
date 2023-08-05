using InsideIASI.Application.Exceptions;
using InsideIASI.Application.Models.Image;
using InsideIASI.Application.Services;
using Microsoft.AspNetCore.Mvc;

namespace InsideIASI.API.Controllers;

[ApiController]
[Route("[controller]")]
public class ImagePredictionsController : ControllerBase
{
    private readonly IImagePredictionService _imagePredicitionService;

    public ImagePredictionsController(IImagePredictionService imagePredicitionService)
    {
        _imagePredicitionService = imagePredicitionService;
    }

    [HttpPost]
    public async Task<IActionResult> PredictImageAsync([FromBody] ImageRequestModel imageRequestModel)
    {
        try
        {
            var result = await _imagePredicitionService.PredictImageAsync(imageRequestModel);
            return Ok(result);
        }
        catch (PointOfInterestNotFoundException e)
        {
            return NotFound(e.Message);
        }
        catch (ImagePredictionException e)
        {
            return NotFound(e.Message);
        }
    }
}
