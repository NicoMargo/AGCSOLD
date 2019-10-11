using System;
using System.Collections.Generic;
using MySql.Data.MySqlClient;

namespace AGCS.Models.BDD
{
    public static class PurchasesProvider
    {
        //Methods for store procedures of Table Purchases 
        public static bool InsertPurchase(Purchase purchase, Supplier supplier , uint idBusiness)
        {
            bool success = false;
            if (supplier.Name != null)
            {
                SuppliersProvider.InsertSupplier(supplier);
            }

            Dictionary<string, object> args = new Dictionary<string, object> {

                {"pIdBusiness", Session.GetSUInt32("idBusiness")},
                {"pDate", purchase.Date},
                {"pTotal", purchase.Total},
                {"pIdSupplier", supplier.Id}
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
                        purchase.Id = id;
                        foreach (Product product in purchase.Products)
                        {
                            InsertPurchaseXProduct(purchase.Id, product);
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

        //Methods for store procedures of Table Purchases
        public static bool InsertPurchaseXProduct(ulong idPurchase, Product product)
        {
            bool success = false;
            Dictionary<string, object> args = new Dictionary<string, object> {
                {"pIdPurchase", idPurchase},
                {"pIdProduct", product.Id},
                {"pQuantity", product.Quant},
                {"pCost", product.Cost},
                {"pIdBusiness", Session.GetSUInt32("idBusiness") },
            };
            Helpers.CallNonQuery("spPurchaseXProductInsert", args);

            return success;
        }
    }
}
