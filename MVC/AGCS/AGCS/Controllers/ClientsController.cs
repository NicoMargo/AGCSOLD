using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using AGCS.Models;
using AGCS.Models.BDD;
using Newtonsoft.Json;
using Microsoft.AspNetCore.Mvc;

namespace AGCS.Controllers
{
    public class ClientsController : Controller
    {
        public IActionResult Index()
        {
            return View();
        }
        //Clients
        public ActionResult ClientsCRUD()
        {
            ViewBag.Clients = ClientsProvider.GetClients(Helpers.idBusiness);
            return View();
        }

        [HttpPost]
        public JsonResult GetDataClient(uint id)
        {
            Client client = ClientsProvider.GetClientById(id, Helpers.idBusiness);
            string JsonDataClient = JsonConvert.SerializeObject(client);
            return Json(JsonDataClient);
        }

        [HttpPost]
        public bool UpdateClient(uint id, string surname, string name, ulong dni, string email, string telephone, string cellphone, string Town, string Address, string Province, string Leter, int Number, int Floor)
            {
            bool Success = true;
            if (email is null) { email = ""; }
            Client client = new Client(id, name, surname, dni, email, cellphone, telephone);

            try
            {
                ClientsProvider.UpdateClient(client, Helpers.idBusiness);
            }
            catch
            {
                Success = false;
            }

            return Success;
        }

        [HttpPost]
        public bool CreateClient(string surname = "", string name = "", ulong dni = 0, string email = "", string telephone = "", string cellphone = "", string town = "", string address = "", string province = "", string leter = "", int number = 0, int floor = 0)

        //? public bool CreateClient(string Surname = "", string Name = "", int dni = 0, string email = "", int Telephone = 0, int Cellphone = 0, string Town = "", string Address = "", string Province = "", string Leter = "", int Number = 0, int Floor = 0)

        {
            bool Success = true;
            Client NewClient = new Client(name, surname, dni, email, telephone, cellphone);
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
                ClientsProvider.DeleteClient(id, Helpers.idBusiness);
            }
            catch
            {
                Success = false;
            }
            return Success;
        }

    }
}