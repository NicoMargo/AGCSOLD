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
        private float _total;
        private string _condition;
        //que categoria tiene frente al iva (responsable inscripto, monotributista o excento de iva)
        //deberia ser un emun pq lo vamos a usar muchas veces en distintas pasrtes del proyecto, no se bien como es

        //new purchase

        private float CalculateSubtotal()
        {
            float subtotal = 0;

            if (_products.Count > 0)
            {
                foreach (Product product in _products)
                {
                    subtotal += product.Price * product.Quant;
                }
            }
            return subtotal;
        }

        public Purchase(ulong idEmployee, ulong idSupplier, List<Product> products, string condition)
        {
            _idEmployee = idEmployee;
            _idSupplier = idSupplier;
            _date = DateTime.Today;
            _products = products;
            _total = CalculateSubtotal();
            _condition = condition;
        }


        public ulong Id { get => _id; set => _id = value; }
        public ulong IdEmployee { get => _idEmployee; set => _idEmployee = value; }
        public ulong IdSupplier { get => _idSupplier; set => _idSupplier = value; }
        public DateTime Date { get => _date; set => _date = value; }
        public List<Product> Products { get => _products; set => _products = value; }
        public string Condition { get => _condition; set => _condition = value; }
        public float Total { get => _total; set => _total = value; }
    }
}
