using System;
using Microsoft.AspNetCore.Mvc;
using AGCS.Models;
using AGCS.Models.BDD;
using Microsoft.AspNetCore.Http;

namespace AGCS.Controllers
{
    public class HomeController : BaseController
    {

        public ActionResult Index()
        {
            Session.ClearSession();
            return View();
        }
        [HttpPost]
        public ActionResult Index(string mail, string passUser)
        {
            User Loginuser = new User(mail,passUser);
            Business LoginBusiness;
            Tuple<User, Business> objects = UsersProvider.LogIn(Loginuser);
            try
            {
                LoginBusiness = objects.Item2;
                Loginuser = objects.Item1;
           
                if (Loginuser.Name != null)
                {
                    HttpContext.Session.SetString("username", Loginuser.Name+" "+Loginuser.Surname);                    
                    HttpContext.Session.SetString("business", LoginBusiness.Name);
                    HttpContext.Session.SetInt32("op", Convert.ToInt32(Loginuser.Admin));
                    HttpContext.Session.SetInt32("idBusiness", Convert.ToInt32(LoginBusiness.Id));
                    HttpContext.Session.SetInt32("idUser", Convert.ToInt32(Loginuser.Id));
                    return RedirectToAction("Index", "Backend");
                }  
                 return View();                
            }
            catch (NullReferenceException)
            {
                ViewBag.Title = "Credenciales No Validas";
                ViewBag.Body = "El Nombre mail o la Contraseña es incorrecta";
                return View();
            }
                        
        }
    }
}
