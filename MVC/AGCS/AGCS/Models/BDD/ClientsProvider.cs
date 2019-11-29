using System;
using System.Collections.Generic;
using MySql.Data.MySqlClient;

namespace AGCS.Models.BDD
{
    public static class ClientsProvider {
        //Methods for store procedures of Table Clients 
        public static List<Client> GetClients(ushort pag = 0, string search = "")
        {
            List<Client> clientsList = new List<Client>();
            Dictionary<string, object> args = new Dictionary<string, object> {
                {"pIdBusiness",Session.GetSUInt32("idBusiness")},
                {"pPage",pag},
                {"pSearch", search }
            };
            MySqlDataReader ConnectionReader = Helpers.CallProcedureReader("spClientsGet", args);
            while (ConnectionReader.Read())
            {               
                try
                {
                  
                    Client client = new Client(Convert.ToUInt32(ConnectionReader["idClient"]), Helpers.ReadString(ConnectionReader, "Name"), Helpers.ReadString(ConnectionReader, "Surname"), Helpers.ReadULong(ConnectionReader, "DNI_CUIT"), Helpers.ReadString(ConnectionReader, "Mail"), Helpers.ReadString(ConnectionReader, "Cellphone"));
                     clientsList.Add(client);
                }
                catch { }
            }
            Helpers.Disconect();
            return clientsList;
        }

        public static Client GetClientById(uint idClient)
        {

            Client client = null;
            Dictionary<string, object> args = new Dictionary<string, object> {
                {"id", idClient},
                {"pIdBusiness", Session.GetSUInt32("idBusiness")}
            };
            MySqlDataReader ConnectionReader = Helpers.CallProcedureReader("spClientGetById", args);

            if (ConnectionReader.Read())
            {
                string name, surname, mail;
                ulong dni;
                string telephone, cellphone;
                uint id;
                /*Addres info ...*/
                try
                {
                    id = Convert.ToUInt32(ConnectionReader["idClient"]);
                    name = Helpers.ReadString(ConnectionReader, "Name");
                    surname = Helpers.ReadString(ConnectionReader, "Surname");
                    dni = Helpers.ReadULong(ConnectionReader, "DNI_CUIT");
                    mail = Helpers.ReadString(ConnectionReader, "Mail");
                    telephone = Helpers.ReadString(ConnectionReader, "Telephone");
                    cellphone = Helpers.ReadString(ConnectionReader, "Cellphone");
                    client = new Client(id, name, surname, dni, mail, cellphone, telephone);
                }
                catch { }
            }
            Helpers.Disconect();
            return client;
        }

        public static Client GetClientByDNI(uint DNI)
        {
            Client client = null;
            Dictionary<string, object> args = new Dictionary<string, object> {
                {"pDNI", DNI},
                {"pIdBusiness",Session.GetSUInt32("idBusiness")}
            };
            try
            {
                MySqlDataReader ConnectionReader = Helpers.CallProcedureReader("spClientGetByDNI", args);

                if (ConnectionReader.Read())
                {
                    try
                    {
                        client = new Client(Convert.ToUInt32(ConnectionReader["idClient"]), Helpers.ReadString(ConnectionReader, "Name"), Helpers.ReadString(ConnectionReader, "Surname"), Helpers.ReadString(ConnectionReader, "Mail"), Helpers.ReadString(ConnectionReader, "Cellphone"));
                    }
                    catch { }
                }
            }
            catch { }
            Helpers.Disconect();
            return client;
        }

        public static bool InsertClient(Client client)
        {
            Dictionary<string, object> args = new Dictionary<string, object> {
                {"pIdBusiness", Session.GetSUInt32("idBusiness")},
                {"pName", client.Name},
                {"pSurname", client.Surname},
                {"pDNI_CUIT", client.Dni},
                {"pMail", client.Mail},
                {"pTelephone", client.Telephone},
                {"pCellphone", client.Cellphone }
            };

            bool success = Helpers.CallNonQuery("spClientInsert", args) > 0;
            Helpers.Disconect();
            return success;
        }

        public static void UpdateClient(Client client)
        {
            Dictionary<string, object> args = new Dictionary<string, object> {
                {"id", client.Id },
                {"pIdBusiness", Session.GetSUInt32("idBusiness")},
                {"pName", client.Name},
                {"pSurname", client.Surname},
                {"pDNI_CUIT", client.Dni},
                {"pMail", client.Mail},
                {"pTelephone", client.Telephone},
                { "pCellphone", client.Cellphone}
            };
            Helpers.CallNonQuery("spClientUpdate", args);
            Helpers.Disconect();
        }

        public static void DeleteClient(uint id)
        {
            Dictionary<string, object> args = new Dictionary<string, object> {
                {"id", id },
                {"pIdBusiness", Session.GetSUInt32("idBusiness")},
            };
            Helpers.CallNonQuery("spClientDelete", args);
            Helpers.Disconect();
        }

    }
}
