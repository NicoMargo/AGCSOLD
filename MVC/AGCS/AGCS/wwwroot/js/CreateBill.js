$(document).ready(function () {
    var idOfProd, D, T = 0, Items = [], p;
    var Product = { Id: null, Quant: null, iva: 1, Price: null, Code: null };

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
        $("#priceProdToEnter").empty();
        $("#stockProdToEnter").empty();
        $.ajax({
            type: "POST",
            url: "/Backend/GetProductToEnter",
            data: { code: $("#codProdToEnter").val() },
            success: function (DataJson) {
                D = JSON.parse(DataJson);
                if (D != null) {
                    idOfProd = D.Id;
                    $("#descProdToEnter").append(D.Description);
                    $("#priceProdToEnter").append(D.Price);
                    $("#stockProdToEnter").append(D.Stock);
                    $("#quantProdToEnter").focus();
                } else {
                    CreateModal("Error de Producto", "No existe el producto");
                }
            },
            error: function () {
                CreateModal("Error", "Hubo un error al buscar el producto");
            }
        });
    }
    $("#codProdToEnter").focus();

    $('#quantProdToEnter').keypress(function (event) {
        var keycode = (event.keyCode ? event.keyCode : event.which);
        if (keycode == '13') {
            if (D != null) {
                if ($("#quantProdToEnter").val().length > 0 && $("#quantProdToEnter").val() > 0) {
                    if ($("#codProdToEnter").val().length > 0) {
                        $("#quantProdToEnter").css({ 'border-color': '#ced4da' });
                        EnterProductToBill();
                    } else {
                        $("#codProdToEnter").css({ "border": " 0.15rem solid red" });
                    }
                } else {
                    $("#quantProdToEnter").css({ "border": " 0.15rem solid red" });
                }

            }
        }
    });

    function KeyPressEventQuant(idOfProd) {

        $("#q" + idOfProd).click(function () {
            fT(idOfProd);
            validateQ(idOfProd);
        });

        $("#q" + idOfProd).keyup(function (event) {
            let keycode = (event.keyCode ? event.keyCode : event.which);
            if (((keycode > 47 && keycode < 58) || (keycode > 95 && keycode < 106)) || keycode == 8) {
                fT(idOfProd);
            }
            validateQ(idOfProd);
        });


    }

    function fT(idOfProd) {
        let success = false, i = 0;
        do {
            if (Items[i].Id === idOfProd) {
                T -= (Items[i].Price * Items[i].Quant);
                if ((!isNaN(parseInt($("#q" + idOfProd).val(), 10))) && parseInt($("#q" + idOfProd).val(), 10) >= 0) {
                    Items[i].Quant = parseInt($("#q" + idOfProd).val(), 10);
                } else {
                    Items[i].Quant = 0;
                }
                T += (Items[i].Price * Items[i].Quant);
                success = true;
            }
            i++;
        } while (!success);
        $("#total").empty();
        $("#total").append(T);
    }
    $("#confirm").click(function () {
        let success = false, i = 0;
        do {
            if (Items[i].Id == p) {
                T -= (Items[i].Price * Items[i].Quant);
                Items.splice(i, 1);
                success = true;
                $('#' + p).remove();
                $("#total").empty();
                $("#total").append(T);
            }
            i++;
        } while (!success);
    });
    function ClickeventImg(id) {
        $("#db" + id).click(function () {
            p = $(this).attr("position");

        });
    }
    function EnterProductToBill() {

        $("#total").empty();
        T += D.Price * parseInt($("#quantProdToEnter").val(), 10);
        $("#total").append(T);
        if ($("#" + idOfProd).length > 0) {
            let data = $("#codProdToEnter").val(), success = false, i = 0;
            document.getElementById("q" + idOfProd).value = parseInt($("#quantProdToEnter").val(), 10) + parseInt($("#q" + idOfProd).val(), 10);
            do {
                if (Items[i].Code == data) {
                    Items[i].Quant += parseInt($("#quantProdToEnter").val(), 10);
                    success = true;
                }
                i++;
            } while (!success);
        } else {
            Product = new Object();
            Product.Id = D.Id;
            Product.Price = D.Price;
            Product.Quant = parseInt($("#quantProdToEnter").val());
            Product.Code = D.Code;
            Items.push(Product);
            var ProdToEnter = '<tr id="' + idOfProd + '"><td>' + D.Description + '</td>' + '<td><input type="number" this="quant" id="q' + idOfProd + '" placeholder="Cantidad" min="1" value="' + $("#quantProdToEnter").val() + '" class="form-control text-black"></td> <td>' + D.Price + '</td><td>' + D.Stock + '</td><td><deleteButton id="db' + idOfProd + '"  position="' + idOfProd + '"> <img data-target="#confirmationModal" data-toggle="modal" class="w-25" src="/images/boton-x.png" alt="Borrar"/></deleteButton></td></tr>';
            ProdToEnter.keypress;
            $("#tableProducts").prepend(ProdToEnter);
            KeyPressEventQuant(idOfProd);
            ClickeventImg(idOfProd);
        }
        $("#quantProdToEnter").val("");
        $("#codProdToEnter").val("");
        $("#descProdToEnter").empty();
        $("#priceProdToEnter").empty();
        $("#stockProdToEnter").empty();
        $("#codProdToEnter").focus();
    }

    function validateQuant() {
        let successVQ = true;
        for (let y = 0; y < Items.length; y++) {
            if ($("#q" + Items[y].Id).val() <= 0 || isNaN(parseInt($("#q" + idOfProd).val(), 10))) {
                successVQ = false;
            }
        }
        return successVQ;
    }

    $("#b").click(function () {
        if (validateQuant()) {
            var bool = validate("#thisName");
            bool = bool & validate("#surname");
            bool = bool & validate("#dni");
            if (parseInt($("#dni").val(), 10) <= 0) {
                bool = false;
            }
            if (bool) {
                if (Items.length > 0) {
                    let C = { Dni: $("#dni").val(), Name: null, Surname: null, Cellphone: null };
                    if ($('#thisName').attr('disabled') === undefined) {
                        C.Name = $("#thisName").val();
                        C.Surname = $("#surname").val();
                        C.Cellphone = $("#cellphone").val();
                    }

                    $.ajax({
                        type: "POST",
                        url: "/Backend/NewBill",
                        data: {
                            json: JSON.stringify(Items), dniClient: $("#dni").val(), jsonClient: JSON.stringify(C)
                        },
                        success: function (success) {
                            if (success) {
                                CreateModal("Factura", "Se facturo correctamente", true);
                            } else {
                                CreateModal("Error", "Hubo un error al Facturar");
                            }
                        },
                        error: function () {
                            CreateModal("Error", "Hubo un error al Facturar");
                        }
                    });
                } else {
                    CreateModal("Error", "Ingrese los datos a Facturar");
                }
            } else
                CreateModal("Error", "Ingrese Todos los datos del cliente");
        } else {
            CreateModal("Error", "Cantidades Erroneas");
        }
    });
    function validateQ(id) {
        var State = false;
        if (parseInt($("#q" + id).val(), 10) <= 0 || isNaN(parseInt($("#q" + id).val(), 10))) {
            $("#q" + id).css("border-color", "#FF0000");
        }
        else {
            $("#q" + id).css("border-color", "#ced4da");
            State = true;
        }
        return State;
    }
    function validate(id) {
        var State = false;
        if ($(id).val() == "") {
            $(id).css("border-color", "#FF0000");
        }
        else {
            $(id).css("border-color", "#ced4da");
            State = true;
        }
        return State;
    }
    $("#dni").keyup(function () {
        if ($("#dni").val().length > 0) {
            if ($("#dni").val() == 1 || $("#dni").val().length > 5) {
                $.ajax({
                    type: "POST",
                    url: "/Clients/GetDataClientByDNI",
                    data: { dni: $("#dni").val() },
                    success: function (DataJson) {
                        var Data = JSON.parse(DataJson);
                        if (Data != null) {
                            $("#surname").attr('disabled', true);
                            $("#thisName").attr('disabled', true);
                            $("#cellphone").attr('disabled', true);
                            $("#surname").val(Data.Surname);
                            $("#thisName").val(Data.Name);
                            $("#cellphone").val(checkInt(Data.Cellphone));
                        } else {
                            $("#surname").attr('disabled', false);
                            $("#thisName").attr('disabled', false);
                            $("#cellphone").attr('disabled', false);
                            $("#surname").val("");
                            $("#thisName").val("");
                            $("#cellphone").val("");
                        }

                    },
                    error: function () {
                        CreateModal("Error", "Hubo un error al buscar el cliente");
                    }
                });
            }
        } else {
            $("#surname").attr('disabled', false);
            $("#thisName").attr('disabled', false);
            $("#cellphone").attr('disabled', false);
            $("#surname").val("");
            $("#thisName").val("");
            $("#cellphone").val("");
        }
    });
});