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
        private ulong telephone;
        private ulong cellphone;

        public uint Id { get => id;  }
        public string Name { get => name; set => name = value; }
        public string Surname { get => surname; set => surname = value; }
        public string Email { get => email; set => email = value; }
        public ulong Telephone { get => telephone; set => telephone = value; }
        public ulong Cellphone { get => cellphone; set => cellphone = value; }

        protected Person(uint id, string name, string surname, string email, ulong cellphone, ulong telephone)
        {
            this.id = id;
            this.name = name;
            this.surname = surname;
            this.email = email;
            this.cellphone = cellphone;
            this.telephone = telephone;
        }

        protected Person(uint id, string name, string surname, string email, ulong cellphone)
        {
            this.id = id;
            this.name = name;
            this.surname = surname;
            this.email = email;
            this.cellphone = cellphone;
        }

        protected Person(string name, string surname, ulong cellphone, ulong telephone)
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
