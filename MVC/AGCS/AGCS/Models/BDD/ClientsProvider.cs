using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using MySql.Data.MySqlClient;

namespace AGCS.Models.BDD
{
    public static class ClientsProvider {

        private static Client selectedClient;
        private static List<Client> clientsList = new List<Client>();

        public static Client SelectedClient { get => selectedClient;  }
        public static List<Client> ClientsList { get => clientsList;  }


        //Methods for store procedures of Table Clients 
        public static void GetClients(uint idBusiness)
        {
            clientsList.Clear();
            /*
            MySqlConnection Connection = Connect();
            MySqlCommand CommandConnection = Connection.CreateCommand();
            CommandConnection.CommandType = System.Data.CommandType.StoredProcedure;
            CommandConnection.CommandText = "spClientsGet";
            CommandConnection.Parameters.AddWithValue("@pIdBusiness", idBusiness);
            MySqlDataReader ConnectionReader = CommandConnection.ExecuteReader();*/
            Dictionary<string, object> args = new Dictionary<string, object> {
                {"pIdBusiness",idBusiness }
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
        }

        public static void GetClientById(uint idClient, uint idBusiness)
        {

            Client client = null;
            /*
            MySqlConnection Connection = Connect();
            MySqlCommand CommandConnection = Connection.CreateCommand();
            CommandConnection.CommandType = System.Data.CommandType.StoredProcedure;
            CommandConnection.CommandText = "spClientGetById";
            CommandConnection.Parameters.AddWithValue("@id", idClient);
            CommandConnection.Parameters.AddWithValue("@pIdBusiness", idBusiness);*/
            Dictionary<string, object> args = new Dictionary<string, object> {
                {"id", idClient},
                {"pIdBusiness", idBusiness}
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
            selectedClient = client;
        }

        public static Client GetClientByDNI(uint DNI, uint idBusiness)
        {
            Client client = null;
            /*
            MySqlConnection Connection = Connect();
            MySqlCommand CommandConnection = Connection.CreateCommand();
            CommandConnection.CommandType = System.Data.CommandType.StoredProcedure;
            CommandConnection.CommandText = "spClientGetByDNI";
            CommandConnection.Parameters.AddWithValue("@pDNI", DNI);
            CommandConnection.Parameters.AddWithValue("@pIdBusiness", idBusiness);*/
            Dictionary<string, object> args = new Dictionary<string, object> {
                {"pDNI", DNI},
                {"pIdBusiness", idBusiness}
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

        public static bool InsertClient(Client client, uint idBusiness)
        {
            /*
            MySqlConnection Connection = Connect();
            MySqlCommand CommandConnection = Connection.CreateCommand();
            CommandConnection.CommandType = System.Data.CommandType.StoredProcedure;
            CommandConnection.CommandText = "spClientInsert";
            CommandConnection.Parameters.AddWithValue("@pIdBusiness", idBusiness);
            CommandConnection.Parameters.AddWithValue("@pName", client.Name);
            CommandConnection.Parameters.AddWithValue("@pSurname", client.Surname);
            CommandConnection.Parameters.AddWithValue("@pDNI_CUIT", client.Dni);
            CommandConnection.Parameters.AddWithValue("@pEmail", client.Email);
            CommandConnection.Parameters.AddWithValue("@pTelephone", client.Telephone);
            CommandConnection.Parameters.AddWithValue("@pCellphone", client.Cellphone);*/

            Dictionary<string, object> args = new Dictionary<string, object> {
                {"pIdBusiness", idBusiness},
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

        public static void UpdateClient(Client client, uint idBusiness)
        {
            /*
            MySqlConnection Connection = Connect();
            MySqlCommand CommandConnection = Connection.CreateCommand();
            CommandConnection.CommandType = System.Data.CommandType.StoredProcedure;
            CommandConnection.CommandText = "spClientUpdate";
            CommandConnection.Parameters.AddWithValue("@id", client.Id);
            CommandConnection.Parameters.AddWithValue("@pIdBusiness", idBusiness);
            CommandConnection.Parameters.AddWithValue("@pName", client.Name);
            CommandConnection.Parameters.AddWithValue("@pSurname", client.Surname);
            CommandConnection.Parameters.AddWithValue("@pDNI_CUIT", client.Dni);
            CommandConnection.Parameters.AddWithValue("@pEmail", client.Email);
            CommandConnection.Parameters.AddWithValue("@pTelephone", client.Telephone);
            CommandConnection.Parameters.AddWithValue("@pCellphone", client.Cellphone);
            /*
            CommandConnection.Parameters.AddWithValue("@pLocality", "");
            CommandConnection.Parameters.AddWithValue("@pidProvince", 0);
            CommandConnection.Parameters.AddWithValue("@pidDelivery", 0);
            CommandConnection.Parameters.AddWithValue("@pComments", "");
            */
            Dictionary<string, object> args = new Dictionary<string, object> {
                {"id", client.Id },
                {"pIdBusiness", idBusiness},
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

        public static void DeleteClient(uint id, uint idBusiness)
        {
            /*MySqlConnection Connection = Connect();
            MySqlCommand CommandConnection = Connection.CreateCommand();
            CommandConnection.CommandType = System.Data.CommandType.StoredProcedure;
            CommandConnection.CommandText = "spClientDelete";
            CommandConnection.Parameters.AddWithValue("@id", id);
            CommandConnection.Parameters.AddWithValue("@pIdBusiness", idBusiness);*/
            Dictionary<string, object> args = new Dictionary<string, object> {
                {"id", id },
                {"pIdBusiness", idBusiness},
            };
            Helpers.CallNonQuery("spClientDelete", args);
            Helpers.Disconect();
        }

    }
}
