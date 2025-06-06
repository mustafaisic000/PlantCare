﻿using MapsterMapper;
using Microsoft.EntityFrameworkCore;
using PlantCare.Model;
using PlantCare.Model.Requests;
using PlantCare.Model.SearchObjects;
using PlantCare.Services.Database;
using System.Linq;

namespace PlantCare.Services;

public class KomentarService
    : BaseCRUDService<
        Model.Komentar,
        KomentarSearchObject,
        Database.Komentar,
        KomentarInsertRequest,
        KomentarUpdateRequest>,
      IKomentarService
{
    public KomentarService(PlantCareContext ctx, IMapper mapper)
        : base(ctx, mapper)
    {
    }

    protected override IQueryable<Database.Komentar> AddFilter(
        KomentarSearchObject search,
        IQueryable<Database.Komentar> query)
    {
        query = base.AddFilter(search, query);

        if (search.PostId.HasValue)
            query = query.Where(x => x.PostId == search.PostId.Value);

        if (search.KorisnikId.HasValue)
            query = query.Where(x => x.KorisnikId == search.KorisnikId.Value);

        if (search.DatumOd.HasValue)
            query = query.Where(x => x.DatumKreiranja >= search.DatumOd.Value);

        if (search.DatumDo.HasValue)
            query = query.Where(x => x.DatumKreiranja <= search.DatumDo.Value);

        return query;
    }
}
