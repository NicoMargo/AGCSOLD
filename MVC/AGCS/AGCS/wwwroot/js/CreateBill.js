$(document).ready(function () {
    var idOfProd, D, T = 0, Items = [],p;
    var Product = { Id: null, Quant: null, iva: 1, Price: null };
   
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
            data: { id: $("#codProdToEnter").val() },
            success: function (DataJsonClient) {
                D = JSON.parse(DataJsonClient);
                idOfProd = D.Id;
                $("#descProdToEnter").append(D.Description);
                $("#priceProdToEnter").append(D.Price);
                $("#stockProdToEnter").append(D.Stock);
                $("#quantProdToEnter").focus();
            },
            error: function () {
                alert("ERROR");
            }
        });
    }
    $("#codProdToEnter").focus();
    function validInt(number) {
        if (number <= 0) {
            number = "";
        }
        return number;
    }
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
           let success = false,i = 0;
            do {
                if (Items[i].Id === idOfProd) {
                    T -= (Items[i].Price * Items[i].Quant);
                    if (!isNaN(parseInt($("#q" + idOfProd).val(), 10))) {
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
        });




        $('input[this="quant"]').keyup(function (event) {
            let keycode = (event.keyCode ? event.keyCode : event.which);
            if (((keycode > 47 && keycode < 58) || (keycode > 95 && keycode < 106)) || keycode == 8) {
                let thisId = parseInt($(event.target).attr("id").substr(1),10), i = 0, success = false;
                do {
                    if (Items[i].Id === thisId) {
                        T -= (Items[i].Price * Items[i].Quant);                       
                        if (!isNaN(parseInt($("#q" + thisId).val(), 10))){
                            Items[i].Quant = parseInt($("#q" + thisId).val(), 10);
                        } else{
                                Items[i].Quant = 0;
                            }
                         T += (Items[i].Price * Items[i].Quant)
                        success = true;
                    }
                    i++;
                } while (!success);
                $("#total").empty();
                $("#total").append(T);
            }
        });
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
            let data = parseInt($("#codProdToEnter").val(),10), success = false, i = 0;
            document.getElementById("q" + idOfProd).value = parseInt($("#quantProdToEnter").val(), 10) + parseInt($("#q" + idOfProd).val(), 10);
            do {
                if (Items[i].Id === data) {        
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
            Items.push(Product);
            var ProdToEnter = '<tr id="' + idOfProd + '"><td>' + D.Description + '</td>' + '<td><input type="number" this="quant" id="q' + idOfProd + '" placeholder="Cantidad" min="1" value="' + $("#quantProdToEnter").val() + '" class="form-control text-black"></td> <td>' + D.Price + '</td><td>' + D.Stock + '</td><td><deleteButton id="db' + idOfProd+'"  position="' + idOfProd + '"> <img data-target="#confirmationModal" data-toggle="modal" class="w-25" src="/images/boton-x.png" alt="Borrar"/></deleteButton></td></tr>';
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
    $("#b").click(function () {
        if ($("#dni").val() != null) {
            let C = { Dni: $("#dni").val(), Name: null, Surname: null, Cellphone: null };
            var attr = $('#thisName').attr('disabled');
            if (attr == undefined) {
                C.Name = $("#thisName").val();
                C.Surname = $("#surname").val();
                C.Cellphone = $("#cellphone").val();
            }
            if (Items.length > 0) {
                $.ajax({
                    type: "POST",
                    url: "/Backend/NewBill",
                    data: {
                        json: JSON.stringify(Items), dniClient: $("#dni").val(), jsonClient: JSON.stringify(C)
                    },
                    success: function (success) {
                        if (success) {
                            alert("se facturó");
                        } else {
                            alert("hubo un error");
                        }
                    },
                    error: function () {
                        alert("ERROR");
                    }
                });
            } else {
                alert("ingrese datos a facturar");
            }
        } else {

            var validate = false;
            var attr = $('#thisName').attr('disabled');
            var attr2 = $('#thisName').attr('disabled');
            var attr3 = $('#surname').attr('disabled');
            var attr4 = $('#cellphone').attr('disabled');
            if (Attr == undefined || Attr3 == undefined || Attr4 == undefined || attr2 == undefined) {
           
                alert("ingrese todo los datos del cliente");
            } else {
                alert("ingrese cliente");
            }
            
        }
    });

    $("#dni").keyup(function () {
        $.ajax({
        type: "POST",
        url: "/Backend/GetDataClientByDNI",
        data: { dni: $("#dni").val() },
        success: function (DataJsonClient) {
            var Data = JSON.parse(DataJsonClient);
            if (Data != null) {
                $("#surname").attr('disabled', true);
                $("#thisName").attr('disabled', true);
                $("#cellphone").attr('disabled', true);
                $("#surname").val(Data.Surname);
                $("#thisName").val(Data.Name);
                $("#cellphone").val(validInt(Data.Cellphone));
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
            alert("ERROR");
         }
         });       
    });
});