using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace AGCS.Models
{
    public class Product
    {
        private uint _id;
        private string _code;
        private int _articleNumber;
        private string _description;
        private float _cost;
        private float _price;
        private float _priceW;
        private int _stock;
        private string _image;
        private bool _age;
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
        public string Image { get => _image; set => _image = value; }
        public bool Age { get => _age; set => _age = value; }
        public string Code { get => _code; set => _code = value; }
        public uint IdBusiness { get => _idBusiness; set => _idBusiness = value; }
        public int Quant { get => _quant; set => _quant = value; }
        public int Iva { get => _iva; set => _iva = value; }
        public uint IdSupplier { get => _idSupplier; set => _idSupplier = value; }


        public Product()
        {

        }

        //private int _idSupplier o Supplier supplier;

        //Constructor for stockmovement
        public Product(uint id, string description, int stock)
        {
            _id = id;
            _description = description;
            _stock = stock;
        }
        
        //constructor for bills 
        public Product(uint id, string code, string description, float price, int stock)
        {
            _id = id;
            _code = code;
            _description = description;
            _price = price;
            _stock = stock;
        }
        
        //Constructor for  purchases(obsolete)
        public Product(uint id, string code, string description, float price, float priceW, float cost, int stock)
        {
            _id = id;
            _code = code;
            _description = description;
            _price = price;
            _priceW = priceW;
            _cost = cost;
            _stock = stock;
        }
        
        //Constructor for GetAll
        public Product(uint id, ulong articleNumber, string code, string description, float price, float priceW, int stock, string image)
        {
            _id = id;
            _articleNumber = (int)articleNumber;
            _code = code;
            _description = description;
            _price = price;
            _priceW = priceW;
            _stock = stock;
            _image = image;
        }
        
        //Constructor for update
        public Product(uint id, ulong articleNumber, string code, string description, float cost, float price, float priceW, int stock, uint idSupplier, string image)
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
            _image = image;
        }
        
        public Product(uint id, ulong articleNumber, string code, string description, float cost, float price, float priceW, uint idSupplier, string image)
        {
            _id = id;
            _articleNumber = (int)articleNumber;
            _code = code;
            _description = description;
            _cost = cost;
            _price = price;
            _priceW = priceW;
            _idSupplier = idSupplier;
            _image = image;
        }
        
        public Product(ulong articleNumber, string code, string description, float cost, float price, float priceW, uint idSupplier, string image)
        {
            _articleNumber = (int)articleNumber;
            _code = code;
            _description = description;
            _cost = cost;
            _price = price;
            _priceW = priceW;
            _idSupplier = idSupplier;
            _image = image;
        }
        
    }
}
