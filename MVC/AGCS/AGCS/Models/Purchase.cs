using System;
using System.Collections.Generic;


namespace AGCS.Models
{
    public class Purchase
    {
        private ulong _id;
        private ulong _idEmployee;
        private ulong _idSupplier;
        private DateTime _date;
        private List<Product> _products;
        private string _condition;

        //new purchase
        public Purchase(ulong idEmployee, ulong idSupplier, List<Product> products, string condition)
        {
            _idEmployee = idEmployee;
            _idSupplier = idSupplier;
            _products = products;
            _condition = condition;
        }

        public ulong Id { get => _id; set => _id = value; }
        public ulong IdEmployee { get => _idEmployee; set => _idEmployee = value; }
        public ulong IdSupplier { get => _idSupplier; set => _idSupplier = value; }
        public DateTime Date { get => _date; set => _date = value; }
        public List<Product> Products { get => _products; set => _products = value; }
        public string Condition { get => _condition; set => _condition = value; }
    }
}
