﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;

namespace AGCS.Controllers
{
    public class ProductsController : BaseController
    {
        public IActionResult Index()
        {
            return View();
        }
    }
}