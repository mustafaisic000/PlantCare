using MapsterMapper;
using Microsoft.EntityFrameworkCore;
using PlantCare.Model;
using PlantCare.Model.Requests;
using PlantCare.Model.SearchObjects;
using PlantCare.Services.Database;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PlantCare.Services
{
    public class Transakcija25062025Service : BaseCRUDService<
        Model.Transakcija25062025,
        Transakcija25062025SearchObject,
        Database.Transakcija25062025,
        Transakcija25062025UpsertRequest,
        Transakcija25062025UpsertRequest>,
        ITransakcija25062025Service
    {
        public Transakcija25062025Service(PlantCareContext context, IMapper mapper) : base(context, mapper)
        {
        }

        protected override IQueryable<Database.Transakcija25062025> AddFilter(
       Transakcija25062025SearchObject search,
       IQueryable<Database.Transakcija25062025> query)
        {
            query = base.AddFilter(search, query);

            query = query
                 .Include(x => x.Korisnik)
                 .Include(x => x.KategorijaTransakcije25062025);

            if (search.KategorijaTransakcije25062025Id.HasValue)
                query = query.Where(x => x.KategorijaTransakcije25062025Id == search.KategorijaTransakcije25062025Id.Value);

            if (search.DatumTransakcijeOD.HasValue)
                query = query.Where(x => x.DatumTransakcije.Date >= search.DatumTransakcijeOD.Value.Date);

            if (search.DatumTransakcijeDO.HasValue)
                query = query.Where(x => x.DatumTransakcije.Date <= search.DatumTransakcijeDO.Value.Date);

            return query;
        }

        protected override void BeforeInsert(Transakcija25062025UpsertRequest request, Database.Transakcija25062025 entity)
        {
            var limit= Context.Limiti25062025.FirstOrDefault(x => x.KorisnikId == request.KorisnikId && x.KategorijaTransakcije25062025Id==request.KategorijaTransakcije25062025Id);

          if (limit != null)
            {
                var start=new DateTime(DateTime.Now.Year, DateTime.Now.Month, 1);
                var end = start.AddMonths(1).AddDays(-1);

                var popunjenost=Context.Transakcije25062025.Where(
                    x=>x.KorisnikId==request.KorisnikId &&
                    x.KategorijaTransakcije25062025Id==request.KategorijaTransakcije25062025Id &&
                    x.DatumTransakcije.Date>=start.Date &&
                    x.DatumTransakcije.Date<=end.Date).Sum(x=>x.Iznos);
                var noviTotal=popunjenost+request.Iznos;
                if(noviTotal>limit.Limit)
                    {
                    throw new Exception("Transakcija prekoračuje limit za ovu kategoriju u ovom mjesecu.");
                }

             }
          base.BeforeInsert(request, entity);
        }
        public async Task<List<StatKategorije>> GetStat(int? Transakcija25062025Id)
        {
            if(Transakcija25062025Id == null)
            {
               var query= await Context.Transakcije25062025.GroupBy(x=>x.KategorijaTransakcije25062025.NazivKategorije)
                .Select(g => new StatKategorije
                {
                    GetNaziv = g.Key,
                    Iznos=g.Sum(x => x.Iznos)
                }).ToListAsync();
                return query;

            }
            else
            {
                var query = await Context.Transakcije25062025.Where(x=>x.Transakcija25062025Id== Transakcija25062025Id).
                    GroupBy(x=>x.KategorijaTransakcije25062025.NazivKategorije).
                    Select(x=> new StatKategorije
                    {
                        GetNaziv=x.Key,
                        Iznos=x.Sum(y=>y.Iznos)
                    }).ToListAsync();
                return query;
            }
        }
    }
}
