using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace AGCS.Models
{
    public class Client
    {
        private int _id;
        private string _name;
        private string _surname;
        private int _dni;
        private string _email;
        private int _phone;
        private int _cellphone;
        private string _town;
        private string _Address;
        private string _province;
        private string _leter;
        private int _number;
        private int _floor;

        //Only a few data for ABM client
        public Client(int id, string name, string surname, int dni, string email, int cellphone)
        {
            _id = id;
            _name = name;
            _surname = surname;
            _dni = dni;
            _email = email;
            _cellphone = cellphone;
        }

        //Full Client
        public Client(int id, string Name, string Surname, int dni, string email, int Telephone, int Cellphone, string Town, string Address, string Province, string Leter, int Number, int Floor)
        {
            _id = id;
            _name = Name;
            _surname = Surname;
            _dni = dni;
            _email = email;
            _phone = Telephone;
            _cellphone = Cellphone;
            _town = Town;
            _Address = Address;
            _province = Province;
            _leter = Leter;
            _number = Number;
            _floor = Floor;
        }
        //New Client
        public Client( string Name, string Surname, int dni, string email, int Telephone, int Cellphone, string Town, string Address, string Province, string Leter, int Number, int Floor)
        {
            _name = Name;
            _surname = Surname;
            _dni = dni;
            _email = email;
            _phone = Telephone;
            _cellphone = Cellphone;
            _town = Town;
            _Address = Address;
            _province = Province;
            _leter = Leter;
            _number = Number;
            _floor = Floor;
        }

        public int Id { get => _id; }
        public string Name { get => _name; }
        public string Surname { get => _surname; }
        public int Dni { get => _dni; }
        public string Email { get => _email; }
        public int Telephone { get => _phone; }
        public int Cellphone { get => _cellphone; }
        public string Town { get => _town; }
        public string Address { get => _Address; }
        public string Province { get => _province; }
        public string Leter { get => _leter; }
        public int Number { get => _number; }
        public int Floor { get => _floor; }
    }
}
