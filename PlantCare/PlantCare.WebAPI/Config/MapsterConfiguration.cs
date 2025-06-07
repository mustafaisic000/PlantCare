using Mapster;
using PlantCare.Model;
using PlantCare.Model.DTO;
using PlantCare.Services.Database;

namespace PlantCare.WebAPI.Mapping
{
    public static class MapsterConfiguration
    {
        public static void RegisterMappings()
        {
            // Global fallback transformations
            TypeAdapterConfig.GlobalSettings.Default
                .AddDestinationTransform((string? src) => src ?? "Unknown")
                .AddDestinationTransform((byte[]? src) => src ?? Array.Empty<byte>())
                .AddDestinationTransform((bool src) => src);

            TypeAdapterConfig<Services.Database.Komentar, Model.Komentar>
                .NewConfig()
                .Map(dest => dest.KorisnickoIme, src => src.Korisnik.KorisnickoIme)
                .Map(dest => dest.PostNaslov, src => src.Post.Naslov);

            TypeAdapterConfig<Services.Database.Lajk, Model.Lajk>
                .NewConfig()
                .Map(dest => dest.KorisnickoIme, src => src.Korisnik.KorisnickoIme)
                .Map(dest => dest.PostNaslov, src => src.Post.Naslov);

            TypeAdapterConfig<Services.Database.Notifikacija, Model.Notifikacija>
                .NewConfig()
                .Map(dest => dest.KorisnickoIme, src => src.Korisnik.KorisnickoIme)
                .Map(dest => dest.PostNaslov, src => src.Post != null ? src.Post.Naslov : "Unknown");

            TypeAdapterConfig<Services.Database.Report, Model.Report>
                .NewConfig()
                .Map(dest => dest.KorisnickoIme, src => src.Korisnik.KorisnickoIme)
                .Map(dest => dest.PostNaslov, src => src.Post.Naslov);

            TypeAdapterConfig<Services.Database.Katalog, Model.Katalog>
                .NewConfig()
                .Map(dest => dest.KorisnickoIme, src => src.Korisnik.KorisnickoIme)
                .Map(dest => dest.KatalogPostovi, src => src.KatalogPostovi);

            TypeAdapterConfig<Services.Database.Uplata, Model.Uplata>
             .NewConfig()
             .Map(dest => dest.KorisnickoIme, src => src.Korisnik.KorisnickoIme);

            TypeAdapterConfig<Services.Database.Obavijest, Model.Obavijest>
             .NewConfig()
             .Map(dest => dest.KorisnickoIme, src => src.Korisnik.KorisnickoIme);

            TypeAdapterConfig<Services.Database.Post, Model.Post>
             .NewConfig()
             .Map(dest => dest.KorisnickoIme, src => src.Korisnik.KorisnickoIme);

            TypeAdapterConfig<Services.Database.Kategorija, Model.Kategorija>
             .NewConfig()
             .Map(dest => dest.Subkategorije, src => src.Subkategorije.Select(sk => sk.Adapt<SubkategorijaBasic>()).ToList());
        }
    }
}
