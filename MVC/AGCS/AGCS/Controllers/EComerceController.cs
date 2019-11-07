﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using AGCS.Models;
using AGCS.Models.BDD;
using Newtonsoft.Json;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Cors;

namespace AGCS.Controllers
{
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