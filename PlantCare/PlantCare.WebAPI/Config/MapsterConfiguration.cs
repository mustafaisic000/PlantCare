using Mapster;
using PlantCare.Model;
using PlantCare.Services.Database;

namespace PlantCare.WebAPI.Mapping
{
    public static class MapsterConfiguration
    {
        public static void RegisterMappings()
        {
            // Global default transformations
            TypeAdapterConfig.GlobalSettings.Default
                .AddDestinationTransform((string src) => src ?? "Unknown")
                .AddDestinationTransform((byte[] src) => src ?? Array.Empty<byte>())
                .AddDestinationTransform((bool src) => src);

            // Specific mappings
            TypeAdapterConfig<Services.Database.Korisnik, Model.Korisnik>
                .NewConfig()
                .Map(dest => dest.Email, src => src.Email ?? "No Email"); // Only override Email

            TypeAdapterConfig<Services.Database.Post, Model.Post>
                .NewConfig();

            TypeAdapterConfig<Services.Database.Komentar, Model.Komentar>
                .NewConfig()
                .Map(dest => dest.KorisnickoIme, src => src.Korisnik != null ? src.Korisnik.KorisnickoIme : "Anonymous")
                .Map(dest => dest.PostNaslov, src => src.Post != null ? src.Post.Naslov : "Untitled Post");

            TypeAdapterConfig<Services.Database.KatalogPost, Model.KatalogPost>
                .NewConfig();
        }
    }
}
