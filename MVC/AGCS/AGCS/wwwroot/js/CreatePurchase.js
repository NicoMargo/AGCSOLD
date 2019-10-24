﻿$(document).ready(function () {
    var idProduct, product, total = 0, Items = [], p;
    var Product = { Id: null, Quant: null, iva: 1, Price: null, Code: null, Cost: null };

    $('#codProdToEnter').keypress(function (event) {
        var keycode = (event.keyCode ? event.keyCode : event.which);
        if (keycode == '13') {
            if ($("#codProdToEnter").val().length > 0) {
                $("#codProdToEnter").css({ 'border-color': '#ced4da' });
                EnterProduct();
            } else {
                $("#codProdToEnter").css({ "border": " 0.15rem solid red" });
            }
        }
    });
    function EnterProduct() {
        $("#descProdToEnter").empty();
        $("#costProdToEnter").empty();
        $("#stockProdToEnter").empty();
        $.ajax({
            type: "POST",
            url: "../../Purchases/GetProduct",
            data: {
                code: $("#codProdToEnter").val(),
                idSupplier: sdi
            },
            success: function (DataJson) {
                product = JSON.parse(DataJson);
                if (product != null) {
                    idProduct = product.Id;
                    $("#descProdToEnter").append(product.Description);
                    $("#costProdToEnter").val(product.Cost);
                    $("#stockProdToEnter").append(product.Stock);
                    $("#quantProdToEnter").focus();
                } else {
                    CreateModal("Error de Producto","No existe el producto o no corresponde con el proveedor");
                }
            },
            error: function () {
                CreateModal("Error", "Hubo un error al buscar el producto");
            }
        });
    }
    $("#codProdToEnter").focus();   
    
    $('.loadToList').keypress(function (event) {
        var keycode = (event.keyCode ? event.keyCode : event.which);
        if (keycode == '13') {
            if (product != null) {
                if ($("#quantProdToEnter").val().length > 0 && $("#quantProdToEnter").val() > 0) {
                    if ($("#codProdToEnter").val().length > 0) {
                        $("#quantProdToEnter").css({ 'border-color': '#ced4da' });
                        LoadProductToList();
                    } else {
                        $("#codProdToEnter").css({ "border": " 0.15rem solid red" });
                    }
                } else {
                    $("#quantProdToEnter").css({ "border": " 0.15rem solid red" });
                }

            }
        }
    });

    function KeyPressEventQuant(idProduct) {

        $("#q" + idProduct).click(function () {
            fT(idProduct);
            validateQ(idProduct);
        });
        
        $("#q" + idProduct).keyup(function (event) {
            let keycode = (event.keyCode ? event.keyCode : event.which);
            if (((keycode > 47 && keycode < 58) || (keycode > 95 && keycode < 106)) || keycode == 8) {
                fT(idProduct);
            }
            validateQ(idProduct);
        });
        

    }
    
    function fT(idProduct) {
        let success = false, i = 0;
        do {
            if (Items[i].Id === idProduct) {
                total -= (Items[i].Cost * Items[i].Quant);
                if ((!isNaN(parseInt($("#q" + idProduct).val(), 10))) && parseInt($("#q" + idProduct).val(), 10) >= 0) {
                    Items[i].Quant = parseInt($("#q" + idProduct).val(), 10);
                } else {
                    Items[i].Quant = 0;
                }
                total += (Items[i].Cost * Items[i].Quant);
                success = true;
            }
            i++;
        } while (!success);
        $("#total").empty();
        $("#total").append(total);
    }
    $("#confirm").click(function () {
        let success = false, i = 0;
        do {
            if (Items[i].Id == p) {
                total -= (Items[i].Cost * Items[i].Quant);
                Items.splice(i, 1);
                success = true;
                $('#' + p).remove();
                $("#total").empty();
                $("#total").append(total);
            }
            i++;
        } while (!success);
    });
    function ClickeventImg(id) {
        $("#db" + id).click(function () {
            p = $(this).attr("position");

        });
    }
    function LoadProductToList() {
        $("#total").empty();
        total += product.Price * parseInt($("#quantProdToEnter").val(), 10);
        $("#total").append(total);
        if ($("#" + idProduct).length > 0) {
            let data = $("#codProdToEnter").val(), success = false, i = 0;
            document.getElementById("q" + idProduct).value = parseInt($("#quantProdToEnter").val(), 10) + parseInt($("#q" + idProduct).val(), 10);
            do {
                if (Items[i].Code == data) {
                    Items[i].Quant += parseInt($("#quantProdToEnter").val(), 10);
                    Items[i].Cost = parseInt($("#costProdToEnter").val(), 10);
                    success = true;
                }
                i++;
            } while (!success);
        } else {
            Product = new Object();
            Product.Id = product.Id;
            Product.Price = product.Price;
            Product.Quant = parseInt($("#quantProdToEnter").val());
            Product.Code = product.Code;
            Product.Cost = parseInt($("#costProdToEnter").val());
            Items.push(Product);
            var ProdToEnter = '<tr id="' + idProduct + '"><td>' + product.Description + '</td>' + '<td><input type="number" this="quant" id="q' + idProduct + '" placeholder="Cantidad" min="1" value="' + $("#quantProdToEnter").val() + '" class="form-control text-black"></td> <td>' + $("#costProdToEnter").val() + '</td><td>' + product.Stock + '</td><td><deleteButton id="db' + idProduct + '"  position="' + idProduct + '"> <img data-target="#confirmationModal" data-toggle="modal" class="w-25" src="/images/boton-x.png" alt="Borrar"/></deleteButton></td></tr>';
            ProdToEnter.keypress;
            $("#tableProducts").prepend(ProdToEnter);
            KeyPressEventQuant(idProduct);
            ClickeventImg(idProduct);
        }
        $("#quantProdToEnter").val("");
        $("#codProdToEnter").val("");
        $("#descProdToEnter").empty();
        $("#costProdToEnter").val("");
        $("#stockProdToEnter").empty();
        $("#codProdToEnter").focus();
    }

    function validateQuant() {
        let successVQ = true;
        for (let y = 0; y < Items.length; y++) {
            if ($("#q" + Items[y].Id).val() <= 0 || isNaN(parseInt($("#q" + idProduct).val(), 10))) {
                successVQ = false;
            }
        }
        return successVQ;
    }

    $("#b").click(function () {
        if (validateQuant()) {
                if (Items.length > 0) {                    
                    $.ajax({
                        type: "POST",
                        url: "/Purchases/NewPurchase",
                        data: {
                            json: JSON.stringify(Items),
                            sdi: sdi
                        },
                        success: function (success) {
                            if (success) {
                                CreateModal("Compra", "Se agregó la compra correctamente");
                            } else {
                                CreateModal("Error", "Hubo un error al agregar la compra");
                            }
                        },
                        error: function () {
                            CreateModal("Error de compra", "Hubo un error al agregar la compra");
                        }
                    });
                } else {
                    CreateModal("Datos Invalidos", "Ingrese al menos un producto");
                }

        } else {
            CreateModal("Error", "Cantidades Erroneas");
        }
    });
    function validateQ(id) {
        var State = false;
        if (parseInt($("#q" + id).val(), 10) <= 0 || isNaN(parseInt($("#q" + id).val(), 10)) ) {
            $("#q" + id).css("border-color", "#FF0000");
        }
        else {
            $("#q" + id).css("border-color", "#ced4da");
            State = true;
        }
        return State;
    }
});