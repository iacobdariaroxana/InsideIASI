
using AutoMapper;
using InsideIASI.Application.Models.OpeningHour;
using InsideIASI.DataAccess.Entities;

namespace InsideIASI.Application.Mapping;

public class OpeningHourProfile: Profile
{
    public OpeningHourProfile()
    {
        CreateMap<OpeningHourRequestModel, OpeningHour> ();
        CreateMap<OpeningHour, OpeningHourResponseModel> ();
    }
}
