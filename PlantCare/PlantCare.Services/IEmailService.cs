﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PlantCare.Services
{
    public interface IEmailService
    {
        public void SendingMessage(string message);
        public void SendingObject<T>(T obj);
    }
}
