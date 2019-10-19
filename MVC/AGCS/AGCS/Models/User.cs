using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace AGCS.Models
{
    public class User : Person
    {
        private string _passUser;
        private string _secondName;
        private string _address;
        private string _telephoneM;        
        private string _telephoneF;
        private string _telephoneB;
        private ulong _dni;
        private bool _admin;

        public string PassUser { get => _passUser; set => _passUser = value; }
        public string TelephoneM { get => _telephoneM; set => _telephoneM = value; }
        public string Address { get => _address; set => _address = value; }
        public string TelephoneF { get => _telephoneF; set => _telephoneF = value; }
        public string TelephoneB { get => _telephoneB; set => _telephoneB = value; }
        public ulong Dni { get => _dni; set => _dni = value; }
        public string SecondName { get => _secondName; set => _secondName = value; }
        public bool Admin { get => _admin; set => _admin = value; }

        //Login constructor
        public User(string mail, string passUser) : base(mail)
        {
            _passUser = passUser;
        }

        //After Login constructor
        public User(string Name, string Surname, uint id, bool admin) : base(Name, Surname, id)
        {
            _admin = admin;
        }

        //New User constructor
        public User(string name, string surname,string SecondName, ulong dni, string mail, string cellphone, string passUser, string telephone, string telephoneM, string telephoneF, string telephoneB, string address) : base(name, surname, mail, cellphone, telephone)
        {
            _passUser = passUser;
            _dni = dni;
            _address = address;
            _telephoneM = telephoneM;
            _telephoneF = telephoneF;
            _telephoneB = telephoneB;
            _secondName = SecondName;
        }


        //Get Users constructor
        public User(string name, string surname, ulong dni, string mail, string cellphone, uint id) : base(name, surname, mail, cellphone, id)
        {
            _dni = dni;    
        }

        //Get User By Id constructor
        public User(uint id,string name, string surname, string SecondName, ulong dni, string mail, string cellphone, string telephone, string telephoneM, string telephoneF, string telephoneB, string address) : base(id,name, surname, mail, cellphone, telephone)
        {
            _dni = dni;
            _address = address;
            _telephoneM = telephoneM;
            _telephoneF = telephoneF;
            _telephoneB = telephoneB;
            _secondName = SecondName;
        }

        //Update User constructor
        public User(uint id, string name, string surname, ulong dni, string mail, string cellphone, string telephone) : base(id, name, surname, mail, cellphone, telephone)
        {
            Dni = dni;
        }

    }
}
