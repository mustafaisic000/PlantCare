using PlantCare.WebAPI;
using PlantCare.Services;
using PlantCare.Services.Database;
using Mapster;
using MapsterMapper;
using Microsoft.EntityFrameworkCore;
using Microsoft.OpenApi.Models;
using PlantCare.WebAPI.Filters;
using Microsoft.AspNetCore.Authentication;
using PlantCare.Services.SignalR;

var builder = WebApplication.CreateBuilder(args);

builder.Logging.ClearProviders();        
builder.Logging.AddConsole();          


builder.Services.AddTransient<IKorisnikService, KorisnikService>();
builder.Services.AddTransient<IUlogaService, UlogaService>();
builder.Services.AddTransient<IKategorijaService, KategorijaService>();
builder.Services.AddTransient<ISubkategorijaService, SubkategorijaService>();
builder.Services.AddTransient<IObavijestService, ObavijestService>();
builder.Services.AddTransient<IUplataService, UplataService>();
builder.Services.AddTransient<IReportService, ReportService>();
builder.Services.AddTransient<IPostService, PostService>();
builder.Services.AddTransient<IOmiljeniPostService, OmiljeniPostService>();
builder.Services.AddTransient<INotifikacijaService, NotifikacijaService>();
builder.Services.AddTransient<ILajkService, LajkService>();
builder.Services.AddTransient<IKomentarService, KomentarService>();
builder.Services.AddTransient<IKatalogPostService, KatalogPostService>();
builder.Services.AddTransient<IKatalogService, KatalogService>();
builder.Services.AddTransient<IKategorijaTransakcije25062025Service, KategorijaTransakcije25062025Service>();
builder.Services.AddTransient<ITransakcija25062025Service, Transakcija25062025Service>();
builder.Services.AddTransient<ITransakcijeLog25062025Service, TransakcijeLog25062025Service>();
builder.Services.AddTransient<IFinansijskiLimit25062025Service, FinansijskiLimit25062025Service>();

builder.Services.AddTransient<IEmailService, EmailService>();


builder.Services.AddSignalR();


builder.Services.AddScoped<INotifikacijskiServis, NotifikacijskiServis>();
// Optional helper to access HttpContext in services
builder.Services.AddHttpContextAccessor();

// ── 2) Add controllers (and optional filters) ─────────────────────────────────
builder.Services.AddControllers(opts => opts.Filters.Add<ExceptionFilter>());

// ── 3) Swagger / OpenAPI setup ────────────────────────────────────────────────
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen(c =>
{
    c.AddSecurityDefinition("basicAuth", new Microsoft.OpenApi.Models.OpenApiSecurityScheme()
    {
        Type = Microsoft.OpenApi.Models.SecuritySchemeType.Http,
        Scheme = "basic"
    });

    c.AddSecurityRequirement(new Microsoft.OpenApi.Models.OpenApiSecurityRequirement()
    {
        {
            new OpenApiSecurityScheme
            {
                Reference = new OpenApiReference{Type = ReferenceType.SecurityScheme, Id = "basicAuth"}
            },
            new string[]{}
    } });

});


// ── 4) Configure EF Core DbContext ────────────────────────────────────────────
builder.Services.AddDbContext<PlantCareContext>(opts =>
    opts.UseSqlServer(builder.Configuration.GetConnectionString("DefaultConnection")));

// ── 5) Manual Mapster setup ───────────────────────────────────────────────────
// 5a) configure and scan for mappings
var mapsterConfig = TypeAdapterConfig.GlobalSettings;

// Register your centralized mapping rules
PlantCare.WebAPI.Mapping.MapsterConfiguration.RegisterMappings();

// Register Mapster with DI
builder.Services
    .AddSingleton(mapsterConfig)
    .AddScoped<IMapper, ServiceMapper>();

builder.Services.AddAuthentication("BasicAuthentication")
    .AddScheme<AuthenticationSchemeOptions, BasicAuthenticationHandler>("BasicAuthentication", null);

// ── 6) Build & run ────────────────────────────────────────────────────────────
var app = builder.Build();

if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI(c =>
    {
        c.SwaggerEndpoint("/swagger/v1/swagger.json", "PlantCare API v1");
    });
}
app.UseHttpsRedirection();
app.UseAuthentication();
app.UseAuthorization();
app.MapControllers();

app.MapHub<NotifikacijaHub>("/signalrHub");

/*
using (var scope = app.Services.CreateScope())
{
    var dbContext = scope.ServiceProvider.GetRequiredService<PlantCareContext>();
    dbContext.Database.Migrate(); // Apply any pending migrations
}
*/
app.Run();
