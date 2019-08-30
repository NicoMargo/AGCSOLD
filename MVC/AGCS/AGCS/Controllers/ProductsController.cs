using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using AGCS.Models;
using AGCS.Models.BDD;
using Newtonsoft.Json;
using Microsoft.AspNetCore.Mvc;

namespace AGCS.Controllers
{
    public class ProductsController : Controller
    {
        public IActionResult Index()
        {
            return View();
        }

        //Products
        public ActionResult ProductsCRUD()
        {
            ProductsProvider.GetProducts(Helpers.idBusiness);
            ViewBag.Products = ProductsProvider.ProductsList;
            return View();
        }

        [HttpPost]
        public JsonResult GetProduct(int pos)
        {
            ProductsProvider.GetProductById(ProductsProvider.ProductsList[pos].Id, Helpers.idBusiness);
            string JsonDataProduct = JsonConvert.SerializeObject(ProductsProvider.SelectedProduct);
            return Json(JsonDataProduct);
        }
                    
        [HttpPost]
        public bool UpdateProduct(uint number, string description, string code, float cost, float price, float priceW, int stock, uint idSupplier)
        {
            bool Success = true;

            Product cUpdateProduct = new Product(ProductsProvider.SelectedProduct.Id, number, description, cost, price, priceW, stock, code,/*idSupplier*/1);

            try
            {
                ProductsProvider.UpdateProduct(cUpdateProduct, Helpers.idBusiness);
            }
            catch
            {
                Success = false;
            }

            return Success;
        }
        
        /*
        [HttpPost]
        public bool CreateProduct(string surname = "", string name = "", ulong dni = 0, string email = "", string telephone = "", string cellphone = "", string town = "", string address = "", string province = "", string leter = "", int number = 0, int floor = 0)

        //? public bool CreateProduct(string Surname = "", string Name = "", int dni = 0, string email = "", int Telephone = 0, int Cellphone = 0, string Town = "", string Address = "", string Province = "", string Leter = "", int Number = 0, int Floor = 0)

        {
            bool Success = true;
            Product NewProduct = new Product(name, surname, dni, email, telephone, cellphone);
            try
            {
                ProductsProvider.InsertProduct(NewProduct, Helpers.idBusiness);
            }
            catch
            {
                Success = false;
            }

            return Success;
        }
    */

        [HttpDelete]
        public bool DeleteProduct(uint index)
        {
            bool Success = true;
            try
            {
                ProductsProvider.DeleteProduct(ProductsProvider.ProductsList[Convert.ToInt32(index)].Id, Helpers.idBusiness);
            }
            catch
            {
                Success = false;
            }
            return Success;
        }

    }
}