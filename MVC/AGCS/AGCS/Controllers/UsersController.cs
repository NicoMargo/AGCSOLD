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
        public string CreateUser(string surname = "",string secondName = "", string name = "", string dni = "", string email = "", string telephone = "",string passUser = "",string cPassUser = "", string cellphone = "", string telephoneM = "", string address = "", string telephoneF = "", string telephoneB = "")
        {
            string Msg = "";
            if (passUser == cPassUser)
            {                
                User NewUser = new User(name, surname,secondName, Convert.ToUInt64(dni), email, cellphone, passUser, telephone, telephoneM, telephoneF, telephoneB,address);
               
                    Msg =UsersProvider.InsertUser(NewUser);
                
            }
            else
            {
                Msg = "las contraseñas no coinciden";
            }
            if (Msg == "False")
                Msg = "Ya existe un usuario con ese email o Dni";
            return Msg;
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