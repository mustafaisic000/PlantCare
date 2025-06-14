using System.Net.Mail;
using System.Net;

namespace PlantCare.RabbitMQ
{
    public class EmailSender : IEmailSender
    {

        private readonly string _gMail = Environment.GetEnvironmentVariable("SMTP_USERNAME") ?? "plantcarers2@gmail.com";
        private readonly string _gPass = Environment.GetEnvironmentVariable("SMTP_PASSWORD") ?? "dxlc tfqr mabr dglt";
        private readonly string _gServer = Environment.GetEnvironmentVariable("SMTP_SERVER") ?? "smtp.gmail.com";
        private readonly int _port;


        public EmailSender()
        {
            if (!int.TryParse(Environment.GetEnvironmentVariable("SMTP_PORT"), out _port))
            {
                throw new ArgumentException("SMTP_PORT environment variable is not a valid integer");
            }
        }

        public Task SendEmailAsync(string email, string subject, string message)
        {
            var client = new SmtpClient(_gServer, _port)
            {
                EnableSsl = true,
                UseDefaultCredentials = false,
                Credentials = new NetworkCredential(_gMail, _gPass)
            };

            return client.SendMailAsync(
                new MailMessage(from: _gMail,
                                to: email,
                                subject,
                                message
                                ));
        }
    }
}
