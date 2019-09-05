using System;
using System.Collections.Generic;using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using AGCS.Models;
using AGCS.Models.BDD;
using Microsoft.AspNetCore.Http;

namespace AGCS.Controllers
{
    public class HomeController : Controller
    {

        public ActionResult Index()
        {
            return View();
        }
        [HttpPost]
        public ActionResult Index(string email, string passUser)
        {
            User Loginuser = new User(email,passUser);
            Business LoginBusiness;
            Object[] Objects = UsersProvider.LogIn(Loginuser);
            LoginBusiness = (Business)Objects[0];
            Loginuser = (User)Objects[1];
            try
            {
                if (Loginuser.Name != null)
                {
                    Session.SHC = HttpContext;
                    HttpContext.Session.SetString("username", Loginuser.Name+" "+Loginuser.Surname);                    
                    HttpContext.Session.SetString("business", LoginBusiness.Name);
                    HttpContext.Session.SetInt32("idBusiness", Convert.ToInt32(LoginBusiness.Id));
                    return RedirectToAction("Index", "Backend");
                }
                else
                {
                    return View();
                }
            }
            catch (NullReferenceException)
            {
                return View();
            }
                        
        }
    }
}
