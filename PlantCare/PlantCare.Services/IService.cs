using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using PlantCare.Model;

namespace PlantCare.Services;

public interface IService<TModel, TSearch> where TSearch : class
{
    public PagedResult<TModel> GetPaged (TSearch search);
    public TModel GetById(int id);
}
