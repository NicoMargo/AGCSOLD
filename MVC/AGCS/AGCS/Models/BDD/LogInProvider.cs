using MySql.Data.MySqlClient;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace AGCS.Models.BDD
{
    public class LogInProvider
    {
        public static bool LogIn(User user)
        {
            Dictionary<string, object> args = new Dictionary<string, object> {
                {"pUsername",user.Username},
                {"pPassBusiness",user.PassBusiness},
                {"pPassUser",user.PassUser},
            };
            MySqlDataReader ConnectionReader = Helpers.CallProcedureReader("spClientsGet", args);
            return true;
        }

    }
}
