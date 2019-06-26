using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace AGCS.Models
{
    public class Sale
    {
        private int _id;
        private DateTime _date;
        private float _total;
        private List<Product> _products;
        private string _type;
        private int _employeeCode;
        private string _ivaCondition;
        private bool _isWholeSaler;
        private float _discount;
        private float _ivaRecharge;

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
