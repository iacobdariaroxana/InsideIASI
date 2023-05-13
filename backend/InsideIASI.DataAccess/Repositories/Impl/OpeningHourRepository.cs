
using InsideIASI.DataAccess.Entities;
using InsideIASI.DataAccess.Persistence;

namespace InsideIASI.DataAccess.Repositories.Impl;

public class OpeningHourRepository : IOpeningHourRepository
{
    private readonly DatabaseContext _databaseContext;

    public OpeningHourRepository(DatabaseContext databaseContext)
    {
        _databaseContext = databaseContext;
    }

    public async Task<OpeningHour> CreateAsync(OpeningHour openingHour)
    {
        var addedOpeningHour = (await _databaseContext.OpeningHours.AddAsync(openingHour)).Entity;
        await _databaseContext.SaveChangesAsync();
        return addedOpeningHour;
    }
}
