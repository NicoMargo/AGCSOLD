using MySql.Data.MySqlClient;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace AGCS.Models.BDD
{
    public class LogInProvider
    {
        public static Object[] LogIn(User user)
        {
            Dictionary<string, object> args = new Dictionary<string, object> {
                {"pUsername",user.Username},
                {"pPassBusiness",user.PassBusiness},
                {"pPassUser",user.PassUser},
            };
            MySqlDataReader ConnectionReader = Helpers.CallProcedureReader("spLogin", args);
            Object[] TwoObjects = new Object[2];
            if (ConnectionReader.Read())
            {                
                try
                {
                    User DataUser = new User(Helpers.ReadString(ConnectionReader, "Name"), Helpers.ReadString(ConnectionReader, "Surname"), Convert.ToUInt32(ConnectionReader["idUser"]));
                    Business DataBuisness = new Business(Convert.ToUInt32(ConnectionReader["idBusiness"]), Helpers.ReadString(ConnectionReader, "NameB"));
                    TwoObjects[0] = DataBuisness;
                    TwoObjects[1] = DataUser;
                }
                catch { }
            }
            Helpers.Disconect();
            return TwoObjects;
        }

    }
}
