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
            ProductsProvider.GetProducts(Helpers.idBusiness);
            ViewBag.Products = ProductsProvider.ProductsList;
            ViewBag.Suppliers = SupplierProvider.GetSuppliersShort(Helpers.idBusiness);
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
        public bool UpdateProduct(uint number, string description, string code, string cost, string price, string priceW, int stock, uint idSupplier)
        {
            bool Success = true;
            float fCost = parseFloat(cost);
            float fPrice = parseFloat(price);
            float fPriceW = parseFloat(priceW);
            Product product = new Product(ProductsProvider.SelectedProduct.Id, number, description, fCost, fPrice, fPriceW, stock, code,idSupplier);

            try
            {
                ProductsProvider.UpdateProduct(product, Helpers.idBusiness);
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

            Product product = new Product( number, description, fCost, fPrice, fPriceW, stock, code, idSupplier);

            try
            {
                success = ProductsProvider.InsertProduct(product, Helpers.idBusiness);
            }
            catch
            {
                success = false;
            }

            return success;
        }
    

        [HttpDelete]
        public bool DeleteProduct(uint index)
        {
            bool success = true;
            try
            {
                ProductsProvider.DeleteProduct(ProductsProvider.ProductsList[Convert.ToInt32(index)].Id, Helpers.idBusiness);
            }
            catch
            {
                success = false;
            }
            return success;
        }

        [HttpPost]
        public bool UpdateStock(uint pos, int stock)
        {
            bool success = true;      

            try
            {
                success = ProductsProvider.UpdateStock(ProductsProvider.ProductsList[(int)pos].Id,stock, Helpers.idBusiness);
            }
            catch
            {
                success = false;
            }

            return success;
        }
    }
}