using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace AGCS.Models
{
    public class Bill
    {
        private uint _id;
        private uint _idClient;
        private DateTime _date;
        private float _total;
        private List<Product> _products;
        private string _type;//no
        private int _employeeCode;//ni
        private string _ivaCondition;//nee
        private bool _isWholeSaler;//nah
        private float _discount;//no
        private float _ivaRecharge;

        public Bill(DateTime date, float total, List<Product> products, float ivaRecharge, uint idClient)
        {
            _date = date;
            _total = total;
            _products = products;
            _ivaRecharge = ivaRecharge;
            _idClient = idClient;
        }

        public Bill(uint id,DateTime date, float total, List<Product> products, float ivaRecharge)
        {
            _id = id;
            _date = date;
            _total = total;
            _products = products;
            _ivaRecharge = ivaRecharge;
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
        public uint IdClient { get => _idClient; set => _idClient = value; }

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
