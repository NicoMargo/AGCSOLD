﻿using System;
using System.Collections.Generic;
using MySql.Data.MySqlClient;

namespace AGCS.Models.BDD
{
    public static class Helpers
    {
        //public static string connectionString = "Server=localhost;User=root;Database=bd_agcs;Uid=Jonyloco;Pwd=agcs;"; //Chino
        //public static string connectionString = "Server=127.0.0.1;User=root;Database=bd_agcs"; //Anush
        public static string connectionString = "Server=localhost;User=root;Database=bd_agcs"; //Ort
        private static MySqlConnection Connection;

        public static List<Product> ListProducts = new List<Product>();

        public static void Connect()
        {
            try
            {
                Connection = new MySqlConnection(connectionString);
                Connection.Open();
            }
            catch
            {

            }
        }

        public static void Disconect()
        {
            try
            {
                try
                {
                    Connection.Close();
                }
                catch
                {
                    Connection.Close();
                }
            }
            catch
            {

            }
        }

        public static MySqlDataReader CallProcedureReader(string procedureName, Dictionary<string, object> args)
        {
            Connect();
            MySqlCommand CommandConnection = Connection.CreateCommand();
            CommandConnection.CommandType = System.Data.CommandType.StoredProcedure;

            CommandConnection.CommandText = procedureName;
            foreach (string arg in args.Keys)
            {
                CommandConnection.Parameters.AddWithValue("@" + arg, args[arg]);
            }
            return CommandConnection.ExecuteReader();
        }

        public static int CallNonQuery(string procedureName, Dictionary<string, object> args)
        {
            Connect();
            MySqlCommand CommandConnection = Connection.CreateCommand();
            CommandConnection.CommandType = System.Data.CommandType.StoredProcedure;

            CommandConnection.CommandText = procedureName;
            foreach (string arg in args.Keys)
            {
                CommandConnection.Parameters.AddWithValue("@" + arg, args[arg]);
            }
            return CommandConnection.ExecuteNonQuery();
        }

        public static string ReadString(MySqlDataReader ConnectionReader, string parameter)
        {
            string result = null;
            try { result = ConnectionReader[parameter].ToString(); } catch { }
            return result;
        }

        public static int ReadInt(MySqlDataReader ConnectionReader, string parameter)
        {
            int result = 0;
            try { result = Convert.ToInt32(ConnectionReader[parameter]); } catch { }
            return result;
        }
        public static DateTime ReadDateTime(MySqlDataReader ConnectionReader, string parameter)
        {
            DateTime result = new DateTime();
            try { result = Convert.ToDateTime(ConnectionReader[parameter]); } catch { }
            return result;
        }

        public static ulong ReadULong(MySqlDataReader ConnectionReader, string parameter)
        {
            ulong result = 0;
            try { result = Convert.ToUInt64(ConnectionReader[parameter]); } catch { }
            return result;
        }

        public static float ReadFloat(MySqlDataReader ConnectionReader, string parameter)
        {
            float result = 0.0f;
            try { result = Convert.ToSingle(ConnectionReader[parameter]); } catch { }
            return result;
        }

        public static bool ReadBool(MySqlDataReader ConnectionReader, string parameter)
        {
            bool result = false;
            try { result = Convert.ToBoolean(ConnectionReader[parameter]); } catch { }
            return result;
        }

    }
}
