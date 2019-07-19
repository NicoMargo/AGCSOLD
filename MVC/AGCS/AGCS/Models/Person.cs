using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace AGCS.Models
{
    public abstract class Person
    {
        private uint id;
        private string name;
        private string surname;
        private string email;
        private string telephone;
        private string cellphone;

        public uint Id { get => id;  }
        public string Name { get => name; set => name = value; }
        public string Surname { get => surname; set => surname = value; }
        public string Email { get => email; set => email = value; }
        public string Telephone { get => telephone; set => telephone = value; }
        public string Cellphone { get => cellphone; set => cellphone = value; }

        protected Person(uint id, string name, string surname, string email, string cellphone, string telephone)
        {
            this.id = id;
            this.name = name;
            this.surname = surname;
            this.email = email;
            this.cellphone = cellphone;
            this.telephone = telephone;
        }

        protected Person(uint id, string name, string surname, string email, string cellphone)
        {
            this.id = id;
            this.name = name;
            this.surname = surname;
            this.email = email;
            this.cellphone = cellphone;
        }

        protected Person(string name, string surname, string cellphone, string telephone)
        {
            this.name = name;
            this.surname = surname;
            this.telephone = telephone;
            this.cellphone = cellphone;
        }
        protected Person()
        {

        }
    
    }
}
