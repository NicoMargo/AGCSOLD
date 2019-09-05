using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace AGCS.Models
{
    public class User:Person
    {
        private string _passUser;
        private ulong _dni;  

        //Login constructor
        public User(string email, string passUser):base(email)
        {
            _passUser = passUser;
        }

        //After Login constructor
        public User(string Name, string Surname, uint id):base(Name,Surname, id)
        {
        }

        //New User constructor
        public User(string name, string surname, ulong dni, string email, string cellphone,string passUser, string telephone) : base(name, surname, email, cellphone, telephone)
        {
            _passUser = passUser;
            _dni = dni;
        }

        //Get User By Id constructor
        public User(uint id, string name, string surname, ulong dni, string email) : base(id, name, surname, email)
        {
            _dni = dni;
        }

        public string PassUser { get => _passUser; set => _passUser = value; }
        public ulong Dni { get => _dni; set => _dni = value; }
    }
}
