﻿using System;
using AGCS.Models;
using AGCS.Models.BDD;
using Newtonsoft.Json;
using Microsoft.AspNetCore.Mvc;

namespace AGCS.Controllers
{
    public class ClientsController : BaseController
    {
        public IActionResult Index()
        {
            return View();
        }
        //Clients
        public ActionResult ClientsCRUD()
        {
            ViewBag.Clients = ClientsProvider.GetClients();
            return View();
        }

        [HttpPost]
        public JsonResult GetDataClient(uint id)
        {
            Client client = ClientsProvider.GetClientById(id);
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
                ClientsProvider.UpdateClient(client);
            }
            catch
            {
                Success = false;
            }
            return Success;
        }

        [HttpPost]
        public bool CreateClient(string surname = "", string name = "", ulong dni = 0, string email = "", string telephone = "", string cellphone = "", string town = "", string address = "", string province = "", string leter = "", int number = 0, int floor = 0)
        {
            bool Success;
            Client NewClient = new Client(name, surname, dni, email, telephone, cellphone);
            try
            {
                Success = ClientsProvider.InsertClient(NewClient);
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
                ClientsProvider.DeleteClient(id);
            }
            catch
            {
                Success = false;
            }
            return Success;
        }

    }
}