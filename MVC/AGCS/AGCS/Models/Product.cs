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
        //private int _idSupplier o Supplier supplier;


        public Product(uint id, string description, float price, int stock)
        {
            _id = id;
            _description = description;
            _price = price;
            _stock = stock;
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

        public uint Id { get => _id; }
        public int ArticleNumber { get => _articleNumber;}
        public string Description { get => _description; }
        public float Cost { get => _cost;  }
        public float Price { get => _price;  }
        public int Stock { get => _stock;  }
        public bool Age { get => _age; }
        public string Code { get => _code; }
        public int IdBusiness { get => _idBusiness;  }
        public int Quant { get => _quant;}
        public int Iva { get => _iva;}
    }
}
