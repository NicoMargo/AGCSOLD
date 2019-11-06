using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using AGCS.Models.BDD;
using Microsoft.AspNetCore.Mvc;

// For more information on enabling MVC for empty projects, visit https://go.microsoft.com/fwlink/?LinkID=397860

namespace AGCS.Controllers
{
    public class Ecommerce : Controller
    {
        // GET: /<controller>/
        public ActionResult index()
        {
            ViewBag.Products = ProductsProvider.GetProducts();
            return View();
        }
    }
}
