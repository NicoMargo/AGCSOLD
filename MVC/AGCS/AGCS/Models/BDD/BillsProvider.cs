using System;
using System.Collections.Generic;
using MySql.Data.MySqlClient;

namespace AGCS.Models.BDD
{
    public static class BillsProvider
    {
        //Methods for store procedures of Table Bills 
        public static bool InsertBill(Bill bill, Client ClientBill, uint idBusiness)
        {
            bool success = false;
            if (ClientBill.Name != null)
            {
                ClientsProvider.InsertClient(ClientBill);
            }

            Dictionary<string, object> args = new Dictionary<string, object> {

                {"pIdBusiness", idBusiness},
                {"pDate", bill.Date},
                {"pTotal", bill.Total},
                {"pDNI", ClientBill.Dni}
            };
            MySqlDataReader ConnectionReader = Helpers.CallProcedureReader("spBillInsert", args);

            if (ConnectionReader.Read())
            {
                try
                {
                    uint id = Convert.ToUInt32(ConnectionReader["idBills"]);
                    ConnectionReader.Close();
                    if (id >= 0)
                    {
                        bill.Id = id;
                        foreach (Product product in bill.Products)
                        {
                            InsertBillXProduct(bill.Id, product.Id, product.Quant);
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
        public static bool InsertBillXProduct(uint idBill, uint idProduct, int quantity)
        {
            bool success = false;          
            Dictionary<string, object> args = new Dictionary<string, object> {
                {"pIdBill", idBill},
                {"pIdProduct", idProduct},
                {"pQuantity", quantity},
                {"pIdBusiness", Session.GetSUInt32("idBusiness") },
            };
            Helpers.CallNonQuery("spBillXProductInsert", args);

            return success;
        }
    }
}
