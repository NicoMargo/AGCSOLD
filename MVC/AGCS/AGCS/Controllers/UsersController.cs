using Microsoft.AspNetCore.Mvc;
using AGCS.Models;
using AGCS.Models.BDD;
using Newtonsoft.Json;
using System;

namespace AGCS.Controllers
{
    public class UsersController : BaseController
    {
        public ActionResult Configuration()
        {
            return View();
        }
        public ActionResult UsersCRUD()
        {
            if (Convert.ToBoolean(Session.GetSUInt32("op")))
            {
                ViewBag.Users = UsersProvider.GetUsers();
                return View();
            }
            else
            {
                return RedirectToAction("Index", "Backend");
            }
            
        }
        public ActionResult ChangePassword()
        {
            return View();
        }
        [HttpPost]
        public ActionResult ChangePassword(string original, string new1, string new2)
        {
            if(new1 == new2)
            {
                if (Convert.ToBoolean(UsersProvider.ChangePassword(original, new1)))
                {
                    ViewBag.check = 3;
                    return View();
                }
                else
                {
                    ViewBag.check = 2;
                    return View();
                }
            }
            else
            {
                ViewBag.check = 1;
                return View();
            }
        }
        [HttpDelete]
        public bool DeleteUser(uint id)
        {
            bool Success = false;
            try
            {
                Success =UsersProvider.DeleteUser(id);
            }
            catch{
            }
            return Success;

        }
        [HttpPost]
        public string CreateUser(string surname = "",string secondName = "", string name = "", string dni = "", string mail = "", string telephone = "",string passUser = "",string cPassUser = "", string cellphone = "", string telephoneM = "", string address = "", string telephoneF = "", string telephoneB = "")
        {
            string Msg = "";
            if (passUser == cPassUser)
            {                
                User NewUser = new User(name, surname,secondName, Convert.ToUInt64(dni), mail, cellphone, passUser, telephone, telephoneM, telephoneF, telephoneB,address);
               
                    Msg =UsersProvider.InsertUser(NewUser);
                
            }
            else
            {
                Msg = "las contraseñas no coinciden";
            }
            if (Msg == "False")
                Msg = "Ya existe un usuario con ese mail o Dni";
            return Msg;
        }
        [HttpPost]
        public JsonResult GetDataUser(uint id)
        {            
            string JsonDataClient = JsonConvert.SerializeObject(UsersProvider.GetUserById(id));
            return Json(JsonDataClient);
        }
        [HttpPost]
        public bool UpdateUser(uint id,string surname, string name, ulong dni, string mail, string telephone, string cellphone, string secondName, string address, string telephoneM, string telephoneF, string telephoneB)
        {
            bool Success = true;
            User cUser = new User(id, name, surname, secondName, dni, mail, cellphone, telephone, telephoneM, telephoneF, telephoneB, address);
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