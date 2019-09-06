using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using MySql.Data.MySqlClient;

namespace AGCS.Models.BDD
{
    public static class ProductsProvider
    {
       
        //Methods for store procedures of Table Products 
        public static List<Product> GetProducts()
        {
            List<Product> productsList = new List<Product>();

            Dictionary<string, object> args = new Dictionary<string, object> {
                {"pIdBusiness", Session.GetSUInt32("idBusiness")}
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
                string code;
                try
                {
                    id = Convert.ToUInt32(ConnectionReader["idProducts"]);
                    articleNumber = Helpers.ReadULong(ConnectionReader, "Article_Number");
                    description = Helpers.ReadString(ConnectionReader, "Description");
                    code = Helpers.ReadString(ConnectionReader, "CodeProduct");
                    cost = Helpers.ReadFloat(ConnectionReader, "Cost");
                    price = Helpers.ReadFloat(ConnectionReader, "Price");
                    stock = Helpers.ReadInt(ConnectionReader, "Stock");
                    Product product = new Product(id, (int) articleNumber,code, description, price, stock);
                    productsList.Add(product);
                }
                catch { }
            }
            Helpers.Disconect();
            return productsList;
        }

        public static Product GetProductByCode(ulong code)
        {
            Product product = null;

            Dictionary<string, object> args = new Dictionary<string, object> {
                {"pIdBusiness", Session.GetSUInt32("idBusiness")},
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

        public static Product GetProductById(uint idProducts)
        {
            Product product = null;

            Dictionary<string, object> args = new Dictionary<string, object> {
                {"pIdBusiness", Session.GetSUInt32("idBusiness")},
                {"pId", idProducts}
            };
            MySqlDataReader ConnectionReader = Helpers.CallProcedureReader("spProductGetById", args);

            if (ConnectionReader.Read())
            {
                string description;
                float price,cost,priceW;
                int stock;
                uint idSupplier, articleNumber;

                string code;//arreglar
                /*Addres info ...*/
                try
                {
                    code = Helpers.ReadString(ConnectionReader, "CodeProduct");
                    articleNumber = (uint) Helpers.ReadInt(ConnectionReader, "Article_number");
                    description = Helpers.ReadString(ConnectionReader, "Description");
                    cost = Helpers.ReadFloat(ConnectionReader, "Cost");
                    price = Helpers.ReadFloat(ConnectionReader, "Price");
                    priceW = Helpers.ReadFloat(ConnectionReader, "PriceW");
                    stock = Helpers.ReadInt(ConnectionReader, "Stock");
                    idSupplier = (uint) Helpers.ReadInt(ConnectionReader, "Suppliers_idSupplier");

                    product = new Product(idProducts, articleNumber, description, cost, price, priceW, stock, code, idSupplier);
                }
                catch { }
            }
            Helpers.Disconect();
            return product;
        }

        public static bool InsertProduct(Product product) {
            bool bInserted = false;
            Dictionary<string, object> args = new Dictionary<string, object>
            {
                { "pIdBusiness", Session.GetSUInt32("idBusiness")} ,
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
                { "pIdBusiness",Session.GetSUInt32("idBusiness")} ,
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
                { "pIdBusiness", Session.GetSUInt32("idBusiness")} 
            };
            bInserted = (Helpers.CallNonQuery("spProductDelete", args) > 0);
            Helpers.Disconect();
            return bInserted;
        }

        public static bool UpdateStock(uint idProducts, int stock)
        {
            Dictionary<string, object> args = new Dictionary<string, object>
            {
                { "pIdProducts", idProducts },
                { "pIdBusiness", Session.GetSUInt32("idBusiness")} ,
                { "pStock", stock } 
            };
            bool success = (Helpers.CallNonQuery("spProductStockUpdate", args) > 0);
            Helpers.Disconect();
            return success;
        }
    }
}
