using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace AGCS.Models
{
    public abstract class Person
    {
        protected uint _id;
        protected string _name;
        protected string _surname;
        protected string _mail;
        protected string _telephone;
        protected string _cellphone;

        public uint Id { get => _id;  }
        public string Name { get => _name; set =>_name = value; }
        public string Surname { get => _surname; set => _surname = value; }
        public string Mail { get => _mail; set => _mail = value; }
        public string Telephone { get => _telephone; set => _telephone = value; }
        public string Cellphone { get => _cellphone; set => _cellphone = value; }


        //Complete Constructor
        protected Person(uint id, string name, string surname, string mail, string cellphone, string telephone)
        {
            this._id = id;
            this._name = name;
            this._surname = surname;
            this._mail = mail;
            this._cellphone = cellphone;
            this._telephone = telephone;
        }
        //Get User By Id Constructor
        protected Person(uint id, string name, string surname, string mail)
        {
            this._id = id;
            this._name = name;
            this._surname = surname;
            this._mail = mail;
        }

        //New Person Constructor
        protected Person(string name, string surname, string mail, string cellphone, string telephone)
        {
            this._name = name;
            this._surname = surname;
            this._mail = mail;
            this._cellphone = cellphone;
            this._telephone = telephone;
        }

        protected Person(uint id, string name, string surname, string mail, string cellphone)
        {
            this._id = id;
            this._name = name;
            this._surname = surname;
            this._mail = mail;
            this._cellphone = cellphone;
        }
        //Get Users Constructor 
        protected Person(string name, string surname, string mail, string cellphone, uint id)
        {
            this._id = id;
            this._name = name;
            this._surname = surname;
            this._mail = mail;
            this._cellphone = cellphone;
        }

        protected Person(string name, string surname, string cellphone, string telephone)
        {
            this._name = name;
            this._surname = surname;
            this._telephone = telephone;
            this._cellphone = cellphone;
        }
        //After login Constructor
        protected Person(string name, string surname, uint id)
        {
            this._name = name;
            this._surname = surname;
            this._id = id;
        }

        //Login Constructor
        protected Person(string mail)
        {
            this._mail = mail;
        }
        protected Person()
        {

        }
    
    }
}
