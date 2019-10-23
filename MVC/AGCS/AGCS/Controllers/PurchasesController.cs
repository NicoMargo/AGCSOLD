using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using AGCS.Models.BDD;
using AGCS.Models;


namespace AGCS.Controllers
{
    public class PurchasesController : Controller
    {
        public IActionResult Index()
        {
            return View();
        }

        public IActionResult SelectSupplier() {
            ViewBag.Suppliers = SuppliersProvider.GetSuppliers();
            return View();
        }
    }
}