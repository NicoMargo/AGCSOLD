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
        private int _stock;
        private bool _age;
        private string _code;
        private int _idBusiness;
        private int _quant;
        private int _iva;

        public uint Id { get => _id; set => _id = value; }
        public int ArticleNumber { get => _articleNumber; set => _articleNumber = value; }
        public string Description { get => _description; set => _description = value; }
        public float Cost { get => _cost; set => _cost = value; }
        public float Price { get => _price; set => _price = value; }
        public int Stock { get => _stock; set => _stock = value; }
        public bool Age { get => _age; set => _age = value; }
        public string Code { get => _code; set => _code = value; }
        public int IdBusiness { get => _idBusiness; set => _idBusiness = value; }
        public int Quant { get => _quant; set => _quant = value; }
        public int Iva { get => _iva; set => _iva = value; }



        //private int _idSupplier o Supplier supplier;


        public Product(uint id, string description, float price, int stock)
        {
            _id = id;
            _description = description;
            _price = price;
            _stock = stock;
        }
        public Product()
        {         
        }

        public Product(uint id, int articleNumber, string description, float cost, float price, int stock, bool age, string code, int idBusiness, int quant, int iva)
        {
            _id = id;
            _articleNumber = articleNumber;
            _description = description;
            _cost = cost;
            _price = price;
            _stock = stock;
            _age = age;
            _code = code;
            _idBusiness = idBusiness;
            _quant = quant;
            _iva = iva;
        }


    }
}
