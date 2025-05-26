using PlantCare.WebAPI;
//using PlantCare.API.Filters;
using PlantCare.Services;
using PlantCare.Services.Database;
using Mapster;
using MapsterMapper;
using Microsoft.AspNetCore.Authentication;
using Microsoft.EntityFrameworkCore;
using Microsoft.OpenApi.Models;

var builder = WebApplication.CreateBuilder(args);

// Add services to the container.
//ovdje se ono dodaje za builder.Services.AddTransient <,>();
builder.Services.AddControllers();
builder.Services.AddDbContext<PlantCareContext>(options =>
    options.UseSqlServer(builder.Configuration.GetConnectionString("PlantCareConnection")));


// Learn more about configuring Swagger/OpenAPI at https://aka.ms/aspnetcore/swashbuckle
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();

var mapsterConfig = TypeAdapterConfig.GlobalSettings
    .Scan(typeof(Program).Assembly);

builder.Services
    .AddSingleton(mapsterConfig)
    .AddScoped<IMapper, ServiceMapper>();

builder.Services.AddScoped<IKorisnikService, KorisnikService>();
builder.Services.AddScoped<IUlogaService, UlogaService>();
builder.Services.AddScoped<IKategorijaService, KategorijaService>();
builder.Services.AddScoped<ISubkategorijaService, SubkategorijaService>();
builder.Services.AddScoped<IObavijestService, ObavijestService>();
builder.Services.AddScoped<IUplataService, UplataService>();
builder.Services.AddScoped<IReportService, ReportService>();
builder.Services.AddScoped<IPostService, PostService>();
builder.Services.AddScoped<IOmiljeniPostService, OmiljeniPostService>();
builder.Services.AddScoped<INotifikacijaService, NotifikacijaService>();
builder.Services.AddScoped<ILajkService, LajkService>();
builder.Services.AddScoped<IKomentarService, KomentarService>();
builder.Services.AddScoped<IKatalogPostService, KatalogPostService>();
builder.Services.AddScoped<IKatalogService, KatalogService>();




var app = builder.Build();

// Configure the HTTP request pipeline.
if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI();
}

app.UseHttpsRedirection();

app.UseAuthorization();

app.MapControllers();

app.Run();
