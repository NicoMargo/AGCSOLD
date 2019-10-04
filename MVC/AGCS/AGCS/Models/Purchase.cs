using System;
using System.Collections.Generic;


namespace AGCS.Models
{
    public class Purchase
    {
        private ulong _id;
        private ulong _idEmployee;
        private ulong _idProvider;
        private DateTime _date;
        private List<Product> _products;


        //new purchases
        public Purchase(ulong idEmployee, ulong idProvider, List<Product> products)
        {
            _idEmployee = idEmployee;
            _idProvider = idProvider;
            _products = products;
        }

        public ulong Id { get => _id; set => _id = value; }
        public ulong IdEmployee { get => _idEmployee; set => _idEmployee = value; }
        public ulong IdProvider { get => _idProvider; set => _idProvider = value; }
        public DateTime Date { get => _date; set => _date = value; }
        public List<Product> Products { get => _products; set => _products = value; }

        //new Purchase



    }
