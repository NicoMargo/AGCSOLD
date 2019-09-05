using System.Collections.Generic;
using Microsoft.AspNetCore.Mvc;
using AGCS.Models;
using AGCS.Models.BDD;
using Newtonsoft.Json;
using System;
using Microsoft.AspNetCore.Http;

namespace AGCS.Controllers
{
    public class UsersController : BaseController
    {
        
        public ActionResult UsersCRUD()
        {
            ViewBag.Users = UsersProvider.GetUsers();
            return View();
        }
        [HttpDelete]
        public bool DeleteUser(uint id)
        {
            bool Success = false;
            try
            {
                UsersProvider.DeleteUser(id);
                Success = true;
            }
            catch (Exception)
            {

            }
            return Success;

        }
        [HttpPost]
        public bool CreateUser(string surname = "", string name = "", ulong dni = 0, string email = "", string telephone = "",string passUser = "",string cPassUser = "", string cellphone = "", string town = "", string address = "", string province = "", string leter = "", int number = 0, int floor = 0)
        {
            bool Success = false;
            if (passUser == cPassUser)
            {                
                User NewUser = new User(name, surname, dni, email, cellphone, passUser, telephone);
                try
                {
                    Success = UsersProvider.InsertUser(NewUser);
                }
                catch
                {
                    Success = false;
                }
            }
            return Success;
        }
        [HttpPost]
        public JsonResult GetDataUser(uint id)
        {            
            string JsonDataClient = JsonConvert.SerializeObject(UsersProvider.GetUserById(id));
            return Json(JsonDataClient);
        }
        [HttpPost]
        public bool UpdateUser(uint id,string Surname, string Name, ulong Dni, string email, string Telephone, string Cellphone, string Town, string Address, string Province, string Leter, int Number, int Floor)
        {
            bool Success = true;
            if (email is null) { email = ""; }
            User cUser = new User(id, Name, Surname, Dni, email, Cellphone, Telephone);
            try
            {
                UsersProvider.UpdateUser(cUser);
            }
            catch
            {
                Success = false;
            }

            return Success;
        }

    }
}