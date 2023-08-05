
using InsideIASI.Application.Mapping;
using InsideIASI.Application.Services;
using InsideIASI.Application.Services.Impl;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;

namespace InsideIASI.Application;

public static class ServiceCollection
{
    public static IServiceCollection AddApplication(this IServiceCollection services, IConfiguration configuration)
    {
        services.AddAutoMapper(typeof(PointOfInterestProfile));
        services.AddAutoMapper(typeof(OpeningHourProfile));

        services.AddScoped<IMapService, MapService>();
        services.AddScoped<IWeatherService, WeatherService>();
        services.AddScoped<IPointOfInterestService, PointOfInterestService>();
        services.AddScoped<IOpeningHourService, OpeningHourService>();
        services.AddScoped<IImagePredictionService, ImagePredictionService>();

        return services;
    }
}
