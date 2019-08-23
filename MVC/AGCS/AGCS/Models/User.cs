using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace AGCS.Models
{
    public class User:Person
    {
        private string _username;
        private string _passBusiness;
        private string _passUser;
        private ulong _dni;

        //Login constructor
        public User(string username, string passBusiness, string passUser)
        {
            _username = username;
            _passBusiness = passBusiness;
            _passUser = passUser;
        }



        //complete constructor
        /*public User(uint id, string name, string surname, ulong dni, string username, string passBusiness,string passUser) : base(id, name, surname, email, cellphone)
        {
            _username = username;
            _passBusiness = passBusiness;
            _passUser = passUser;
            _dni = dni;
        }*/

        public string Username { get => _username; set => _username = value; }
        public string PassBusiness { get => _passBusiness; set => _passBusiness = value; }
        public string PassUser { get => _passUser; set => _passUser = value; }
        public ulong Dni { get => _dni; set => _dni = value; }
    }
}
