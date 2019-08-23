using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace AGCS.Models
{
    public class Business
    {
        private uint _id;
        private string _name;

        public Business(uint id, string name)
        {
            Id = id;
            Name = name;
        }

        public uint Id { get => _id; set => _id = value; }
        public string Name { get => _name; set => _name = value; }
    }
}
