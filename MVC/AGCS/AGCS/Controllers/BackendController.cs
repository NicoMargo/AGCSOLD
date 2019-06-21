﻿using System;
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
            ViewBag.Clients = BD.ListOfClients;
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
            MyProducts = new Product[4];
            Product myProduct = new Product (0, "Manga Yakusoku No Neverland N°1",658,23);
            Product myProduct2 = new Product(1, "Manga Yakusoku No Neverland N°2", 658, 23);
            Product myProduct3 = new Product(2, "Manga Yakusoku No Neverland N°3", 658, 23);
            Product myProduct4 = new Product(3, "Manga Yakusoku No Neverland N°4", 658, 23);
            MyProducts[0] = myProduct;
            MyProducts[1] = myProduct2;
            MyProducts[2] = myProduct3;
            MyProducts[3] = myProduct4;
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
                default:
                    JsonDataClient = JsonConvert.SerializeObject(myProduct);
                    break;
            }
           
            return Json(JsonDataClient);
        } 
        [HttpPost]
        public JsonResult GetDataClient(int pos)
        {
            BD.GetOneClient(BD.ListOfClients[pos].Id, BD.idBusiness);
            string JsonDataClient = JsonConvert.SerializeObject(BD.OneClient);
            return Json(JsonDataClient);            
        }
        [HttpPost]
        public bool UpdateClient(string Surname, string Name, int dni, string email, int Telephone, int Cellphone, string Town, string Address, string Province, string Leter, int Number, int Floor)
        {
            bool Success = true;
            Client cUpdateClient = new Client(BD.OneClient.Id, Name, Surname,dni,email,Telephone,Cellphone);
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
        public bool CreateClient(string Surname="" , string Name="" , int dni = 0, string email = "", int Telephone = 0, int Cellphone = 0, string Town = "", string Address = "", string Province = "", string Leter = "", int Number = 0, int Floor = 0)
        {
            bool Success = true;
            Client NewClient = new Client(Name, Surname, dni, email, Telephone, Cellphone, Town, Address, Province, Leter, Number, Floor);
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
                BD.DeleteClient(BD.ListOfClients[id].Id);
            }
            catch
            {
                Success = false;
            }
            return Success;
        }

        // GET: Backend/Create
        public ActionResult Pruebas()
        {
            return View();
        }
        
    }
}