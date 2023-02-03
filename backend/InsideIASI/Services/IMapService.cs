using InsideIASI.Entities;
using InsideIASI.Models;

namespace InsideIASI.Services
{
    public interface IMapService
    {
        Task<IEnumerable<PointOfInterest>> GetPointsOfInterestAsync(string query, double latitude, double longitude);
    }
}
