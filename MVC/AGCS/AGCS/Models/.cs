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
        public Client(uint id,string name, string surname, ulong dni, string mail, string cellphone ) : base(id,name,surname,mail,cellphone)
        {          
            _dni = dni;
        }
        //Full Client
        public Client(uint id, string name, string surname, ulong dni, string mail, string cellphone, string telephone) :base(id,name,surname,mail,cellphone,telephone)
        {
            _dni = dni;
        }
        //New Client
        public Client(string name, string surname, ulong dni, string mail, string telephone, string cellphone, string Town, string Address, string Province, string Leter, int Number, int Floor): base(0, name, surname, mail, telephone, cellphone)
        {
            _dni = dni;
            _town = Town;
            _Address = Address;
            _province = Province;
            _leter = Leter;
            _number = Number;
            _floor = Floor;
        }
        public Client(string name, string surname, ulong dni, string mail, string telephone, string cellphone) : base(0, name, surname, mail, cellphone, telephone)
        {
            _dni = dni;
        }

        public Client(uint id, string name, string surname, string mail, string cellphone) : base(id, name, surname, mail, cellphone) {

        }
        public Client(ulong dni, string name, string surname, string cellphone, string telephone) :base(name, surname, cellphone, telephone)
        {
            _dni = dni;
        }
        public Client() : base()
        {

        }
    }
}
