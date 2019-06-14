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
            ViewBag.Clients = BD.ListOfClients;
            return View();
        }
        
        [HttpPost]
        public JsonResult GetDataClient(int pos)
        {
            BD.GetOneClient(BD.ListOfClients[pos].Id, BD.idBusiness);
            string JsonDataClient = JsonConvert.SerializeObject(BD.SelectedClient);
            return Json(JsonDataClient);            
        }
        [HttpPost]
        public bool UpdateClient(string Surname, string Name, int Dni, string email, int Telephone, int Cellphone, string Town, string Address, string Province, string Leter, int Number, int Floor)
        {
            bool Success = true;
            Client cUpdateClient = new Client(BD.SelectedClient.Id, Name, Surname,Dni,email,Telephone,Cellphone);
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
        {
            bool Success = true;
            Client NewClient = new Client(name, surname, dni, email, telephone, cellphone);
            //try
            //{
                BD.InsertClient(NewClient);/*
            }
            catch
            {
                 Success = false;
            }
            */
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