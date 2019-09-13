using System.Collections.Generic;
using Microsoft.AspNetCore.Mvc;
using AGCS.Models;
using AGCS.Models.BDD;
using Newtonsoft.Json;
using System;
using Microsoft.AspNetCore.Http;

namespace AGCS.Controllers
{
    public class BackendController : BaseController
    {

        public ActionResult Index()
        {       
            return View();
        }
        public ActionResult Pruebas()
        {
            return View();
        }

        //Facturacion
        [HttpPost]
        public bool NewBill(string json, uint dniClient, string jsonClient, float recharge, float discount)
        {
            bool success = false;
            Client ClientBill = new Client();
            try
            {
                ClientBill = JsonConvert.DeserializeObject<Client>(jsonClient);
            }
            catch (Exception)
            {
                ClientBill.Dni = dniClient;
            }

            List<Product> products = JsonConvert.DeserializeObject<List<Product>>(json);
            if (products.Count > 0)
            {
                Bill bill = new Bill(DateTime.Today, products, recharge , discount, dniClient);
                
                success = BillsProvider.InsertBill(bill, ClientBill, Session.GetSUInt32("idBusiness"));
            }
            return success;
        }

        public ActionResult CreateBill()
        {
            return View();
        }

        [HttpPost]
        public JsonResult GetProductToEnter(ulong code)
        {
            Product product = ProductsProvider.GetProductByCode(code);
            string JsonDataClient = JsonConvert.SerializeObject(product);
            return Json(JsonDataClient);
        }
        
        public ActionResult Configuration()
        {

            return View();
        }
    }
}