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
        public static List<Product> GetProducts(uint idBusiness = 0, string search = "")
        {
            List<Product> productsList = new List<Product>();

            Dictionary<string, object> args = new Dictionary<string, object> {
                {"pIdBusiness", idBusiness == 0?Session.GetSUInt32("idBusiness"):idBusiness},
                {"pSearch", search }
            };
            MySqlDataReader ConnectionReader = Helpers.CallProcedureReader("spProductsGet", args);

            while (ConnectionReader.Read())
            {
                try
                {
                    Product product = new Product(Convert.ToUInt32(ConnectionReader["idProduct"]), Helpers.ReadULong(ConnectionReader, "Article_Number"), Helpers.ReadString(ConnectionReader, "CodeProduct"), Helpers.ReadString(ConnectionReader, "Name"), Helpers.ReadString(ConnectionReader, "Description"),0, Helpers.ReadFloat(ConnectionReader, "Price"), Helpers.ReadFloat(ConnectionReader, "PriceW"), Helpers.ReadInt(ConnectionReader, "Stock"), Helpers.ReadString(ConnectionReader, "image"));
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
                try
                {
                    product = new Product(Convert.ToUInt32(ConnectionReader["idProduct"]),Helpers.ReadULong(ConnectionReader, "Article_number"), Helpers.ReadString(ConnectionReader, "CodeProduct"), Helpers.ReadString(ConnectionReader, "Name"), Helpers.ReadString(ConnectionReader, "Description"), Helpers.ReadFloat(ConnectionReader, "Cost"), Helpers.ReadFloat(ConnectionReader, "Price"), Helpers.ReadFloat(ConnectionReader, "PriceW"), Helpers.ReadInt(ConnectionReader, "Stock"), Helpers.ReadString(ConnectionReader,"Image"));
                }
                catch { }
            }
            Helpers.Disconect();
            return product;
        }
        public static Product GetProductById(uint idProduct)
        {
            Product product = null;

            Dictionary<string, object> args = new Dictionary<string, object> {
                {"pIdBusiness", Session.GetSUInt32("idBusiness")},
                {"pId", idProduct}
            };
            MySqlDataReader ConnectionReader = Helpers.CallProcedureReader("spProductGetById", args);

            if (ConnectionReader.Read())
            {
                try
                {
                    product = new Product((uint)Helpers.ReadInt(ConnectionReader, "Article_number"), Helpers.ReadString(ConnectionReader, "CodeProduct"), Helpers.ReadString(ConnectionReader, "Name"), Helpers.ReadString(ConnectionReader, "Description"), Helpers.ReadFloat(ConnectionReader, "Cost"), Helpers.ReadFloat(ConnectionReader, "Price"), Helpers.ReadFloat(ConnectionReader, "PriceW"), Helpers.ReadString(ConnectionReader, "Image"));
                    product.Id = idProduct;
                }
                catch { }
            }
            Helpers.Disconect();
            return product;
        }

        public static Product GetShortProductById(uint idProduct)
        {
            Product product = null;

            Dictionary<string, object> args = new Dictionary<string, object> {
                {"pIdBusiness", Session.GetSUInt32("idBusiness")},
                {"pId", idProduct}
            };
            MySqlDataReader ConnectionReader = Helpers.CallProcedureReader("spProductGetById", args);

            if (ConnectionReader.Read())
            {
                string name;
                int stock;
                try
                {                  
                    name = Helpers.ReadString(ConnectionReader, "Name");
                    stock = Helpers.ReadInt(ConnectionReader, "stock");
                    product = new Product(idProduct, name, stock);
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
                { "pName",product.Name } ,
                { "pDescription",product.Description } ,
                { "pCost",product.Cost } ,
                { "pPrice",product.Price } ,
                { "pPriceW",product.PriceW } ,
                { "pImage", product.Image}
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
                { "pName",product.Name } ,
                { "pDescription",product.Description } ,
                { "pCost",product.Cost } ,
                { "pPrice",product.Price } ,
                { "pPriceW",product.PriceW } ,
                { "pImage", product.Image}
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

        public static bool UpdateStock(uint idProducts, int stock, string description)
        {
            Dictionary<string, object> args = new Dictionary<string, object>
            {
                { "pId", idProducts },
                { "pStock", stock },
                { "pIdUser", Session.GetSUInt32("idUser")},
                { "pIdBusiness", Session.GetSUInt32("idBusiness")},
                { "pDesc", description }
            };
            bool success = (Helpers.CallNonQuery("spProductStockUpdate", args) > 0);
            Helpers.Disconect();
            return success;
        }

        public static List<StockMovment> GetStockMovementById(uint idProduct)
        {
            Dictionary<string, object> args = new Dictionary<string, object> {
                {"pIdProduct", idProduct}
            };
            MySqlDataReader ConnectionReader = Helpers.CallProcedureReader("spMovementGet", args);
            List<StockMovment> SmList = new List<StockMovment>();
            while (ConnectionReader.Read())
            {               
                try
                {     
                    StockMovment sm = new StockMovment((uint)Helpers.ReadInt(ConnectionReader, "id"), (ushort)Helpers.ReadInt(ConnectionReader, "type"), Helpers.ReadString(ConnectionReader, "description"), Helpers.ReadDateTime(ConnectionReader, "dateTime"), (uint)Helpers.ReadInt(ConnectionReader, "quant"), Helpers.ReadString(ConnectionReader, "name")+ " "+Helpers.ReadString(ConnectionReader, "surname"));
                    SmList.Add(sm);
                }
                catch { }
            }
            Helpers.Disconect();
            return SmList;
        }

    }
}
