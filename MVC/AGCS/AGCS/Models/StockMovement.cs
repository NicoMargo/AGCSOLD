using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace AGCS.Models
{
    public class StockMovment
    {
        private uint _id;
        private ushort _type;
        private string _description;
        private DateTime _datetime;
        private uint _quant;
        private string _employee;

        public StockMovment(uint id, ushort type, string description, DateTime datetime, uint quant, string employee)
        {
            Id = id;
            Type = type;
            Description = description;
            Datetime = datetime;
            Quant = quant;
            Employee = employee;
        }

        public uint Id { get => _id; set => _id = value; }
        public ushort Type { get => _type; set => _type = value; }
        public string Description { get => _description; set => _description = value; }
        public DateTime Datetime { get => _datetime; set => _datetime = value; }
        public uint Quant { get => _quant; set => _quant = value; }
        public string Employee { get => _employee; set => _employee = value; }
    }
}
