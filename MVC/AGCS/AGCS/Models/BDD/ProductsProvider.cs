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
        private static Product selectedProduct;

        public static Product SelectedProduct { get => selectedProduct; }
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

        public static Product GetByCodeProduct(ulong code)
        {
            Product product = null;

            Dictionary<string, object> args = new Dictionary<string, object> {
                {"pIdBusiness", Session.GetSUInt32("businessId")},
                {"pCode", code}
            };
            MySqlDataReader ConnectionReader = Helpers.CallProcedureReader("spProductGetByCode", args);

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

        public static void GetByIdProduct(uint idProducts)
        {
            Product product = null;

            Dictionary<string, object> args = new Dictionary<string, object> {
                {"pIdBusiness", Session.GetSUInt32("businessId")},
                {"pId", idProducts}
            };
            MySqlDataReader ConnectionReader = Helpers.CallProcedureReader("spProductGetById", args);

            if (ConnectionReader.Read())
            {
                string description;
                float price,cost,priceW;
                int stock, articleNumber;                 
                uint idSupplier;

                string codeProduct;//arreglar
                /*Addres info ...*/
                try
                {
                    codeProduct = Helpers.ReadString(ConnectionReader, "CodeProduct");
                    articleNumber = Helpers.ReadInt(ConnectionReader, "Article_number");
                    description = Helpers.ReadString(ConnectionReader, "Description");
                    cost = Helpers.ReadFloat(ConnectionReader, "Cost");
                    price = Helpers.ReadFloat(ConnectionReader, "Price");
                    priceW = Helpers.ReadFloat(ConnectionReader, "Price_W");
                    stock = Helpers.ReadInt(ConnectionReader, "Stock");
                    idSupplier = (uint) Helpers.ReadInt(ConnectionReader, "idSupplier");

                    product = new Product(idProducts, articleNumber, description, cost, price, priceW, stock, codeProduct, Session.GetSUInt32("businessId"), idSupplier);
                }
                catch { }
            }
            Helpers.Disconect();
            selectedProduct = product;
        }

        public static bool InsertProduct(Product product) {
            bool bInserted = false;
            Dictionary<string, object> args = new Dictionary<string, object>
            {
                { "pIdBusiness", Session.GetSUInt32("businessId")} ,
                { "pCode", product.Code} ,
                { "pProduct_Number",product.ArticleNumber } ,
                { "pDescription",product.Description } ,
                { "pCost",product.Cost } ,
                { "pPrice",product.Price } ,
                { "pPriceW",product.PriceW } ,
                { "pStock",product.Stock } ,
                { "pIdSupplier", product.IdSupplier} 
            };
            bInserted = (Helpers.CallNonQuery("spProductInsert", args) > 0);
            Helpers.Disconect();
            return bInserted;
        }

        public static void UpdateProduct(Product product)
        {
            Dictionary<string, object> args = new Dictionary<string, object>
            {
                { "pId", product.Id} ,
                { "pIdBusiness",Session.GetSUInt32("businessId")} ,
                { "pCode", product.Code} ,
                { "pProduct_Number",product.ArticleNumber } ,
                { "pDescription",product.Description } ,
                { "pCost",product.Cost } ,
                { "pPrice",product.Price } ,
                { "pPriceW",product.PriceW } ,
                { "pStock",product.Stock } ,
                { "pIdSupplier", product.IdSupplier}
            };
            Helpers.CallNonQuery("spProductUpdate", args);
            Helpers.Disconect();
        }

        public static bool DeleteProduct(uint id)
        {
            bool bInserted = false;
            Dictionary<string, object> args = new Dictionary<string, object>
            {
                { "pId", id} ,
                { "pIdBusiness", Session.GetSUInt32("businessId")} 
            };
            bInserted = (Helpers.CallNonQuery("spProductDelete", args) > 0);
            Helpers.Disconect();
            return bInserted;
        }
    }
}
