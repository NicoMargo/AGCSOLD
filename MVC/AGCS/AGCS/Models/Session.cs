using Microsoft.AspNetCore.Http;
using System;

namespace AGCS.Models
{
    public class Session
    {
        private static HttpContext _shc = null;        

        public void SetSession(HttpContext HC)
        {
            SHC = HC;
        }
        public static string GetSString(string nameSession)
        {
            return SHC.Session.GetString(nameSession);
        }
        public static UInt32 GetSUInt32(string nameSession)
        {
            return Convert.ToUInt32(SHC.Session.GetInt32(nameSession));
        }
        public static HttpContext SHC { get => _shc; set => _shc = value; }
    }
}
