using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace AGCS.Models
{
    public class Client : Person
    {       
        private ulong _dni;
        private string _town;
        private string _Address;
        private string _province;
        private string _leter;
        private int _number;
        private int _floor;

        public ulong Dni { get => _dni; set => _dni = value; }
        public string Town { get => _town; set => _town = value; }
        public string Address { get => _Address; set => _Address = value; }
        public string Province { get => _province; set => _province = value; }
        public string Leter { get => _leter; set => _leter = value; }
        public int Number { get => _number; set => _number = value; }
        public int Floor { get => _floor; set => _floor = value; }



        //Only a few data for ABM client
        public Client(uint id,string name, string surname, ulong dni, string email, ulong cellphone ) : base(id,name,surname,email,cellphone)
        {          
            _dni = dni;
        }
        //Full Client
        public Client(uint id, string Name, string Surname, ulong dni, string email, ulong cellphone, ulong telephone) :base(id,Name,Surname,email,cellphone,telephone)
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
        public Client(string Name, string Surname, ulong dni, string email, ulong Telephone, ulong Cellphone, string Town, string Address, string Province, string Leter, int Number, int Floor): base(0, Name, Surname, email, Telephone, Cellphone)
        {
            _dni = dni;
            _town = Town;
            _Address = Address;
            _province = Province;
            _leter = Leter;
            _number = Number;
            _floor = Floor;
        }
        public Client(string Name, string Surname, ulong dni, string email, ulong Telephone, ulong Cellphone) : base(0, Name, Surname, email, Telephone, Cellphone)
        {
            _dni = dni;
        }

        public Client(uint id, string Name, string Surname, string email, ulong cellphone) : base(id, Name, Surname, email, cellphone) {

        }
        public Client(ulong Dni, string Name, string Surname, ulong Cellphone, ulong Telephone) :base(Name, Surname, Cellphone, Telephone)
        {
            _dni = Dni;
        }
        public Client() : base()
        {

        }
    }
}
