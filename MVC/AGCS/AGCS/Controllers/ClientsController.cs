using System;
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
            ClientsProvider.GetClients(Session.GetSUInt32("idBusiness"));
            ViewBag.Clients = ClientsProvider.ClientsList;
            return View();
        }

        [HttpPost]
        public JsonResult GetDataClient(int pos)
        {
            ClientsProvider.GetClientById(ClientsProvider.ClientsList[pos].Id, Session.GetSUInt32("idBusiness"));
            string JsonDataClient = JsonConvert.SerializeObject(ClientsProvider.SelectedClient);
            return Json(JsonDataClient);
        }
        [HttpPost]
        public JsonResult GetDataClientByDNI(uint dni)
        {
            return Json(JsonConvert.SerializeObject(ClientsProvider.GetClientByDNI(dni, Session.GetSUInt32("idBusiness"))));
        }
        [HttpPost]
        public bool UpdateClient(string Surname, string Name, ulong Dni, string email, string Telephone, string Cellphone, string Town, string Address, string Province, string Leter, int Number, int Floor)
        {
            bool Success = true;
            if (email is null) { email = ""; }
            Client cUpdateClient = new Client(ClientsProvider.SelectedClient.Id, Name, Surname, Dni, email, Cellphone, Telephone);

            try
            {
                ClientsProvider.UpdateClient(cUpdateClient, Session.GetSUInt32("idBusiness"));
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
            bool Success;
            Client NewClient = new Client(name, surname, dni, email, telephone, cellphone);
            try
            {
                Success = ClientsProvider.InsertClient(NewClient, Session.GetSUInt32("idBusiness"));
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
                ClientsProvider.DeleteClient(ClientsProvider.ClientsList[Convert.ToInt32(id)].Id, Session.GetSUInt32("idBusiness"));
            }
            catch
            {
                Success = false;
            }
            return Success;
        }

    }
}