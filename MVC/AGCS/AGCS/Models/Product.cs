using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace AGCS.Models
{
    public class Product
    {
        private int _id;
        private string _description;
        private int _price;
        private int _stock;
        private int _quant;
        private int _iva;

        public Product(int id, string description, int price, int stock)
        {
            _id = id;
            _description = description;
            _price = price;
            _stock = stock;
        }

        public int Id { get => _id;}
        public string Description { get => _description;}
        public int Price { get => _price;}
        public int Stock { get => _stock;}
        public int Quant { get => _quant;}
        public int Iva { get => _iva;}
    }
}
