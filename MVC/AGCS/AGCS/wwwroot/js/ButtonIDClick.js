$(document).ready(function () {
    $(".imageABM").click(function () {
        let Index = $(this).attr("position");
        $.ajax({
            type: "POST",
            url: "/Backend/GetDataClient",
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
            url: "/Backend/UpdateClient",
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
                url: "/Backend/DeleteClient",
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
                url: "/Backend/CreateClient",
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