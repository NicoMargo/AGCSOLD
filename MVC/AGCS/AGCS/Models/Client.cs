using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace AGCS.Models
{
    public class Client : Person
    {       
        private int _dni;
        private string _town;
        private string _Address;
        private string _province;
        private string _leter;
        private int _number;
        private int _floor;

        //Only a few data for ABM client
        public Client(int id,string name, string surname, int dni, string email, int cellphone ) : base(id,name,surname,email,cellphone)
        {          
            _dni = dni;
        }

        //Full Client
        public Client(int id, string Name, string Surname, int dni, string email, int cellphone, int telephone) :base(id,Name,Surname,email,cellphone,telephone)
        {
            _dni = dni;
            _town = Town;
            _Address = Address;
            _province = Province;
            _leter = Leter;
            _number = Number;
            _floor = Floor;
        }
        //New Client
        public Client(string Name, string Surname, int dni, string email, int Telephone, int Cellphone, string Town, string Address, string Province, string Leter, int Number, int Floor): base(999, Name, Surname, email, Telephone, Cellphone)
        {
            _dni = dni;
            _town = Town;
            _Address = Address;
            _province = Province;
            _leter = Leter;
            _number = Number;
            _floor = Floor;
        }
        public Client(string Name, string Surname, int dni, string email, int Telephone, int Cellphone) : base(999, Name, Surname, email, Telephone, Cellphone)
        {
            _dni = dni;
        }
        public int Dni { get => _dni; }       
        public string Town { get => _town; }
        public string Address { get => _Address; }
        public string Province { get => _province; }
        public string Leter { get => _leter; }
        public int Number { get => _number; }
        public int Floor { get => _floor; }

    }
}
