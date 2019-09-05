using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using AGCS.Models;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Filters;

namespace AGCS.Controllers
{
    public class BaseController : Controller
    {
        public override void OnActionExecuting(ActionExecutingContext filterContext)
        {
            Sessionh.SHC = HttpContext;
        }
    }
}