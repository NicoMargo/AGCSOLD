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

        public string Address { get => _address; }
        public string Factory { get => _factory; }

        public Supplier(uint id, string name, string surname) {
            _id = id;
            _name = name;
            _surname = surname;
        }

        public Supplier(uint id, string name, string surname, string email, string cellphone, string telephone, string address, string factory) : base(id,name,surname,email,cellphone,telephone)
        {
            _address = address;
            _factory = factory;
        }

    }
}
