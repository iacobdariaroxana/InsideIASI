using InsideIASI.DataAccess.Entities;

namespace InsideIASI.DataAccess.Repositories;

public interface IOpeningHourRepository
{
    Task<OpeningHour> CreateAsync(OpeningHour openingHour);
}
