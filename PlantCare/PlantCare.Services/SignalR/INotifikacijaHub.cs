using Microsoft.AspNetCore.SignalR;

namespace PlantCare.Services.SignalR
{
    public interface INotifikacijaHub
    {
        Task NovaPoruka(string poruka);
    }
}
