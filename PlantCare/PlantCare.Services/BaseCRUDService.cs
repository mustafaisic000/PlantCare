using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using MapsterMapper;
using PlantCare.Model.SearchObjects;
using PlantCare.Services.Database;

namespace PlantCare.Services
{
    public abstract class BaseCRUDService<TModel,TSearch,TDbEntity, TInsert, TUpdate>: BaseService<TModel,TSearch,TDbEntity> where TModel : class where TDbEntity : class where TSearch: BaseSearchObject
    {
        public BaseCRUDService(PlantCareContext context, IMapper mapper) : base(context, mapper) { }

        public virtual TModel Insert(TInsert request)
        {
            TDbEntity entity = Mapper.Map<TDbEntity>(request); 

            BeforeInsert(request, entity);

            Context.Add(entity);
            Context.SaveChanges();

            return Mapper.Map<TModel>(entity);
        }

        protected virtual void BeforeInsert(TInsert request, TDbEntity entity) //before insert gdje cu override password da se generise hash i salt
        {
           
        }

        public virtual TModel Update(int id, TUpdate request)
        {
           var set = Context.Set<TDbEntity>();

            var entity = Context.Set<TDbEntity>().Find(id);

            Mapper.Map(request, entity);

           BeforeUpdate(request, entity);

            Context.SaveChanges();

            return Mapper.Map<TModel>(entity);
        }

        public virtual void BeforeUpdate(TUpdate? request, TDbEntity? entity)
        {
           
        }
    }
}
