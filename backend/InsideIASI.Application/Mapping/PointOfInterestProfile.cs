using AutoMapper;
using InsideIASI.Application.Models.PointOfInterest;
using InsideIASI.DataAccess.Entities;

namespace InsideIASI.Application.Mapping;

public class PointOfInterestProfile : Profile
{
    public PointOfInterestProfile()
    {
        this.CreateMap<PointOfInterest, PointOfInterestResponseModel>();
        this.CreateMap<PointOfInterestRequestModel, PointOfInterest>();

    }
}
