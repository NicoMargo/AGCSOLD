using System;
using System.Collections.Generic;
using MySql.Data.MySqlClient;

namespace AGCS.Models.BDD
{
    public static class ClientsProvider {
        //Methods for store procedures of Table Clients 
        public static List<Client> GetClients()
        {
            List<Client> clientsList = new List<Client>();
            Dictionary<string, object> args = new Dictionary<string, object> {
                {"pIdBusiness",Sessionh.GetSUInt32("idBusiness")}
            };
            MySqlDataReader ConnectionReader = Helpers.CallProcedureReader("spClientsGet", args);
            while (ConnectionReader.Read())
            {
                uint id;
                string name;
                string surname;
                ulong dni;
                string eMail;
                string telephone;
                string cellphone;
                try
                {
                    id = Convert.ToUInt32(ConnectionReader["idClients"]);
                    name = Helpers.ReadString(ConnectionReader, "Name");
                    surname = Helpers.ReadString(ConnectionReader, "Surname");
                    dni = Helpers.ReadULong(ConnectionReader, "DNI_CUIT");
                    eMail = Helpers.ReadString(ConnectionReader, "eMail");
                    telephone = Helpers.ReadString(ConnectionReader, "Telephone");
                    cellphone = Helpers.ReadString(ConnectionReader, "Cellphone");
                    Client client = new Client(id, name, surname, dni, eMail, cellphone);
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
                {"pIdBusiness", Sessionh.GetSUInt32("idBusiness")}
            };
            MySqlDataReader ConnectionReader = Helpers.CallProcedureReader("spClientGetById", args);

            if (ConnectionReader.Read())
            {
                string name, surname, email;
                ulong dni;
                string telephone, cellphone;
                uint id;
                /*Addres info ...*/
                try
                {
                    id = Convert.ToUInt32(ConnectionReader["idClients"]);
                    name = Helpers.ReadString(ConnectionReader, "Name");
                    surname = Helpers.ReadString(ConnectionReader, "Surname");
                    dni = Helpers.ReadULong(ConnectionReader, "DNI_CUIT");
                    email = Helpers.ReadString(ConnectionReader, "eMail");
                    telephone = Helpers.ReadString(ConnectionReader, "Telephone");
                    cellphone = Helpers.ReadString(ConnectionReader, "Cellphone");
                    client = new Client(id, name, surname, dni, email, cellphone, telephone);
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
                {"pIdBusiness",Sessionh.GetSUInt32("idBusiness")}
            };
            MySqlDataReader ConnectionReader = Helpers.CallProcedureReader("spClientGetByDNI", args);

            if (ConnectionReader.Read())
            {
                string name, surname, email;
                string cellphone;
                uint id;
                try
                {
                    id = Convert.ToUInt32(ConnectionReader["idClients"]);
                    name = Helpers.ReadString(ConnectionReader, "Name");
                    surname = Helpers.ReadString(ConnectionReader, "Surname");
                    email = Helpers.ReadString(ConnectionReader, "eMail");
                    cellphone = Helpers.ReadString(ConnectionReader, "Cellphone");
                    client = new Client(id, name, surname, email, cellphone);
                }
                catch { }
            }
            Helpers.Disconect();
            return client;
        }

        public static bool InsertClient(Client client)
        {
            Dictionary<string, object> args = new Dictionary<string, object> {
                {"pIdBusiness", Sessionh.GetSUInt32("idBusiness")},
                {"pName", client.Name},
                {"pSurname", client.Surname},
                {"pDNI_CUIT", client.Dni},
                {"pEmail", client.Email},
                {"pTelephone", client.Telephone},
                {"pCellphone", client.Cellphone }
            };
            MySqlDataReader ConnectionReader = Helpers.CallProcedureReader("spClientInsert", args);

            bool success = false;
            if (ConnectionReader.Read())
            {
                success = Helpers.ReadBool(ConnectionReader, "success");
            }
            Helpers.Disconect();
            return success;
        }

        public static void UpdateClient(Client client)
        {
            Dictionary<string, object> args = new Dictionary<string, object> {
                {"id", client.Id },
                {"pIdBusiness", Sessionh.GetSUInt32("idBusiness")},
                {"pName", client.Name},
                {"pSurname", client.Surname},
                {"pDNI_CUIT", client.Dni},
                {"pEmail", client.Email},
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
                {"pIdBusiness", Sessionh.GetSUInt32("idBusiness")},
            };
            Helpers.CallNonQuery("spClientDelete", args);
            Helpers.Disconect();
        }

    }
}
