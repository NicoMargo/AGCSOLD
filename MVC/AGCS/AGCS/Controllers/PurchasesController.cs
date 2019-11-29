using System.Collections.Generic;
using Microsoft.AspNetCore.Mvc;
using AGCS.Models.BDD;
using AGCS.Models;
using Newtonsoft.Json;

namespace AGCS.Controllers
{
    public class PurchasesController : BaseController
    {
        public ActionResult CreatePurchase()
        {
            ViewBag.Suppliers = SuppliersProvider.GetSuppliers();            
            return View();
        }
        [HttpPost]
        public JsonResult GetProduct(uint code)
        {
            Product product = ProductsProvider.GetProductByCode(code);
            string JsonDataProduct = JsonConvert.SerializeObject(product);
            return Json(JsonDataProduct);
        }
        [HttpPost]
        public bool NewPurchase(string json, ulong sdi, string condition = "", string notes = "")
        {

            List<Product> products = JsonConvert.DeserializeObject<List<Product>>(json);
            bool success = false;
            if (products.Count > 0)
            {
                Purchase purchase = new Purchase(Session.GetSUInt32("idUser"), sdi, products, condition, notes);

                success = PurchasesProvider.InsertPurchase(purchase);
            }
            return success;
        }

    }
}