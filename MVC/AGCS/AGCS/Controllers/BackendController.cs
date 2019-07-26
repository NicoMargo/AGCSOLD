using System.Collections.Generic;
using Microsoft.AspNetCore.Mvc;
using AGCS.Models;
using AGCS.Models.BDD;

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
        public ActionResult ClientsCRUD()
        {
            ClientsProvider.GetClients(Helpers.idBusiness);
            ViewBag.Clients = ClientsProvider.ClientsList;
            return View();
        }
        
        [HttpPost]
        public JsonResult GetDataClient(int pos)
        {
            ClientsProvider.GetClientById(ClientsProvider.ClientsList[pos].Id,Helpers.idBusiness);
            string JsonDataClient = JsonConvert.SerializeObject(ClientsProvider.SelectedClient);
            return Json(JsonDataClient);        
        }
        [HttpPost]
        public JsonResult GetDataClientByDNI(uint dni)
        {
            return Json(JsonConvert.SerializeObject(ClientsProvider.GetClientByDNI(dni,Helpers.idBusiness)));
        }
        [HttpPost]
        public bool UpdateClient(string Surname, string Name, ulong Dni, string email, string Telephone, string Cellphone, string Town, string Address, string Province, string Leter, int Number, int Floor)
        {
            bool Success = true;
            if (email is null) { email = ""; }
            Client cUpdateClient = new Client(ClientsProvider.SelectedClient.Id, Name, Surname,Dni,email, Cellphone, Telephone);

            try
            {
                ClientsProvider.UpdateClient(cUpdateClient, Helpers.idBusiness);
            }
            catch
            {
                Success = false;
            }

            return Success;
        }

        [HttpPost]
        public bool CreateClient(string surname="" , string name="" , ulong dni = 0, string email = "", string telephone = "", string cellphone = "", string town = "", string address = "", string province = "", string leter = "", int number = 0, int floor = 0)

        //? public bool CreateClient(string Surname = "", string Name = "", int dni = 0, string email = "", int Telephone = 0, int Cellphone = 0, string Town = "", string Address = "", string Province = "", string Leter = "", int Number = 0, int Floor = 0)

        {
            bool Success = true;
            Client NewClient = new Client(name, surname, dni, email,telephone,cellphone);
            try
            {
                ClientsProvider.InsertClient(NewClient, Helpers.idBusiness);
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
                ClientsProvider.DeleteClient(ClientsProvider.ClientsList[Convert.ToInt32(id)].Id, Helpers.idBusiness);
            }
            catch
            {
                Success = false;
            }
            return Success;
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
                
                success = BillsProvider.InsertBill(bill, ClientBill, Helpers.idBusiness);
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
            Product product = ProductsProvider.GetOneProduct(code, Helpers.idBusiness);
            string JsonDataClient = JsonConvert.SerializeObject(product);
            return Json(JsonDataClient);
        }

        
        public ActionResult ProductsCRUD()
        {
            ClientsProvider.GetClients(Helpers.idBusiness);
            ViewBag.Clients = ClientsProvider.ClientsList;
            return View();
        }

    }
}