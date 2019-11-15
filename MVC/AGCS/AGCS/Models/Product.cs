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
        private string _name;
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

        public uint Id { get => _id; set => _id = value; }
        public int ArticleNumber { get => _articleNumber; set => _articleNumber = value; }
        public string Name { get => _name; set => _name = value; }
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

        public Product()
        {

        }
       
        //Constructor for stockmovement
        public Product(uint id, string name, int stock)
        {
            _id = id;
            _name = name;
            _stock = stock;
        }
        
        //constructor for bills 
        public Product(uint id, string code, string name, string description, float price, int stock)
        {
            _id = id;
            _code = code;
            _name = name;
            _description = description;
            _price = price;
            _stock = stock;
        }
        
        //Constructor for GetAll
        public Product(uint id, ulong articleNumber, string code, string name, string description, float price, float priceW, int stock, string image)
        {
            _id = id;
            _articleNumber = (int)articleNumber;
            _code = code;
            _name = name;
            _description = description;
            _price = price;
            _priceW = priceW;
            _stock = stock;
            _image = image;
        }
      
        //Insert - Update - get all
        public Product(ulong articleNumber, string code, string name, string description, float cost, float price, float priceW, string image)
        {
            _articleNumber = (int)articleNumber;
            _code = code;
            _name = name;
            _description = description;
            _cost = cost;
            _price = price;
            _priceW = priceW;
            _image = image;
        }
    }
}
