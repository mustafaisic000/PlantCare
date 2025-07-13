using PlantCare.Model;
using PlantCare.Model.Requests;
using PlantCare.Model.SearchObjects;
using PlantCare.Services;
using PlantCare.Services.Database;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

public interface IKategorijaTransakcije25062025Service
    : ICRUDService<
         PlantCare.Model.KategorijaTransakcije25062025,
         KategorijaTransakcije25062025SearchObject,
         KategorijaTransakcije25062025UpsertRequest,
         KategorijaTransakcije25062025UpsertRequest>
{
}
