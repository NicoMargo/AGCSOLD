using System.Collections.Generic;
using AGCS.Models;
using AGCS.Models.BDD;
using Microsoft.AspNetCore.Mvc;

namespace AGCS.Controllers
{
    //Area experimental en Desarrollo, No funciona por ahora

    [Route("api/[controller]")]
    [ApiController]
    public class EComerceController : Controller
    {

        // GET: api/EComerce/5
        [Route("GetProducts/{idBusiness}")]
        [HttpGet("{idBusiness}", Name = "ProductsGet")]
        public IEnumerable<Product> ProductsGet(uint idBusiness)
        {
            Product[] products = ProductsProvider.GetProducts(idBusiness).ToArray();
            return products;
        }
       
    }
}
