using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using System.Threading;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using AGCS.Models;
using Newtonsoft.Json;

namespace AGCS.Controllers
{
    public class BackendController : Controller
    {

        // GET: Backend
        public ActionResult Index()
        {
            return View();
        }
        public ActionResult ABMClientes()
        {
            BD.GetClients(BD.idBusiness);
            ViewBag.Clients = BD.ListClients;
            return View();
        }
        public ActionResult CreateBill()
        {
            return View();
        }
        [HttpPost]
        public JsonResult GetProductToEnter(int id)
        {
            Product[] MyProducts;
            MyProducts = new Product[10];
            Product myProduct = new Product(0, "Manga Yakusoku No Neverland N°1", 658, 23);
            Product myProduct2 = new Product(1, "Manga Yakusoku No Neverland N°2", 658, 23);
            Product myProduct3 = new Product(2, "Manga Yakusoku No Neverland N°3", 658, 23);
            Product myProduct4 = new Product(3, "Manga Yakusoku No Neverland N°4", 658, 23);
            Product myProduct5 = new Product(4, "Manga Yakusoku No Neverland N°5", 658, 23);
            Product myProduct6 = new Product(5, "Manga Yakusoku No Neverland N°6", 658, 23);
            Product myProduct7 = new Product(6, "Manga Yakusoku No Neverland N°7", 658, 23);
            Product myProduct8 = new Product(7, "Manga Yakusoku No Neverland N°8", 658, 23);
            MyProducts[0] = myProduct;
            MyProducts[1] = myProduct2;
            MyProducts[2] = myProduct3;
            MyProducts[3] = myProduct4;
            MyProducts[4] = myProduct5;
            MyProducts[5] = myProduct6;
            MyProducts[6] = myProduct7;
            MyProducts[7] = myProduct8;
            string JsonDataClient;
            switch (id)
            {
                case 1:
                    JsonDataClient = JsonConvert.SerializeObject(myProduct);
                    break;
                case 2:
                    JsonDataClient = JsonConvert.SerializeObject(myProduct2);
                    break;
                case 3:
                    JsonDataClient = JsonConvert.SerializeObject(myProduct3);
                    break;
                case 4:
                    JsonDataClient = JsonConvert.SerializeObject(myProduct4);
                    break;
                case 5:
                    JsonDataClient = JsonConvert.SerializeObject(myProduct5);
                    break;
                case 6:
                    JsonDataClient = JsonConvert.SerializeObject(myProduct6);
                    break;
                case 7:
                    JsonDataClient = JsonConvert.SerializeObject(myProduct7);
                    break;
                case 8:
                    JsonDataClient = JsonConvert.SerializeObject(myProduct8);
                    break;
                default:
                    JsonDataClient = JsonConvert.SerializeObject(myProduct);
                    break;
            }
            return Json(JsonDataClient);
        }
        [HttpPost]
        public JsonResult GetDataClient(int pos)
        {
            BD.GetOneClient(BD.ListClients[pos].Id, BD.idBusiness);
            string JsonDataClient = JsonConvert.SerializeObject(BD.SelectedClient);
            return Json(JsonDataClient);        
        }
        [HttpPost]
        public bool UpdateClient(string Surname, string Name, int Dni, string email, int Telephone, int Cellphone, string Town, string Address, string Province, string Leter, int Number, int Floor)
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
        public bool CreateClient(string surname="" , string name="" , int dni = 0, string email = "", int telephone = 0, int cellphone = 0, string town = "", string address = "", string province = "", string leter = "", int number = 0, int floor = 0)

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
        public bool DeleteClient(int id)
        {
            bool Success = true;
            try
            {
                BD.DeleteClient(BD.ListClients[id].Id);
            }
            catch
            {
                Success = false;
            }
            return Success;
        }
        [HttpPost]
        public bool NewBill()
        {
            bool Success = false;

            return Success;
        }
        // GET: Backend/Create
        public ActionResult Pruebas()
        {
            return View();
        }
        
    }
}