using System.Collections.Generic;
using Microsoft.AspNetCore.Mvc;
using AGCS.Models;
using Newtonsoft.Json;
using System;
namespace AGCS.Controllers
{
    public class BackendController : Controller
    {
        // GET: Backend
        public ActionResult Index()
        {
            return View();
        }
        public ActionResult Pruebas()
        {
            return View();
        }

        //Clients
        public ActionResult CRUDClient()
        {
            BD.GetClients();
            ViewBag.Clients = BD.ListClients;
            return View();
        }
        
        [HttpPost]
        public JsonResult GetDataClient(int pos)
        {
            BD.GetClientById(BD.ListClients[pos].Id);
            string JsonDataClient = JsonConvert.SerializeObject(BD.SelectedClient);
            return Json(JsonDataClient);        
        }
        [HttpPost]
        public JsonResult GetDataClientByDNI(uint dni)
        {
            return Json(JsonConvert.SerializeObject(BD.GetClientByDNI(dni)));
        }
        [HttpPost]
        public bool UpdateClient(string Surname, string Name, ulong Dni, string email, ulong Telephone, ulong Cellphone, string Town, string Address, string Province, string Leter, int Number, int Floor)
        {
            bool Success = true;
            if (email is null) { email = ""; }
            Client cUpdateClient = new Client(BD.SelectedClient.Id, Name, Surname,Dni,email, Cellphone, Telephone);

            try
            {
                BD.UpdateClient(cUpdateClient);
            }
            catch
            {
                Success = false;
            }

            return Success;
        }

        [HttpPost]
        public bool CreateClient(string surname="" , string name="" , ulong dni = 0, string email = "", ulong telephone = 0, ulong cellphone = 0, string town = "", string address = "", string province = "", string leter = "", int number = 0, int floor = 0)

        //? public bool CreateClient(string Surname = "", string Name = "", int dni = 0, string email = "", int Telephone = 0, int Cellphone = 0, string Town = "", string Address = "", string Province = "", string Leter = "", int Number = 0, int Floor = 0)

        {
            bool Success = true;
            Client NewClient = new Client(name, surname, dni, email, telephone, cellphone);
            try
            {
                BD.InsertClient(NewClient);
            }
            catch
            {
                Success = false;
            }
            
            return Success;
        }
        [HttpDelete]
        public bool DeleteClient(uint id)
        {
            bool Success = true;
            try
            {                
                BD.DeleteClient(BD.ListClients[Convert.ToInt32(id)].Id);
            }
            catch
            {
                Success = false;
            }
            return Success;
        }
        //Facturacion
        [HttpPost]
        public void NewBill(string json, uint dniClient)
        {
            float total = 0;
            List<Product> products = JsonConvert.DeserializeObject<List<Product>>(json);
            if (products.Count > 0)
            {
                foreach (Product product in products)
                {
                    total += product.Price * product.Quant;
                }
                Bill bill = new Bill(DateTime.Today, total, products, 0, dniClient);

                BD.InsertBill(bill);
            }
        }

        public ActionResult CreateBill()
        {
            return View();
        }

        [HttpPost]
        public JsonResult GetProductToEnter(ulong id)
        {
            Product product = BD.GetOneProduct(id);
            string JsonDataClient = JsonConvert.SerializeObject(product);
            return Json(JsonDataClient);
        }

    }
}