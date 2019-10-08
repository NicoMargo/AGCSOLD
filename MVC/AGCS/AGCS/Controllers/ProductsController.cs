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
        public IActionResult Index()
        {
            return View();
        }

        //Products
        public ActionResult ProductsCRUD()
        {
            ViewBag.Products = ProductsProvider.GetProducts();
            ViewBag.Suppliers = SupplierProvider.GetSuppliersShort();
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
        public bool UpdateProduct(uint id, uint number, string description, string code, string cost, string price, string priceW, int stock, uint idSupplier)
        {
            bool Success = true;
            float fCost = parseFloat(cost);
            float fPrice = parseFloat(price);
            float fPriceW = parseFloat(priceW);
            Product product = new Product(id, number, code, description, fCost, fPrice, fPriceW, stock,idSupplier);

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
        public bool CreateProduct(uint number, string description, string code, string cost, string price, string priceW, int stock, uint idSupplier)
        {
            bool success = true;
            float fCost = parseFloat(cost);
            float fPrice = parseFloat(price);
            float fPriceW = parseFloat(priceW);

            Product product = new Product(number, code, description, fCost, fPrice, fPriceW, stock, idSupplier);

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
        public bool UpdateStock(uint id, int stock)
        {
            bool success = true;      

            try
            {
                success = ProductsProvider.UpdateStock(id, stock);
            }
            catch
            {
                success = false;
            }

            return success;
        }

        public ActionResult ProductStock(uint id)
        {
            ViewBag.StockMovement = 5;
            ViewBag.Product = ProductsProvider.GetProductById(id);
            ViewBag.Products = ProductsProvider.GetProducts();
            return View();
        }
    }
}