using AutoMapper;
using InsideIASI.Application.Models.PointOfInterest;
using InsideIASI.DataAccess.Entities;
using InsideIASI.DataAccess.Repositories;

namespace InsideIASI.Application.Services.Impl;

public class PointOfInterestService : IPointOfInterestService
{
    private readonly IPointOfInterestRepository _pointOfInterestRepository;
    private readonly IMapper _mapper;

    public PointOfInterestService(IPointOfInterestRepository pointOfInterestRepository, IMapper mapper)
    {
        _pointOfInterestRepository = pointOfInterestRepository;
        _mapper = mapper;
    }

    public async Task<PointOfInterestResponseModel> CreateAsync(PointOfInterestRequestModel pointOfInterestRequestModel)
    {
        var pointOfInterest = _mapper.Map<PointOfInterest>(pointOfInterestRequestModel);
        var addedPointOfInterest = await _pointOfInterestRepository.CreateAsync(pointOfInterest);

        return _mapper.Map<PointOfInterestResponseModel>(addedPointOfInterest);
    }

    public async Task<IEnumerable<PointOfInterest>> GetAllAsync()
    {
        var pointsOfInterest = await _pointOfInterestRepository.GetAllAsync();

        return pointsOfInterest;
    }

    public async Task<PointOfInterest> GetByNameAsync(string name)
    {
        var pointOfInterest = await _pointOfInterestRepository.GetByNameAsync(name);
        return pointOfInterest;
    }
}
