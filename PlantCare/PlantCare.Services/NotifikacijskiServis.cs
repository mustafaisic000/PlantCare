using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Microsoft.AspNetCore.SignalR;
using PlantCare.Services.SignalR;


namespace PlantCare.Services
{
    public class NotifikacijskiServis : INotifikacijskiServis
    {
        private readonly IHubContext<NotifikacijaHub, INotifikacijaHub> _hubContext;

        public NotifikacijskiServis(IHubContext<NotifikacijaHub, INotifikacijaHub> hubContext)
        {
            _hubContext = hubContext;
        }

        public async Task PosaljiPoruku(string poruka)
        {
            await _hubContext.Clients.All.NovaPoruka(poruka);
        }
    }
}
