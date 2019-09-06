using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using MySql.Data.MySqlClient;

namespace AGCS.Models.BDD
{
    public static class SupplierProvider
    {

        public static List<Supplier> GetSuppliersShort() {
            List<Supplier> suppliersList = new List<Supplier>();

            Dictionary<string, object> args = new Dictionary<string, object> {
                {"pIdBusiness", Session.GetSUInt32("idBusiness")}
            };
            MySqlDataReader ConnectionReader = Helpers.CallProcedureReader("spSuppliersGet", args);

            while (ConnectionReader.Read())
            {
                uint id;
                string name;
                string surname;
                try
                {
                    id = Convert.ToUInt32(ConnectionReader["idSupplier"]);
                    name = Helpers.ReadString(ConnectionReader, "Name");
                    surname = Helpers.ReadString(ConnectionReader, "Surname");
                    Supplier supplier = new Supplier(id, name, surname);
                    suppliersList.Add(supplier);
                }
                catch { }
            }
            Helpers.Disconect();
            return suppliersList;
        }
    }
}
