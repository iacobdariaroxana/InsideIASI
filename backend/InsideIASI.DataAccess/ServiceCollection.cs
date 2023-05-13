using InsideIASI.DataAccess.Persistence;
using InsideIASI.DataAccess.Repositories;
using InsideIASI.DataAccess.Repositories.Impl;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;

namespace InsideIASI.DataAccess;

public static class ServiceCollection
{
    public static IServiceCollection AddDataAccess(this IServiceCollection services, IConfiguration configuration)
    {
        services.AddDbContext<DatabaseContext>(options =>
        {
            options.UseNpgsql(configuration["Database:ConnectionString"]);
        });

        services.AddScoped<IPointOfInterestRepository, PointOfInterestRepository>();
        services.AddScoped<IOpeningHourRepository, OpeningHourRepository>();

        return services;
    }
}
