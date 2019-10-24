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
                {"pIdUser", Session.GetSUInt32("idUser")}
            };
            bool success = false;
              MySqlDataReader ConnectionReader = Helpers.CallProcedureReader("spPurchaseInsert", args);
                if (ConnectionReader.Read())
                {
                    try
                    {
                        ulong id = Convert.ToUInt64(ConnectionReader["idPurchase"]);
                        
                        ConnectionReader.Close();
                        if (id >= 0)
                        {
                            foreach (Product product in purchase.Products)
                            {
                                success &= InsertPurchaseXProduct(id, product);
                            }
                        }
                        success = true;
                    }
                    catch (OverflowException)
                    { }
                }
            
           

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
                {"pIdUser", Session.GetSUInt32("idUser")},
                {"pCost", product.Cost}
            };
            success = Helpers.CallNonQuery("spPurchaseXProductInsert", args)>0;
            return success;
        }
    }
}
