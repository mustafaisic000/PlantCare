﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using PlantCare.Model.SearchObjects;

namespace PlantCare.Services;

public interface ICRUDService<TModel,TSearch,TInsert,TUpdate>: IService<TModel,TSearch> where TModel : class where TSearch:BaseSearchObject
{
    TModel Insert (TInsert request);
    TModel Update (int id, TUpdate request);

}
