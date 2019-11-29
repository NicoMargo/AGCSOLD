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
    public class ProductsController : BaseController
    {
        private float parseFloat(string value) {
            value = value.Replace('.', ',');
            float result = 0;
            Single.TryParse(value, out result);      
            return result;
        }
        public ActionResult Index()
        {
            return View();
        }

        //Products
        public ActionResult ProductsCRUD(string idSupplier)
        {
            ViewBag.Products = ProductsProvider.GetProducts();
            return View();
        }

        [HttpPost]
        public JsonResult GetProduct(uint id)
        {
            Product product = ProductsProvider.GetProductById(id);
            string JsonDataProduct = JsonConvert.SerializeObject(product);
            return Json(JsonDataProduct);
        }
                    
        [HttpPost]
        public bool UpdateProduct(uint id, uint number, string name, string description, string code, string cost, string price, string priceW,string image = "")
        {
            bool Success = true;
            float fCost = parseFloat(cost);
            float fPrice = parseFloat(price);
            float fPriceW = parseFloat(priceW);
            Product product = new Product(number, code, name,description, fCost, fPrice, fPriceW,image);
            product.Id = id;

            try
            {
                ProductsProvider.UpdateProduct(product);
            }
            catch
            {
                Success = false;
            }

            return Success;
        }
        
        
        [HttpPost]
        public bool CreateProduct(uint number, string name, string description, string code, string cost, string price, string priceW, int stock, string image)
        {
            bool success = true;
            float fCost = parseFloat(cost);
            float fPrice = parseFloat(price);
            float fPriceW = parseFloat(priceW);

            Product product = new Product(number, code, name, description, fCost, fPrice, fPriceW, image);


            try
            {
                success = ProductsProvider.InsertProduct(product);
            }
            catch
            {
                success = false;
            }

            return success;
        }
    

        [HttpDelete]
        public bool DeleteProduct(uint id)
        {
            bool success = true;
            try
            {
                ProductsProvider.DeleteProduct(id);
            }
            catch
            {
                success = false;
            }
            return success;
        }
        [HttpPost]
        public bool UpdateStock(uint id, int stock,string description)
        {
            bool success;
            try
            {
                success = ProductsProvider.UpdateStock(id, stock, description);
            }
            catch
            {
                success = false;
            }
            return success;
        }

        public ActionResult ProductStock(uint id)
        {
            ViewBag.Product = ProductsProvider.GetShortProductById(id);
            ViewBag.StockMovement = ProductsProvider.GetStockMovementById(id);
            return View();
        }
    }
}