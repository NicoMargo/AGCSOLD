$(document).ready(function () {
    var idOfProd, D, T = 0, Items = [];
    var Product = { id: null, quant: null, iva: null };
    $("#codProdToEnter").focus();
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
    $('#quantProdToEnter').keypress(function (event) {
        var keycode = (event.keyCode ? event.keyCode : event.which);
        if (keycode == '13') {
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
    });

    function KeyPressEvent() {
        $('input[this="quant"]').keydown(function (event) {

        });
    }

    function EnterProductToBill() {
        Product.Id = D.id;
        Product.Quant = parseInt($("#quantProdToEnter").val());
        Items.push(Product);
        $("#total").empty();
        T += D.Price * parseInt($("#quantProdToEnter").val(), 10);
        $("#total").append(T);
        if ($("#" + idOfProd).length > 0) {
            document.getElementById("q" + idOfProd).value = parseInt($("#quantProdToEnter").val(), 10) + parseInt($("#q" + idOfProd).val(), 10);

        } else {
            var ProdToEnter = '<tr id="' + idOfProd + '"><td>' + D.Description + '</td>' + '<td><input type="number" this="quant" id="q' + idOfProd + '" placeholder="Cantidad" value="' + $("#quantProdToEnter").val() + '" class="form-control text-black"></td> <td>' + D.Price + '</td><td>' + D.Stock + '</td><td><img id="e' + idOfProd + '" class="w-25" src="/images/boton-x.png" alt="Borrar"></td></tr>';
            ProdToEnter.keypress;
            $("#tableProducts").prepend(ProdToEnter);
            KeyPressEvent();
        }
        $("#quantProdToEnter").val("");
        $("#codProdToEnter").val("");
        $("#descProdToEnter").empty();
        $("#priceProdToEnter").empty();
        $("#stockProdToEnter").empty();
        $("#codProdToEnter").focus();
    }
    $("#b").click(function () {
        console.log(Items);
        $.ajax({
            type: "POST",
            url: "/Backend/NewBill",
            data: JSON.stringify(Items),
            success: function () {

            },
            error: function () {
                alert("ERROR");
            }
        });
    });
});