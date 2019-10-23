using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using MySql.Data.MySqlClient;

namespace AGCS.Models.BDD
{
    public static class SuppliersProvider
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

         //Methods for store procedures of Table Suppliers 
        public static List<Supplier> GetSuppliers()
        {
            List<Supplier> suppliersList = new List<Supplier>();
            Dictionary<string, object> args = new Dictionary<string, object> {
                {"pIdBusiness",Session.GetSUInt32("idBusiness")}
            };
            MySqlDataReader ConnectionReader = Helpers.CallProcedureReader("spSuppliersGet", args);
            while (ConnectionReader.Read())
            {
                uint id, cuit;
                string name, surname, mail, cellphone, address, company, fanciful_name;
                try
                {
                    id = Convert.ToUInt32(ConnectionReader["idSupplier"]);
                    cuit = Convert.ToUInt32(ConnectionReader["Cuit"]);
                    name = Helpers.ReadString(ConnectionReader, "Name");
                    surname = Helpers.ReadString(ConnectionReader, "Surname");
                    mail = Helpers.ReadString(ConnectionReader, "Mail");
                    cellphone = Helpers.ReadString(ConnectionReader, "Cellphone");
                    address = Helpers.ReadString(ConnectionReader, "Address");
                    company = Helpers.ReadString(ConnectionReader, "Company");
                    fanciful_name = Helpers.ReadString(ConnectionReader, "Fanciful_name");
                    Supplier supplier = new Supplier(id,cuit,name,surname,mail,cellphone,"0",address,company, fanciful_name);
                    suppliersList.Add(supplier);
                }
                catch { }
            }
            Helpers.Disconect();
            return suppliersList;
        }

        public static Supplier GetSupplierById(uint idSupplier)
        {

            Supplier supplier = null;
            Dictionary<string, object> args = new Dictionary<string, object> {
                {"pId", idSupplier},
                {"pIdBusiness", Session.GetSUInt32("idBusiness")}
            };
            MySqlDataReader ConnectionReader = Helpers.CallProcedureReader("spSupplierGetById", args);

            if (ConnectionReader.Read())
            {
                string name, surname, mail, telephone, cellphone, address, company, fanciful_name;
                uint id, cuit;
                /*Addres info ...*/
                try
                {
                    id = Convert.ToUInt32(ConnectionReader["idSupplier"]);
                    cuit = Convert.ToUInt32(ConnectionReader["Cuit"]);
                    name = Helpers.ReadString(ConnectionReader, "Name");
                    surname = Helpers.ReadString(ConnectionReader, "Surname");
                    mail = Helpers.ReadString(ConnectionReader, "Mail");
                    telephone = Helpers.ReadString(ConnectionReader, "Telephone");
                    cellphone = Helpers.ReadString(ConnectionReader, "Cellphone");
                    address = Helpers.ReadString(ConnectionReader, "Address");
                    company = Helpers.ReadString(ConnectionReader, "Company");
                    fanciful_name = Helpers.ReadString(ConnectionReader, "Fanciful_name");
                    supplier = new Supplier(id,cuit, name, surname, mail, cellphone, telephone, address, company, fanciful_name);
                }
                catch { }
            }
            Helpers.Disconect();
            return supplier;
        }

        public static bool InsertSupplier(Supplier supplier)
        {
            Dictionary<string, object> args = new Dictionary<string, object> {
                {"pIdBusiness", Session.GetSUInt32("idBusiness")},
                {"pCuit", supplier.Cuit},
                {"pName", supplier.Name},
                {"pSurname", supplier.Surname},
                {"pMail", supplier.Mail},
                {"pTelephone", supplier.Telephone},
                {"pCellphone", supplier.Cellphone},
                {"pCompany", supplier.Company},
                {"pAddress", supplier.Address},
                {"pFanciful", supplier.Fanciful_name}
            };
            bool success = Helpers.CallNonQuery("spSupplierInsert", args) > 0;
            Helpers.Disconect();
            return success;
        }

        public static void UpdateSupplier(Supplier supplier)
        {
            // IN `pCompany` VARCHAR(100), IN `pAddress` VARCHAR(200), IN `pMail` VARCHAR(100))
            Dictionary<string, object> args = new Dictionary<string, object> {
                {"pId", supplier.Id },
                {"pIdBusiness", Session.GetSUInt32("idBusiness")},
                {"pCuit", supplier.Cuit},
                {"pName", supplier.Name},
                {"pSurname", supplier.Surname},
                {"pMail", supplier.Mail},
                {"pTelephone", supplier.Telephone},
                {"pCellphone", supplier.Cellphone},
                {"pCompany", supplier.Company},
                {"pAddress", supplier.Address},
                {"pFanciful", supplier.Fanciful_name}
            };
            Helpers.CallNonQuery("spSupplierUpdate", args);
            Helpers.Disconect();
        }

        public static void DeleteSupplier(uint id)
        {
            Dictionary<string, object> args = new Dictionary<string, object> {
                {"pId", id },
                {"pIdBusiness", Session.GetSUInt32("idBusiness")},
            };
            Helpers.CallNonQuery("spSupplierDelete", args);
            Helpers.Disconect();
        }
    }
}
