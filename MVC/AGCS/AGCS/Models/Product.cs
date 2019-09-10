using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace AGCS.Models
{
    public class Product
    {
        private uint _id;
        private int _articleNumber;
        private string _description;
        private float _cost;
        private float _price;
        private float _priceW;
        private int _stock;
        private bool _age;
        private string _code;
        private uint _idBusiness;
        private int _quant;
        private int _iva;
        private uint _idSupplier;

        public uint Id { get => _id; set => _id = value; }
        public int ArticleNumber { get => _articleNumber; set => _articleNumber = value; }
        public string Description { get => _description; set => _description = value; }
        public float Cost { get => _cost; set => _cost = value; }
        public float Price { get => _price; set => _price = value; }
        public float PriceW { get => _priceW; set => _priceW = value; }
        public int Stock { get => _stock; set => _stock = value; }
        public bool Age { get => _age; set => _age = value; }
        public string Code { get => _code; set => _code = value; }
        public uint IdBusiness { get => _idBusiness; set => _idBusiness = value; }
        public int Quant { get => _quant; set => _quant = value; }
        public int Iva { get => _iva; set => _iva = value; }
        public uint IdSupplier { get => _idSupplier; set => _idSupplier = value; }




        //private int _idSupplier o Supplier supplier;
        

        public Product( uint id, string code, string description,float price, int stock) {
            _id = id;
            _code = code;
            _description = description;
            _price = price;
            _stock = stock;
        }

        public Product(uint id, ulong articleNumber, string code, string description, float price, float priceW, int stock)
        {
            _id = id;
            _articleNumber = (int)articleNumber;
            _code = code;
            _description = description;
            _price = price;
            _priceW = priceW;
            _stock = stock;
        }

        public Product(uint id, ulong articleNumber, string code, string description, float cost, float price, float priceW, int stock, uint idSupplier)
        {
            _id = id;
            _articleNumber =(int) articleNumber;
            _code = code;
            _description = description;
            _cost = cost;
            _price = price;
            _priceW = priceW;
            _stock = stock;
            _idSupplier = idSupplier;
        }

        public Product(ulong articleNumber, string code, string description, float cost, float price, float priceW, int stock, uint idSupplier)
        {
            _articleNumber = (int)articleNumber;
            _code = code;
            _description = description;
            _cost = cost;
            _price = price;
            _priceW = priceW;
            _stock = stock;
            _idSupplier = idSupplier;
        }
    }

}
