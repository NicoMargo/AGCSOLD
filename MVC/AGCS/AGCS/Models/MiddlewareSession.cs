using System.Threading.Tasks;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Http;

namespace AGCS.Models
{
    // You may need to install the Microsoft.AspNetCore.Http.Abstractions package into your project
    public class MiddlewareSession
    {
        private readonly RequestDelegate _next;

        public MiddlewareSession(RequestDelegate next)
        {
            _next = next;
        }

        public Task Invoke(HttpContext httpContext)
        {
            var path = httpContext.Request.Path;
            if (path.HasValue && path.Value != "/")
            {
                if (path.HasValue && !path.Value.StartsWith("/Home"))
                {
                    Session.SHC = httpContext;
                    if (Session.GetSUInt32("idBusiness") == 0)
                    {
                        httpContext.Response.Redirect("/Home/index");
                    }
                }
            }
            return _next(httpContext);
        }
    }

    // Extension method used to add the middleware to the HTTP request pipeline.
    public static class MiddlewareSessionExtensions
    {
        public static IApplicationBuilder UseMiddlewareSession(this IApplicationBuilder builder)
        {           
            return builder.UseMiddleware<MiddlewareSession>();
        }
    }
}
