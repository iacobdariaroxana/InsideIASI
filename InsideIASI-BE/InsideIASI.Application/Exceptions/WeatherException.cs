
namespace InsideIASI.Application.Exceptions;

public class WeatherException: Exception
{
    public WeatherException() { } 

    public WeatherException(string message) : base(message) { }

}
