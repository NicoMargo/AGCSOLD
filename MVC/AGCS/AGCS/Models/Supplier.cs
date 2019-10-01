using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace AGCS.Models
{
    public class Supplier : Person
    {
        private string _address;
        private string _factory;

        public string Address { get => _address; set => _address = value; }
        public string Factory { get => _factory; set => _factory = value; }

        public Supplier(uint id, string name, string surname) {
            _id = id;
            _name = name;
            _surname = surname;
        }

        public Supplier(uint id, string name, string surname, string mail, string cellphone, string address) : base(id, name, surname, mail, cellphone)
        {
            _address = address;
        }

        public Supplier(uint id, string name, string surname, string mail, string cellphone, string telephone, string address, string factory) : base(id, name, surname, mail, cellphone, telephone)
        {
            _address = address;
            _factory = factory;
        }

        public Supplier( string name, string surname, string mail, string cellphone, string telephone, string address, string factory) : base( name, surname, mail, cellphone, telephone)
        {
            _address = address;
            _factory = factory;
        }

    }
}
