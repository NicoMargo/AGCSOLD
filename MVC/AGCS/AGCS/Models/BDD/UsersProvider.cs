using MySql.Data.MySqlClient;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace AGCS.Models.BDD
{
    public class UsersProvider
    {
        public static Object[] LogIn(User user)
        {
            Dictionary<string, object> args = new Dictionary<string, object> {
                {"Email",user.Email},
                {"Password",user.PassUser}
            };
            MySqlDataReader ConnectionReader = Helpers.CallProcedureReader("spUserLogin", args);
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
        public static List<User> GetUsers()
        {
            Dictionary<string, object> args = new Dictionary<string, object> {
                {"pIdBusiness",1}
            };
            MySqlDataReader ConnectionReader = Helpers.CallProcedureReader("spUsersGet", args);
            List<User> ListOfUsers = new List<User>();
            while (ConnectionReader.Read())
            {
                try
                {
                    User DataUser = new User(Helpers.ReadString(ConnectionReader, "Name"), Helpers.ReadString(ConnectionReader, "Surname"), Convert.ToUInt32(ConnectionReader["idUser"]));
                    ListOfUsers.Add(DataUser);
                }
                catch { }
            }
            Helpers.Disconect();
            return ListOfUsers;
        }
        public static void DeleteUser(uint id)
        {
            Dictionary<string, object> args = new Dictionary<string, object> {
                {"pId", id },
                {"pIdBusiness",1},
            };
            Helpers.CallNonQuery("spUserDelete", args);
            Helpers.Disconect();
        }
        public static bool InsertUser(User user)
        {
            Dictionary<string, object> args = new Dictionary<string, object> {
                {"pIdBusiness", 1},
                {"pName", user.Name},
                {"pSurname", user.Surname},
                {"pDni", user.Dni},
                {"pEmail", user.Email},
                {"pTelephone", user.Telephone},
                {"pPass", user.PassUser},
                {"pCellphone", user.Cellphone }
            };
            MySqlDataReader ConnectionReader = Helpers.CallProcedureReader("spUserInsert", args);
            bool success = false;
            if (ConnectionReader.Read())
            {
                success = Helpers.ReadBool(ConnectionReader, "success");
            }
            Helpers.Disconect();
            return success;
        }
        public static User GetUserById(uint idUser)
        {
            Dictionary<string, object> args = new Dictionary<string, object> {
                {"pId", idUser},
                {"pIdBusiness", 1}
            };
            MySqlDataReader ConnectionReader = Helpers.CallProcedureReader("spUserGetById", args);
            User user = null;
            if (ConnectionReader.Read())
            {
                string name, surname, email;
                ulong dni;
                string telephone, cellphone;
                uint id;
                /*Addres info ...*/
                try
                {
                    id = Convert.ToUInt32(ConnectionReader["idUser"]);
                    name = Helpers.ReadString(ConnectionReader, "Name");
                    surname = Helpers.ReadString(ConnectionReader, "Surname");
                    dni = Helpers.ReadULong(ConnectionReader, "Dni");
                    email = Helpers.ReadString(ConnectionReader, "eMail");
                    //telephone = Helpers.ReadString(ConnectionReader, "Telephone");
                    //cellphone = Helpers.ReadString(ConnectionReader, "Cellphone");
                    user = new User(id, name, surname, dni, email);
                }
                catch { }
            }
            Helpers.Disconect();
            return user;
        }

    }

}
