using InsideIASI.DataAccess.Entities;
using InsideIASI.DataAccess.Persistence;
using Microsoft.EntityFrameworkCore;

namespace InsideIASI.DataAccess.Repositories.Impl;

public class PointOfInterestRepository : IPointOfInterestRepository
{
    private readonly DatabaseContext _databaseContext;

    public PointOfInterestRepository(DatabaseContext databaseContext)
    {
        _databaseContext = databaseContext;
    }

    public async Task<PointOfInterest> CreateAsync(PointOfInterest pointOfInterest)
    {
        var addedPointOfInterest = (await _databaseContext.PointsOfInterest.AddAsync(pointOfInterest)).Entity;
        await _databaseContext.SaveChangesAsync();
        return addedPointOfInterest;
    }

    public async Task<PointOfInterest?> GetByNameAsync(string name)
    {
        var pointOfInterest = await _databaseContext.PointsOfInterest.Include(point => point.OpeningHours).Where(point => point.Name == name).FirstOrDefaultAsync();
        return pointOfInterest;
    }

    public async Task<IEnumerable<PointOfInterest>> GetAllAsync()
    {
        var pointsOfInterest = await _databaseContext.PointsOfInterest.Include(point => point.OpeningHours).ToListAsync();

        return pointsOfInterest;
    }
}
