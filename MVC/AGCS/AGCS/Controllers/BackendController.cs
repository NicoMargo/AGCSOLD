using Microsoft.AspNetCore.Mvc;

namespace AGCS.Controllers
{
    public class BackendController : BaseController
    {

        public ActionResult Index()
        {       
            return View();
        }
        public ActionResult purchase()
        {
            return View();
        }
        
    }
}