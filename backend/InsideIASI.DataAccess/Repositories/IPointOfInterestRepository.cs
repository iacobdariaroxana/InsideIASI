
using InsideIASI.DataAccess.Entities;

namespace InsideIASI.DataAccess.Repositories;

public interface IPointOfInterestRepository
{
    Task<PointOfInterest> CreateAsync(PointOfInterest pointOfInterest);

    Task<PointOfInterest> GetByNameAsync(string name);
    
    Task<IEnumerable<PointOfInterest>> GetAllAsync();
}
