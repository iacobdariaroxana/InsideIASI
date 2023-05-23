namespace InsideIASI.Application.Exceptions;

public class InvalidWeatherResponseException: Exception
{
    public InvalidWeatherResponseException() { }

    public InvalidWeatherResponseException(string message) : base(message) { }

}
