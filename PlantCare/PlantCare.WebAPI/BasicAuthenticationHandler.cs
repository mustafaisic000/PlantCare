using Microsoft.AspNetCore.Authentication;
using Microsoft.Extensions.Options;
using PlantCare.Services;
using System.Net.Http.Headers;
using System.Security.Claims;
using System.Text.Encodings.Web;
using System.Text;

namespace PlantCare.WebAPI
{
    public class BasicAuthenticationHandler : AuthenticationHandler<AuthenticationSchemeOptions>
    {
        private readonly IKorisnikService _korisnikService;
        private readonly ILogger<BasicAuthenticationHandler> _logger;

        public BasicAuthenticationHandler(
    IOptionsMonitor<AuthenticationSchemeOptions> options,
    ILoggerFactory loggerFactory,
    UrlEncoder encoder,
    ISystemClock clock,
    IKorisnikService korisnikService)
    : base(options, loggerFactory, encoder, clock)
        {
            _korisnikService = korisnikService;
            _logger = loggerFactory.CreateLogger<BasicAuthenticationHandler>();
        }


        protected override async Task<AuthenticateResult> HandleAuthenticateAsync()
        {
            _logger.LogInformation("Starting Basic Authentication...");

            if (!Request.Headers.ContainsKey("Authorization"))
            {
                _logger.LogWarning("Missing Authorization header.");
                return AuthenticateResult.Fail("Missing Authorization header");
            }

            PlantCare.Model.Korisnik user = null;

            try
            {
                var authHeader = AuthenticationHeaderValue.Parse(Request.Headers["Authorization"]);
                _logger.LogInformation("Raw Authorization header: {Header}", authHeader.Parameter);

                var credentialBytes = Convert.FromBase64String(authHeader.Parameter);
                var credentials = Encoding.UTF8.GetString(credentialBytes).Split(new[] { ':' }, 2);

                if (credentials.Length != 2)
                {
                    _logger.LogWarning("Invalid Authorization header format.");
                    return AuthenticateResult.Fail("Invalid credential format");
                }

                var username = credentials[0];
                var password = credentials[1];

                _logger.LogInformation("Decoded username: {Username}", username);

                user = _korisnikService.Login(username, password);

                if (user == null)
                {
                    _logger.LogWarning("Login failed for user: {Username}", username);
                    return AuthenticateResult.Fail("Invalid Username or Password");
                }

                _logger.LogInformation("Login successful for user: {Username}", username);
                
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Exception occurred during authentication.");
                return AuthenticateResult.Fail("Invalid Authorization Header");
            }

            var claims = new[]
            {
                new Claim(ClaimTypes.NameIdentifier, user.KorisnickoIme),
                new Claim(ClaimTypes.Name, user.Ime),
                new Claim(ClaimTypes.Role, user.UlogaNaziv),
            };
            _logger.LogInformation("Login successful for user: {Username}", user.UlogaNaziv);

            var identity = new ClaimsIdentity(claims, Scheme.Name);
            var principal = new ClaimsPrincipal(identity);
            var ticket = new AuthenticationTicket(principal, Scheme.Name);

            return AuthenticateResult.Success(ticket);
        }
    }
}
