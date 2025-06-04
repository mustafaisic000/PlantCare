using PlantCare.WebAPI;
// using PlantCare.WebAPI.Filters;   // Uncomment if you add filters
using PlantCare.Services;
using PlantCare.Services.Database;
using Mapster;
using MapsterMapper;
using Microsoft.EntityFrameworkCore;
using Microsoft.OpenApi.Models;

var builder = WebApplication.CreateBuilder(args);

// ── 1) Register your application services as transient ────────────────────────
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

// Optional helper to access HttpContext in services
builder.Services.AddHttpContextAccessor();

// ── 2) Add controllers (and optional filters) ─────────────────────────────────
builder.Services.AddControllers(/*opts => opts.Filters.Add<ExceptionFilter>()*/);

// ── 3) Swagger / OpenAPI setup ────────────────────────────────────────────────
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen(c =>
{
    c.SwaggerDoc("v1", new OpenApiInfo { Title = "PlantCare API", Version = "v1" });
    // … any security definitions …
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
app.UseAuthorization();
app.MapControllers();
using (var scope = app.Services.CreateScope())
{
    var dbContext = scope.ServiceProvider.GetRequiredService<PlantCareContext>();
    dbContext.Database.Migrate(); // Apply any pending migrations
}
app.Run();
