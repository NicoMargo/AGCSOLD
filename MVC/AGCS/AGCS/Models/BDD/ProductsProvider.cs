using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using MySql.Data.MySqlClient;

namespace AGCS.Models.BDD
{
    public static class ProductsProvider
    {
        private static List<Product> productsList = new List<Product>();
        public static List<Product> ProductsList { get => productsList; }
        //Methods for store procedures of Table Products 
        public static void GetProducts(uint idBusiness)
        {
            /*
            ListProducts.Clear();
            MySqlConnection Connection = Connect();
            MySqlCommand CommandConnection = Connection.CreateCommand();
            CommandConnection.CommandType = System.Data.CommandType.StoredProcedure;
            CommandConnection.CommandText = "spProductsGet";
            CommandConnection.Parameters.AddWithValue("@pIdBusiness", idBusiness);*/

            Dictionary<string, object> args = new Dictionary<string, object> {
                {"pIdBusiness", idBusiness}
            };
            MySqlDataReader ConnectionReader = Helpers.CallProcedureReader("spProductsGet", args);

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
                    description = Helpers.ReadString(ConnectionReader, "Description");
                    articleNumber = Helpers.ReadULong(ConnectionReader, "Article_Number");
                    cost = Helpers.ReadFloat(ConnectionReader, "Cost");
                    price = Helpers.ReadFloat(ConnectionReader, "Price");
                    stock = Helpers.ReadInt(ConnectionReader, "Stock");
                    age = Helpers.ReadBool(ConnectionReader, "Age");
                    code = Helpers.ReadString(ConnectionReader, "Code");
                    Product product = new Product(id, description, price, stock);
                    productsList.Add(product);
                }
                catch { }
            }
            Helpers.Disconect();
        }
        public static Product GetOneProduct(ulong code, uint idBusiness)
        {
            Product product = null;
            /*
            MySqlConnection Connection = Connect();
            MySqlCommand CommandConnection = Connection.CreateCommand();
            CommandConnection.CommandType = System.Data.CommandType.StoredProcedure;
            CommandConnection.CommandText = "spProductGetOne";
            CommandConnection.Parameters.AddWithValue("@pCode", code);
            CommandConnection.Parameters.AddWithValue("@pIdBusiness", idBusiness);*/

            Dictionary<string, object> args = new Dictionary<string, object> {
                {"pIdBusiness", idBusiness},
                {"pCode", code}
            };
            MySqlDataReader ConnectionReader = Helpers.CallProcedureReader("spProductGetOne", args);

            if (ConnectionReader.Read())
            {
                string description;
                float price;
                int stock;
                uint id;
                string codeProduct;//arreglar
                /*Addres info ...*/
                try
                {
                    id = Convert.ToUInt32(ConnectionReader["idProducts"]);
                    description = Helpers.ReadString(ConnectionReader, "Description");
                    price = Helpers.ReadFloat(ConnectionReader, "Price");
                    stock = Helpers.ReadInt(ConnectionReader, "Stock");
                    codeProduct = Helpers.ReadString(ConnectionReader, "CodeProduct");
                    product = new Product(id, description, price, stock, codeProduct);
                }
                catch { }
            }
            Helpers.Disconect();
            return product;
        }

    }
}
