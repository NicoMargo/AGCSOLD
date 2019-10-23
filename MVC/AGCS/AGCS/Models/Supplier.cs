using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace AGCS.Models
{
    public class Supplier : Person
    {
        private uint _cuit;
        private string _address;
        private string _company;
        private string _fanciful_name;

        public uint Cuit { get => _cuit; set => _cuit = value; }
        public string Address { get => _address; set => _address = value; }
        public string Company { get => _company; set => _company = value; }
        public string Fanciful_name { get => _fanciful_name; set => _fanciful_name = value; }

        public Supplier(uint id, string name, string surname) {
            _id = id;
            _name = name;
            _surname = surname;
        }

        public Supplier(uint id, uint cuit, string name, string surname, string company, string fanciful_name ) : base(id, name, surname)
        {
            _cuit = cuit;
            _company = company;
            _fanciful_name = fanciful_name;
        }

        public Supplier(uint id, uint cuit, string name, string surname, string mail, string cellphone, string telephone, string address, string company, string fanciful_name) : base(id, name, surname, mail, cellphone, telephone)
        {
            _cuit = cuit;
            _address = address;
            _company = company;
            _fanciful_name = fanciful_name;
        }

        public Supplier( uint cuit, string name, string surname, string mail, string cellphone, string telephone, string address, string company, string fanciful_name) : base( name, surname, mail, cellphone, telephone)
        {
            _cuit = cuit;
            _address = address;
            _company = company;
            _fanciful_name = fanciful_name;
        }

    }
}
