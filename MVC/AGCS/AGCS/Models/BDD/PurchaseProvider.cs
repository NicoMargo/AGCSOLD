using System;
using System.Collections.Generic;
using MySql.Data.MySqlClient;

namespace AGCS.Models.BDD
{
    public static class PruchaseProvider
    {
        /*public static List<Purchase> GetPurchases(ushort pag = 0)
        {
            List<Purchase> purchases = new List<Purchase>();
            Dictionary<string, object> args = new Dictionary<string, object> {
                {"pIdBusiness",Session.GetSUInt32("idBusiness")},
                {"pPage",pag}
            };
            MySqlDataReader ConnectionReader = Helpers.CallProcedureReader("spPurchaseGet", args);
            while (ConnectionReader.Read())
            {
                Product product = new Product();
                DateTime date;
                ulong quant;
                string employee;
                try
                {
                    product.Description = Helpers.ReadString(ConnectionReader, "Desc");
                    employee = Helpers.ReadString(ConnectionReader, "Surname");
                    quant = Helpers.ReadULong(ConnectionReader, "DNI_CUIT");
                    Purchase newPurchase = new Purchase(product, employee, quant);
                    clientsList.Add(client);
                }
                catch { }
            }
            Helpers.Disconect();
            return purchases;
        }*/


        public static bool InsertPurchase(Purchase purchase)
        {
            bool success = false;            

            Dictionary<string, object> args = new Dictionary<string, object> {
                {"pIdBusiness", Session.GetSUInt32("idBusiness")},
                {"pIdEmployee", purchase.IdEmployee},
                {"pIdProvider", purchase.IdSupplier},
                {"pCondition", purchase.Condition}
            };
            MySqlDataReader ConnectionReader = Helpers.CallProcedureReader("spPurchaseInsert", args);
            if (ConnectionReader.Read())
            {
                try
                {
                    uint id = Convert.ToUInt32(ConnectionReader["idPurchase"]);
                    ConnectionReader.Close();
                    if (id >= 0)
                    {
                        purchase.Id= id;
                        for(int i = 0; i < purchase.Products.Count; i++)
                        {
                            InsertPurchaseXProduct(purchase.Id, purchase.Products[i]);
                        }                       
                        success = true;
                    }
                }
                catch (OverflowException)
                { }
            }
            Helpers.Disconect();
            return success;
        }
        //Methods for store procedures of Table Bills
        public static bool InsertPurchaseXProduct(ulong idPurchase, Product Product)
        {
            bool success = false;
            try
            {                
                Dictionary<string, object> args = new Dictionary<string, object> {
                {"pIdPurchase", idPurchase},
                {"pIdProduct", Product.Id},
                {"pStock", Product.Stock},
                {"pCost", Product.Cost},
                {"pPrice", Product.Price},
                {"pPriceW", Product.PriceW}
            };
                Helpers.CallNonQuery("spPurchaseXProductInsert", args);
                success = true;
            }
            catch
            { }
            return success;
        }
    }
}
