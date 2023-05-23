
namespace InsideIASI.Application.Exceptions;

[Serializable]
public class PointOfInterestNotFoundException: Exception
{
    public PointOfInterestNotFoundException() { }

    public PointOfInterestNotFoundException(string name) : base($"Point of interest with name {name} not found!") { }
}
