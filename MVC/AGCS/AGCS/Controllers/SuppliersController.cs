using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using AGCS.Models;
using AGCS.Models.BDD;
using Newtonsoft.Json;

namespace AGCS.Controllers
{
    public class SuppliersController : BaseController
    {
        public IActionResult Index()
        {
            return View();
        }

        //Suppliers
        public ActionResult SuppliersCRUD()
        {
            ViewBag.Suppliers = SuppliersProvider.GetSuppliers();
            return View();
        }

        [HttpPost]
        public bool CreateSupplier(string surname = "", string name = "", string mail = "", string telephone ="", string cellphone ="", string address = "" , string factory = "")
        {
            bool success;
            Supplier NewSupplier = new Supplier(name, surname, mail, cellphone, telephone, address,factory);
            try
            {
                success = SuppliersProvider.InsertSupplier(NewSupplier);
            }
            catch
            {
                success = false;
            }

            return success;
        }

        [HttpPost]
        public JsonResult GetDataSupplier(uint id)
        {
            Supplier client = SuppliersProvider.GetSupplierById(id);
            string JsonDataSupplier = JsonConvert.SerializeObject(client);
            return Json(JsonDataSupplier);
        }

        [HttpPost]
        public bool UpdateSupplier(uint id, string surname = "", string name = "", string mail = "", string telephone = "", string cellphone = "", string address = "", string factory = "")
        {
            bool success = true;
            Supplier client = new Supplier(id, name, surname, mail, cellphone, telephone,address,factory);
            try
            {
                SuppliersProvider.UpdateSupplier(client);
            }
            catch
            {
                success = false;
            }
            return success;
        }

        [HttpDelete]
        public bool DeleteSupplier(uint id)
        {
            bool success = true;
            try
            {
                SuppliersProvider.DeleteSupplier(id);
            }
            catch
            {
                success = false;
            }
            return success;
        }
    }
}