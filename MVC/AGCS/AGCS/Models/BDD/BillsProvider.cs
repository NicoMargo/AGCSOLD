using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
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
                ClientsProvider.InsertClient(ClientBill, Helpers.idBusiness);
            }
            /*
            MySqlConnection Connection = Connect();
            MySqlCommand CommandConnection = Connection.CreateCommand();
            CommandConnection.CommandType = System.Data.CommandType.StoredProcedure;
            CommandConnection.CommandText = "spBillInsert";
            
            CommandConnection.Parameters.AddWithValue("@pIdBusiness", idBusiness);
            CommandConnection.Parameters.AddWithValue("@pDate", bill.Date);
            CommandConnection.Parameters.AddWithValue("@pTotal", bill.Total);
            CommandConnection.Parameters.AddWithValue("@pDNI", ClientBill.Dni);
            */

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
                            InsertBillXProduct(bill.Id, product.Id, product.Quant, idBusiness);
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
        public static bool InsertBillXProduct(uint idBill, uint idProduct, int quantity, uint idBusiness)
        {
            bool success = false;
            /*
            MySqlCommand CommandConnection = connection.CreateCommand();
            CommandConnection.CommandType = System.Data.CommandType.StoredProcedure;
            CommandConnection.CommandText = "spBillXProductInsert";

            CommandConnection.Parameters.AddWithValue("@pIdBill", idBill);
            CommandConnection.Parameters.AddWithValue("@pIdProduct", idProduct);
            CommandConnection.Parameters.AddWithValue("@pQuantity", quantity);
            CommandConnection.Parameters.AddWithValue("@pIdBusiness", idBusiness);
            */
            Dictionary<string, object> args = new Dictionary<string, object> {
                {"pIdBill", idBill},
                {"pIdProduct", idProduct},
                {"pQuantity", quantity},
                {"pIdBusiness", idBusiness },
            };
            Helpers.CallNonQuery("spBillXProductInsert", args);

            return success;
        }
    }
}
