using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace AGCS.Models
{
    public abstract class Person
    {
        protected int id;
        protected string name;
        protected string surname;
        protected string email;
        protected int telephone;
        protected int cellphone;

        protected Person(int id, string name, string surname, string email, int telephone, int cellphone)
        {
            this.id = id;
            this.name = name;
            this.surname = surname;
            this.email = email;
            this.telephone = telephone;
            this.cellphone = cellphone;
        }

        protected Person(int id, string name, string surname, string email, int cellphone)
        {
            this.id = id;
            this.name = name;
            this.surname = surname;
            this.email = email;
            this.cellphone = cellphone;
        }

        public int Id { get => id;}
        public string Name { get => name;}
        public string Surname { get => surname;}
        public string Email { get => email;}
        public int Telephone { get => telephone;}
        public int Cellphone { get => cellphone;}
    }
}
