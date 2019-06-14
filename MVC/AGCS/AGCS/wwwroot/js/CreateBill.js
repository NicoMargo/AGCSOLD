$(document).ready(function () {
    $('#codProdToEnter').keypress(function (event) {
        var keycode = (event.keyCode ? event.keyCode : event.which);
        if (keycode == '13') {
            EnterProduct();
        }
    });
    function EnterProduct() {
        $("#descProdToEnter").empty();
        $("#priceProdToEnter").empty();
        $("#stockProdToEnter").empty();
        $.ajax({
            type: "POST",
            url: urlEnterProduct,
            data: { id: $("#codeProdToEnter").val },
            success: function (DataJsonClient) {
                var Data = JSON.parse(DataJsonClient);
                $("#descProdToEnter").append(Data.Description);
                $("#priceProdToEnter").append(Data.Price);
                $("#stockProdToEnter").append(Data.Stock);
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
            EnterProductToBill();
        }
    });
    function EnterProductToBill() {
        let ProdToEnter = '<tr><td>' + $("#descProdToEnter").text() + '</td>' + '<td><input type="number" id="text-input" placeholder="Cantidad" value="' + $("#quantProdToEnter").val() + '" class="form-control text-black"></td> <td>' + $("#priceProdToEnter").text() + '</td><td>' + $("#stockProdToEnter").text() + '</td><td><img class="w-25" src="/images/boton-x.png" alt="Borrar"></td></tr>';
        $("#tableProducts").prepend(ProdToEnter);
    }

    $(".imageABM").click(function () {
        let Index = $(this).attr("position");
        $.ajax({
            type: "POST",
            url: urlGetOne,
            data: { pos: Index },
            success: function (DataJsonClient) {
                var Data = JSON.parse(DataJsonClient);
                $("#modalSurname").val(Data.Surname);
                $("#modalName").val(Data.Name);
                $("#modalDni").val(Data.Dni);
                $("#modelEmail").val(Data.Email);
                $("#modalTelephone").val(Data.Telephone);
                $("#modalCellphone").val(Data.Cellphone);
                $("#modelTown").val(Data.Town);
                $("#modelAddress").val(Data.Address);
                $("#modelAppartment").val(Data.Leter);
                $("#modelNumber").val(Data.Number);
                $("#modelFloor").val(Data.Floor);
            },
            error: function () {
                alert("ERROR");
            }
        });
    });


    $("#Submit").click(function () {
        $.ajax({
            type: "POST",
            url: urlUpdate,
            data: {
                Surname: $("#modalSurname").val(),
                Name: $("#modalName").val(),
                dni: $("#modalDni").val(),
                email: $("#modelEmail").val(),
                Telephone: $("#modalTelephone").val(),
                Cellphone: $("#modalCellphone").val(),
                Town: $("#modelTown").val(),
                Address: $("#modelAddress").val(),
                Province: 1,
                Leter: $("#modelAppartment").val(),
                Number: $("#modelNumber").val(),
                Floor: $("#modelFloor").val()
            },
            success: function () {
                location.reload();
            },
            error: function () {
                alert("ERROR");
            }
        });
    });

    $(".w-50").click(function () {
        let Index = $(this).attr("position");
        $("#confirm").click(function () {
            $.ajax({
                type: "DELETE",
                url: urlDelete,
                data: { id: Index },
                success: function () {
                    location.reload();
                },
                error: function () {
                    alert("ERROR");
                }
            });
        });
    });

    $("#newClient").click(function () {
        if ($("#modalCreateName").val() !== "" && $("#modalCreateName").val() !== "" && $("#modalCreateDni").val() !== 0) {
            $.ajax({
                type: "POST",
                url: urlCreate,
                data: {
                    Surname: $("#modalCreateSurname").val(),
                    Name: $("#modalCreateName").val(),
                    dni: $("#modalCreateDni").val(),
                    email: $("#modalCreateEmail").val(),
                    Telephone: $("#modalCreateTelephone").val(),
                    Cellphone: $("#modalCreateCellphone").val(),
                    Town: $("#modalCreateTown").val(),
                    Address: $("#modalCreateAddressC").val(),
                    Province: 1,
                    Leter: $("#modelCreateAppartment").val(),
                    Number: $("#modelCreateNumber").val(),
                    Floor: $("#modelCreateFloor").val()
                },
                success: function () {
                    location.reload();
                },
                error: function () {
                    alert("ERROR");
                }
            });
        }
        else {
            if ($("#modalCreateName").val() === "") {
                $("#modalCreateName").addClass("validation_error");
            }
        }
    });
});