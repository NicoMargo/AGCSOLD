using System;
using System.Collections.Generic;
using MySql.Data.MySqlClient;

namespace AGCS.Models.BDD
{
    public static class PurchasesProvider
    {
        //Methods for store procedures of Table Purchases 
        public static bool InsertPurchase(Purchase purchase)
        {
            Dictionary<string, object> args = new Dictionary<string, object> {

                {"pIdBusiness", Session.GetSUInt32("idBusiness")},
                {"pDate", purchase.Date},
                {"pTotal", purchase.Total},
                {"pIdSupplier", purchase.IdSupplier},
                {"pIdEmployee", Session.GetSUInt32("idUser")}
            };
            bool success = false;
            try
            {
                MySqlDataReader ConnectionReader = Helpers.CallProcedureReader("spPurchaseInsert", args);
                if (ConnectionReader.Read())
                {
                    try
                    {
                        ulong id = Convert.ToUInt64(ConnectionReader["idPurchase"]);  
                        success = true;
                        ConnectionReader.Close();
                        if (id >= 0)
                        {
                            foreach (Product product in purchase.Products)
                            {
                                success &= InsertPurchaseXProduct(id, product);
                            }
                        }
                    }
                    catch (OverflowException)
                    { }
                }
            }
            catch { }
            Helpers.Disconect();
            return success;
        }

        //Methods for store procedures of Table Purchases
        public static bool InsertPurchaseXProduct(ulong idPurchase, Product product)
        {
            bool success = false;
            Dictionary<string, object> args = new Dictionary<string, object> {
                {"pIdPurchase", idPurchase},
                {"pIdProduct", product.Id},
                {"pQuantity", product.Quant},
                {"pIdBusiness", Session.GetSUInt32("idBusiness") },
            };
            success = Helpers.CallNonQuery("spPurchaseXProductInsert", args)>0;
            return success;
        }
    }
}
