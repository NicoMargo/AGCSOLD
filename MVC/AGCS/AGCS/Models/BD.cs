using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using MySql.Data.MySqlClient;


namespace AGCS.Models
{
    public class BD
    {
        //xd
       //public static string connectionString = "Server=127.0.0.1;User=root;Database=pruebaclientes"; //Anush
        public static string connectionString = "Server=localhost;User=root;Database=bd_agcs"; //Ort
        public static List<Client> ListOfClients = new List<Client>();
        public static Client SelectedClient;
        public static int idBusiness = 1;

        private static string ReadString(MySqlDataReader ConnectionReader, string parameter)
        {
            string result = null;
            try { result = ConnectionReader[parameter].ToString(); } catch { }
            return result;
        }
        private static int ReadInt(MySqlDataReader ConnectionReader, string parameter)
        {
            int result = 0;
            try { result = Convert.ToInt32(ConnectionReader[parameter]); } catch { }
            return result;
        }

        //Funciones para la bd
        public static MySqlConnection Connect()
        {
             MySqlConnection Connection = new MySqlConnection(connectionString);
            Connection.Open();
             return Connection;
        }

        public static void Disconect(MySqlConnection Connection)
        {
            Connection.Close();
        }
        //storeProcedures CLientes
        public static void GetClients(int idBusiness)
        {
            ListOfClients.Clear();
            MySqlConnection Connection = Connect();
            MySqlCommand CommandConnection = Connection.CreateCommand();
            CommandConnection.CommandType = System.Data.CommandType.StoredProcedure;
            CommandConnection.CommandText = "spClientsGet";
            CommandConnection.Parameters.AddWithValue("@pIdBusiness", idBusiness);
            MySqlDataReader ConnectionReader = CommandConnection.ExecuteReader();
            while (ConnectionReader.Read())
            {
                int id;
                string name;
                string surname;
                int dni;
                string eMail;
                int telephone;
                int cellphone;
                try
                {
                    id = Convert.ToInt32(ConnectionReader["idClients"]);
                    name = ReadString(ConnectionReader, "Name");
                    surname = ReadString(ConnectionReader, "Surname");
                    dni = ReadInt(ConnectionReader, "DNI_CUIT");
                    eMail = ReadString(ConnectionReader, "eMail");
                    telephone = ReadInt(ConnectionReader, "Telephone");
                    cellphone = ReadInt(ConnectionReader, "Cellphone");
                    Client client = new Client(id, name, surname, dni, eMail,cellphone);
                    ListOfClients.Add(client);
                }
                catch { }
            }
            Disconect(Connection);
        }

        public static void GetOneClient(int idClient, int idBusiness)
        {
            Client client = null;
            MySqlConnection Connection = Connect();
            MySqlCommand CommandConnection = Connection.CreateCommand();
            CommandConnection.CommandType = System.Data.CommandType.StoredProcedure;
            CommandConnection.CommandText = "spClientGetOne";
            CommandConnection.Parameters.AddWithValue("@id", idClient);
            CommandConnection.Parameters.AddWithValue("@pIdBusiness", idBusiness);
            MySqlDataReader ConnectionReader = CommandConnection.ExecuteReader();
            if (ConnectionReader.Read())
            {
                string name, surname, email;
                int id, dni, telephone,cellphone;
                /*Addres info ...*/
                try
                {
                    id = Convert.ToInt32(ConnectionReader["idClients"]);
                    name = ReadString(ConnectionReader, "Name");
                    surname = ReadString(ConnectionReader, "Surname");
                    dni = ReadInt(ConnectionReader, "DNI_CUIT");
                    email = ReadString(ConnectionReader, "eMail");
                    telephone = ReadInt(ConnectionReader, "Telephone");
                    cellphone = ReadInt(ConnectionReader, "Cellphone");
                    client = new Client(id, name, surname, dni, email, cellphone, telephone);                    
                }
                catch { }
            }
            Disconect(Connection);
            SelectedClient =  client;
        }

        public static void InsertClient(Client client)
        {
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
            CommandConnection.Parameters.AddWithValue("@pCellphone", client.Cellphone);
            CommandConnection.Parameters.AddWithValue("@pAddress", "Calle 66306613333");
            CommandConnection.Parameters.AddWithValue("@pLocality", "");
            CommandConnection.Parameters.AddWithValue("@pIdProvince", 0);
            CommandConnection.Parameters.AddWithValue("@pIdDelivery", 0);
            CommandConnection.Parameters.AddWithValue("@pComments", "");

            CommandConnection.ExecuteNonQuery();
            Disconect(Connection);

        }
        public static void UpdateClient(Client client)
        {
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
            CommandConnection.ExecuteNonQuery();
            Disconect(Connection);

        }

        public static void DeleteClient(int id)
        {
            MySqlConnection Connection = Connect();
            MySqlCommand CommandConnection = Connection.CreateCommand();
            CommandConnection.CommandType = System.Data.CommandType.StoredProcedure;
            CommandConnection.CommandText = "spClientDelete";
            CommandConnection.Parameters.AddWithValue("@id", id);
            CommandConnection.Parameters.AddWithValue("@pIdBusiness", idBusiness);
            CommandConnection.ExecuteNonQuery();
            Disconect(Connection);
        }
    }
}
