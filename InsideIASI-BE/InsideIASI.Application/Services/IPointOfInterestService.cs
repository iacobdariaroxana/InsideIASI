using InsideIASI.Application.Models.PointOfInterest;
using InsideIASI.DataAccess.Entities;

namespace InsideIASI.Application.Services;

public interface IPointOfInterestService
{
    Task<PointOfInterestResponseModel> CreateAsync(PointOfInterestRequestModel pointOfInterest);

    Task<PointOfInterest> GetByNameAsync(string name);

    Task<IEnumerable<PointOfInterest>> GetAllAsync();
}

