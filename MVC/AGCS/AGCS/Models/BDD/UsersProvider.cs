using MySql.Data.MySqlClient;
using System;
using System.Collections.Generic;

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
                    User DataUser = new User(Helpers.ReadString(ConnectionReader, "Name"), Helpers.ReadString(ConnectionReader, "Surname"), Convert.ToUInt32(ConnectionReader["idUser"]), Convert.ToBoolean(ConnectionReader["Admin"]));
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
                {"pIdBusiness",Session.GetSUInt32("idBusiness")}
            };
            MySqlDataReader ConnectionReader = Helpers.CallProcedureReader("spUsersGet", args);
            List<User> ListOfUsers = new List<User>();
            while (ConnectionReader.Read())
            {
                try
                {
                    User DataUser = new User(Helpers.ReadString(ConnectionReader, "Name"), Helpers.ReadString(ConnectionReader, "Surname"), Helpers.ReadULong(ConnectionReader, "Dni"), Helpers.ReadString(ConnectionReader, "Email"), Helpers.ReadString(ConnectionReader, "Cellphone"), Convert.ToUInt32(ConnectionReader["idUser"]));
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
                {"pIdBusiness",Session.GetSUInt32("idBusiness")},
            };
            try
            {
                Helpers.CallNonQuery("spUserDelete", args);
            }
            catch
            {

            }
            Helpers.Disconect();
        }
        public static string InsertUser(User user)
        {
            Dictionary<string, object> args = new Dictionary<string, object> {
                {"pIdBusiness", Session.GetSUInt32("idBusiness")},
                {"pName", user.Name},
                {"pSurname", user.Surname},
                {"pDni", user.Dni},
                {"pEmail", user.Email},
                {"pTelephone", user.Telephone},
                {"pPass", user.PassUser},
                {"pTelephoneM", user.TelephoneM},
                {"pTelephoneF", user.TelephoneF},
                {"pTelephoneB", user.TelephoneB},
                {"pAddress", user.Address},
                {"pSecondN", user.SecondName},
                {"pCellphone", user.Cellphone }
            };
            MySqlDataReader ConnectionReader = Helpers.CallProcedureReader("spUserInsert", args);
            string success = "Falla al registrar al usuario. Reintentar";
            if (ConnectionReader.Read())
            {
                success = Convert.ToString(Helpers.ReadBool(ConnectionReader, "success"));
            }
            Helpers.Disconect();
            return success;
        }
        public static User GetUserById(uint idUser)
        {
            Dictionary<string, object> args = new Dictionary<string, object> {
                {"pId", idUser},
                {"pIdBusiness", Session.GetSUInt32("idBusiness")}
            };
            MySqlDataReader ConnectionReader = Helpers.CallProcedureReader("spUserGetById", args);
            User user = null;
            if (ConnectionReader.Read())
            {
                try
                {
                    user = new User(Convert.ToUInt32(ConnectionReader["idUser"]), Helpers.ReadString(ConnectionReader, "Name"), Helpers.ReadString(ConnectionReader, "Surname"), Helpers.ReadString(ConnectionReader, "Name_Second"), Helpers.ReadULong(ConnectionReader, "Dni"), Helpers.ReadString(ConnectionReader, "eMail"), Helpers.ReadString(ConnectionReader, "Cellphone"), Helpers.ReadString(ConnectionReader, "Tel_User"), Helpers.ReadString(ConnectionReader, "Tel_Mother"), Helpers.ReadString(ConnectionReader, "Tel_Father"), Helpers.ReadString(ConnectionReader, "Tel_Brother"), Helpers.ReadString(ConnectionReader, "Address"));
                }
                catch { }
            }
            Helpers.Disconect();
            return user;
        }
        public static void UpdateUser(User user)
        {
            Dictionary<string, object> args = new Dictionary<string, object> {
                {"id", user.Id },
                {"pIdBusiness", Session.GetSUInt32("idBusiness")},
                {"pName", user.Name},
                {"pSurname", user.Surname},
                {"pDNI_CUIT", user.Dni},
                {"pEmail", user.Email},
                {"pTelephone", user.Telephone},
                {"pCellphone", user.Cellphone},
                {"pTelephoneM", user.TelephoneM},
                {"pTelephoneF", user.TelephoneF},
                {"pTelephoneB", user.TelephoneB},
                {"pAddress", user.Address},
                {"pSecondN", user.SecondName}
            };
           
                Helpers.CallNonQuery("spUserUpdate", args);
            
            Helpers.Disconect();

        }
        public static int ChangePassword(string original, string new1)
        {
            Dictionary<string, object> args = new Dictionary<string, object> {
                {"pId", Session.GetSUInt32("idUser")},
                {"pOriginal", original},
                {"pNew", new1}
            };
            int regs = Helpers.CallNonQuery("spUserChangePassword", args);
            Helpers.Disconect();
            return regs;
        }
    }
}
