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
    public async Task<IActionResult> PredictImage([FromBody]ImageRequestModel imageRequestModel)
    {
        var result = await _imagePredicitionService.PredictImage(imageRequestModel);

        return Ok(result);
    }
}
