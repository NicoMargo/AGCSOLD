using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace AGCS.Models
{
    public class Bill
    {
        private uint _id;
        private uint _dniClient;
        private DateTime _date;
        private List<Product> _products;
        private float _subtotal;
        private bool _isWholeSaler;//nah
        private string _ivaCondition;//nee
        private float _ivaRecharge;
        private float _discount;
        private float _total;
        private string _type;//no
        private int _employeeCode;//ni

        private float calculateSubtotal() {
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

        private float calculateTotal()
        {
            float total = 0;

            if (_subtotal > 0)
            {
                float rechargedSubtotal = _subtotal + _subtotal * IvaRecharge / 100.0f;
                total = rechargedSubtotal - rechargedSubtotal * Discount / 100.0f;
            }

            return total;
        }

        public Bill(DateTime date, List<Product> products, float ivaRecharge, float discount, uint DniClient)
        {
            _date = date;
            _products = products;
            _subtotal = calculateSubtotal();
            _ivaRecharge = ivaRecharge;
            _discount = discount;
            _total = calculateTotal();
            _dniClient = DniClient;
        }

        public Bill(uint id, DateTime date, List<Product> products, float subtotal, float discount, float ivaRecharge, float total)
        {
            _id = id;
            _date = date;
            _total = total;
            _products = products;
            _ivaRecharge = ivaRecharge;
            _discount = discount;
        }

        public Bill( DateTime date, float total, List<Product> products, string type, int employeeCode, string ivaCondition, bool isWholeSaler, float discount, float ivaRecharge)
        {
            _date = date;
            _total = total;
            _products = products;
            _type = type;
            _employeeCode = employeeCode;
            _ivaCondition = ivaCondition;
            _isWholeSaler = isWholeSaler;
            _discount = discount;
            _ivaRecharge = ivaRecharge;
        }
        
        public uint Id { get => _id; set => _id = value; }
        public DateTime Date { get => _date; set => _date = value; }
        public float Total { get => _total; set => _total = value; }
        public List<Product> Products { get => _products; set => _products = value; }
        public string Type { get => _type; set => _type = value; }
        public int EmployeeCode { get => _employeeCode; set => _employeeCode = value; }
        public string IvaCondition { get => _ivaCondition; set => _ivaCondition = value; }
        public bool IsWholeSaler { get => _isWholeSaler; set => _isWholeSaler = value; }
        public float Discount { get => _discount; set => _discount = value; }
        public float IvaRecharge { get => _ivaRecharge; set => _ivaRecharge = value; }
        public uint DniClient { get => _dniClient; set => _dniClient = value; }

        /*
  `idSales` int(11) NOT NULL AUTO_INCREMENT,
  `Date` date DEFAULT NULL,
  `DNI/CUIT` int(11) DEFAULT NULL,
  `Employee_Code` int(11) DEFAULT NULL,
  `IVA_Condition` varchar(45) DEFAULT NULL,
  `Type` varchar(1) DEFAULT NULL,
  `Total` int(11) DEFAULT NULL,
  `Discount` int(11) DEFAULT NULL,
  `IVA_Recharge` int(11) DEFAULT NULL,
  `WholeSaler` bit(1) DEFAULT NULL,
  `Branches_idBranch` int(11) NOT NULL,
  `Payment_Methods_idPayment_Methods` int(11) NOT NULL,
  `Macs_idMacs` int(11) NOT NULL,
  `Business_idBusiness` int(11) NOT NULL,
            */
    }
}
