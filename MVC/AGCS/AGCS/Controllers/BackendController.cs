using System.Collections.Generic;
using Microsoft.AspNetCore.Mvc;
using AGCS.Models;
using AGCS.Models.BDD;
using Newtonsoft.Json;
using System;
using System.IO;
using IronPdf;

namespace AGCS.Controllers
{
    public class BackendController : BaseController
    {

        public ActionResult Index()
        {       
            return View();
        }
        public ActionResult purchase()
        {
            //ViewBag.purchases = PurchasesProvider.GetPurchases();
            return View();
        }
        [HttpPost]
        public ActionResult purchase(uint idEmployee, List<uint> idProduct, List<uint> idProvider, List<uint> quant)
        {
            //Purchase purchase = new Purchase(idEmployee, idProduct, quant);
            return View();
        }

        //Facturacion
        [HttpPost]
        public bool NewBill(string json, uint dniClient, string jsonClient, float recharge, float discount)
        {
            bool success = false;
            Client ClientBill = new Client();
            try
            {
                ClientBill = JsonConvert.DeserializeObject<Client>(jsonClient);
            }
            catch (Exception)
            {
                ClientBill.Dni = dniClient;
            }

            List<Product> products = JsonConvert.DeserializeObject<List<Product>>(json);
            if (products.Count > 0)
            {
                Bill bill = new Bill(DateTime.Today, products, recharge , discount, dniClient);
                
                success = BillsProvider.InsertBill(bill, ClientBill);
            }
            return success;
        }

        public ActionResult CreateBill()
        {
            return View();
        }

        [HttpPost]
        public JsonResult GetProductToEnter(ulong code)
        {
            Product product = ProductsProvider.GetProductByCode(code);
            string JsonDataClient = JsonConvert.SerializeObject(product);
            return Json(JsonDataClient);
        }
        
        public ActionResult Configuration()
        {
            return View();
        }

        public void BillPdf()
        {
            var html = File.ReadAllText(Path.Combine(Directory.GetCurrentDirectory(), "TestInvoice1.html"));

            var pdfPrintOptions = new PdfPrintOptions()
            {
                MarginTop = 50,
                MarginBottom = 50,
                Header = new SimpleHeaderFooter()
                {
                    CenterText = "{pdf-title}",
                    DrawDividerLine = true,
                    FontSize = 16
                },
                Footer = new SimpleHeaderFooter()
                {
                    LeftText = "{date} {time}",
                    RightText = "Page {page} of {total-pages}",
                    DrawDividerLine = true,
                    FontSize = 14
                },
                CssMediaType = PdfPrintOptions.PdfCssMediaType.Print
            };

            var htmlToPdf = new HtmlToPdf(pdfPrintOptions);
            var pdf = htmlToPdf.RenderHtmlAsPdf(html);
            pdf.SaveAs(Path.Combine(Directory.GetCurrentDirectory(), "HtmlToPdfExample2.Pdf"));
        }
    }
}