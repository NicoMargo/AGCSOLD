using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using MySql.Data.MySqlClient;

namespace AGCS.Models
{
    public class BD
    {
        //public static string connectionString = "Server=localhost;User=root;Database=bd_agcs;Uid=Jonyloco;Pwd=agcs;"; //Chino
       // public static string connectionString = "Server=127.0.0.1;User=root;Database=bd_agcs"; //Anush
        public static string connectionString = "Server=localhost;User=root;Database=bd_agcs"; //Ort

        public static List<Client> ListClients = new List<Client>();
        public static List<Product> ListProducts = new List<Product>();
        public static Client SelectedClient;

        public static uint idBusiness = 1;
        
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

        private static ulong ReadULong(MySqlDataReader ConnectionReader, string parameter)
        {
            ulong result = 0;
            try { result = Convert.ToUInt64(ConnectionReader[parameter]); } catch { }
            return result;
        }

        private static float ReadFloat(MySqlDataReader ConnectionReader, string parameter)
        {
            float result = 0.0f;
            try { result = Convert.ToSingle(ConnectionReader[parameter]); } catch { }
            return result;
        }

        private static bool ReadBool(MySqlDataReader ConnectionReader, string parameter)
        {
            bool result = false;
            try { result = Convert.ToBoolean(ConnectionReader[parameter]); } catch { }
            return result;
        }
        /*
        private static bool ReadBool<T>(MySqlDataReader ConnectionReader, string parameter)
        {
            return (T)Convert.ChangeType(value, typeof(T));
        }*/

        //methods for DB
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

        //Methods for store procedures of Table Clients 
        public static void GetClients()

        {
            ListClients.Clear();
            MySqlConnection Connection = Connect();
            MySqlCommand CommandConnection = Connection.CreateCommand();
            CommandConnection.CommandType = System.Data.CommandType.StoredProcedure;
            CommandConnection.CommandText = "spClientsGet";
            CommandConnection.Parameters.AddWithValue("@pIdBusiness", idBusiness);
            MySqlDataReader ConnectionReader = CommandConnection.ExecuteReader();
            while (ConnectionReader.Read())
            {
                uint id;
                string name;
                string surname;
                ulong dni;
                string eMail;
                ulong telephone;
                ulong cellphone;
                try
                {
                    id = Convert.ToUInt32(ConnectionReader["idClients"]);
                    name = ReadString(ConnectionReader, "Name");
                    surname = ReadString(ConnectionReader, "Surname");
                    dni = ReadULong(ConnectionReader, "DNI_CUIT");
                    eMail = ReadString(ConnectionReader, "eMail");
                    telephone = ReadULong(ConnectionReader, "Telephone");
                    cellphone = ReadULong(ConnectionReader, "Cellphone");
                    Client client = new Client(id, name, surname, dni, eMail,cellphone);
                    ListClients.Add(client);
                }
                catch { }
            }
            Disconect(Connection);
        }

        public static void GetClientById(uint idClient)
        {
            Client client = null;
            MySqlConnection Connection = Connect();
            MySqlCommand CommandConnection = Connection.CreateCommand();
            CommandConnection.CommandType = System.Data.CommandType.StoredProcedure;
            CommandConnection.CommandText = "spClientGetById";
            CommandConnection.Parameters.AddWithValue("@id", idClient);
            CommandConnection.Parameters.AddWithValue("@pIdBusiness", idBusiness);
            MySqlDataReader ConnectionReader = CommandConnection.ExecuteReader();
            if (ConnectionReader.Read())
            {
                string name, surname, email;
                ulong dni, telephone,cellphone;
                uint id;
                /*Addres info ...*/
                try
                {
                    id = Convert.ToUInt32(ConnectionReader["idClients"]);
                    name = ReadString(ConnectionReader, "Name");
                    surname = ReadString(ConnectionReader, "Surname");
                    dni = ReadULong(ConnectionReader, "DNI_CUIT");
                    email = ReadString(ConnectionReader, "eMail");
                    telephone = ReadULong(ConnectionReader, "Telephone");
                    cellphone = ReadULong(ConnectionReader, "Cellphone");
                    client = new Client(id, name, surname, dni, email, cellphone, telephone);                    
                }
                catch { }
            }
            Disconect(Connection);
            SelectedClient =  client;
        }

