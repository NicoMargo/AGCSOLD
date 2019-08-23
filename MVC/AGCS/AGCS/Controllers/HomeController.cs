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
        const string SessionUserName = "";
        const string SessionBuisnessId = "";
        const string SessionBuisnessName = "";
        public ActionResult _Layout()
        {
            ViewBag.NameUser = HttpContext.Session.GetString(SessionUserName);
            return View();
        }
        public ActionResult Index()
        {
            return View();
        }
        [HttpPost]
        public ActionResult Index(string username,string passBuissness, string passUser)
        {
            User Loginuser = new User(username, passBuissness, passUser);
            Business LoginBusiness;
            Object[] Objects = LogInProvider.LogIn(Loginuser);
            LoginBusiness = (Business)Objects[0];
            Loginuser = (User)Objects[1];
            try
            {
                if (Loginuser.Name != null)
                {
                    
                    HttpContext.Session.SetString(SessionUserName, Loginuser.Name+" "+Loginuser.Surname);
                    HttpContext.Session.SetString(SessionBuisnessName, LoginBusiness.Name);
                    HttpContext.Session.SetInt32(SessionBuisnessId, Convert.ToInt32(LoginBusiness.Id));
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
