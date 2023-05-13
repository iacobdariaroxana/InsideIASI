
using InsideIASI.Application.Models.OpeningHour;

namespace InsideIASI.Application.Services;

public interface IOpeningHourService
{
    public Task<OpeningHourResponseModel> CreateAsync(OpeningHourRequestModel openingHourRequest);
}