        public static Client GetClientByDNI(uint DNI)
        {
            Client client = null;
            MySqlConnection Connection = Connect();
            MySqlCommand CommandConnection = Connection.CreateCommand();
            CommandConnection.CommandType = System.Data.CommandType.StoredProcedure;
            CommandConnection.CommandText = "spClientGetByDNI";
            CommandConnection.Parameters.AddWithValue("@pDNI", DNI);
            CommandConnection.Parameters.AddWithValue("@pIdBusiness", idBusiness);
            MySqlDataReader ConnectionReader = CommandConnection.ExecuteReader();
            if (ConnectionReader.Read())
            {
                string name, surname, email;
                ulong cellphone;
                uint id;
                try
                {
                    id = Convert.ToUInt32(ConnectionReader["idClients"]);
                    name = ReadString(ConnectionReader, "Name");
                    surname = ReadString(ConnectionReader, "Surname");
                    email = ReadString(ConnectionReader, "eMail");
                    cellphone = ReadULong(ConnectionReader, "Cellphone");
                    client = new Client(id, name, surname, email, cellphone);
                }
                catch { }
            }
            Disconect(Connection);
            return client;
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

        public static void DeleteClient(uint id)
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

        //Methods for store procedures of Table Products 
        public static void GetProducts()
        {
            ListProducts.Clear();
            MySqlConnection Connection = Connect();
            MySqlCommand CommandConnection = Connection.CreateCommand();
            CommandConnection.CommandType = System.Data.CommandType.StoredProcedure;
            CommandConnection.CommandText = "spProductsGet";
            CommandConnection.Parameters.AddWithValue("@pIdBusiness", idBusiness);
            MySqlDataReader ConnectionReader = CommandConnection.ExecuteReader();
            while (ConnectionReader.Read())
            {
                uint id;
                ulong articleNumber;
                string description;
                float cost;
                float price;
                int stock;
                bool age;
                string code;
                try
                {   
                    id = Convert.ToUInt32(ConnectionReader["idProducts"]);
                    description = ReadString(ConnectionReader, "Description");
                    articleNumber = ReadULong(ConnectionReader, "Article_Number");
                    cost = ReadFloat(ConnectionReader, "Cost");
                    price = ReadFloat(ConnectionReader, "Price");
                    stock = ReadInt(ConnectionReader, "Stock");
                    age = ReadBool(ConnectionReader, "Age");
                    code = ReadString(ConnectionReader, "Code");
                    Product product= new Product(id, description, price, stock);
                    ListProducts.Add(product);
                }
                catch { }
            }
            Disconect(Connection);
        }
        public static Product GetOneProduct(ulong code)
        {
            Product product = null;
            MySqlConnection Connection = Connect();
            MySqlCommand CommandConnection = Connection.CreateCommand();
            CommandConnection.CommandType = System.Data.CommandType.StoredProcedure;
            CommandConnection.CommandText = "spProductGetOne";
            CommandConnection.Parameters.AddWithValue("@pCode", code);
            CommandConnection.Parameters.AddWithValue("@pIdBusiness", idBusiness);
            MySqlDataReader ConnectionReader = CommandConnection.ExecuteReader();
            if (ConnectionReader.Read())
            {
                string description;
                float price;
                int stock;
                uint id;
                /*Addres info ...*/
                try
                {
                    id = Convert.ToUInt32(ConnectionReader["idProducts"]);
                    description = ReadString(ConnectionReader, "Description");
                    price = ReadFloat(ConnectionReader, "Price");
                    stock = ReadInt(ConnectionReader, "Stock");
                    product = new Product(id,description,price,stock);
                }
                catch { }
            }
            Disconect(Connection);
            return product;
        }
        //Methods for store procedures of Table Bills 
        public static bool InsertBill(Bill bill)
        {
            bool success = false;
            MySqlConnection Connection = Connect();
            MySqlCommand CommandConnection = Connection.CreateCommand();
            CommandConnection.CommandType = System.Data.CommandType.StoredProcedure;
            CommandConnection.CommandText = "spBillInsert";
            
            CommandConnection.Parameters.AddWithValue("@pIdBusiness", idBusiness);
            CommandConnection.Parameters.AddWithValue("@pDate", bill.Date);
            CommandConnection.Parameters.AddWithValue("@pTotal", bill.Total);
            CommandConnection.Parameters.AddWithValue("@pIdClients", bill.IdClient);
            MySqlDataReader ConnectionReader = CommandConnection.ExecuteReader();
            if (ConnectionReader.Read())
            { 
                uint id = Convert.ToUInt32(ConnectionReader["idBills"]);
                ConnectionReader.Close();
                if (id >= 0)
                {
                    bill.Id = id;
                    foreach (Product product in bill.Products)
                    {
                        InsertBillXProduct(Connection, bill.Id, product.Id, product.Quant);
                    }
                    success = true;
                }
            }

            Disconect(Connection);

            return success;
        }

        //Methods for store procedures of Table Bills
        public static bool InsertBillXProduct(MySqlConnection connection, uint idBill, uint idProduct,int quantity)
        {
            bool success = false;
            MySqlCommand CommandConnection = connection.CreateCommand();
            CommandConnection.CommandType = System.Data.CommandType.StoredProcedure;
            CommandConnection.CommandText = "spBillXProductInsert";

            CommandConnection.Parameters.AddWithValue("@pIdBill", idBill);
            CommandConnection.Parameters.AddWithValue("@pIdProduct", idProduct);
            CommandConnection.Parameters.AddWithValue("@pQuantity", quantity);
            CommandConnection.Parameters.AddWithValue("@pIdBusiness", idBusiness);

            CommandConnection.ExecuteNonQuery();
            return success;
        }
    }
}
