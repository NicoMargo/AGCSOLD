using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace AGCS.Models
{
    public abstract class Person
    {
        protected uint id;
        protected string name;
        protected string surname;
        protected string email;
        protected ulong telephone;
        protected ulong cellphone;

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

        public uint Id { get => id;}
        public string Name { get => name;}
        public string Surname { get => surname;}
        public string Email { get => email;}
        public ulong Telephone { get => telephone;}
        public ulong Cellphone { get => cellphone;}
    }
}
