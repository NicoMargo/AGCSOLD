$(document).ready(function () {
    var modelId;
    RowSearcher("CRUDTable", "searchInput");

    $("#btnModalCrt").click(function () {
        normalizeInputs("modalCrt", "crtInput");
    });

    $("#add").click(function () {
        if (validateInputs("modalCrt", "crtInput")) {
            $.ajax({
                type: "POST",
                url: "/Clients/CreateClient",
                data: {
                    surname: $("#crtSurname").find("input").val(),
                    name: $("#crtName").find("input").val(),
                    dni: parseInt($("#crtDni").find("input").val()),
                    email: $("#crtEmail").find("input").val(),
                    telephone: parseInt($("#crtTelephone").find("input").val()),
                    cellphone: parseInt($("#crtCellphone").find("input").val())
                    /*
                    town: $("#modalCreateTown").val(),
                    address: $("#modalCreateAddressC").val(),
                    province: 1,
                    leter: $("#modalCreateAppartment").val(),
                    number: $("#modalCreateNumber").val(),
                    floor: $("#modalCreateFloor").val()*/
                },
                success: function () {
                    location.reload();
                },
                error: function () {
                    CreateModal("Error", "Hubo un error al crear el cliente");
                }
            });
        }
    });

    $("updateButton").click(function () {
        normalizeInputs("modalUpdt", "updtInput");
        modelId = $(this).attr("modelId");
        $.ajax({
            type: "POST",
            url: "/Clients/GetDataClient",
            data: { id: modelId },
            success: function (DataJsonClient) {
                var Data = JSON.parse(DataJsonClient);
                $("#updtSurname").find("input").val(Data.Surname);
                $("#updtName").find("input").val(Data.Name);
                $("#updtDni").find("input").val(checkInt(Data.Dni));
                $("#updtEmail").find("input").val(Data.Email);
                $("#updtTelephone").find("input").val(checkInt(Data.Telephone));
                $("#updtCellphone").find("input").val(checkInt(Data.Cellphone));
                /*
                $("#modalUpdateTown").val(Data.Town);
                $("#modalUpdateAddress").val(Data.Address);
                $("#modalUpdateAppartment").val(Data.Leter);
                $("#modalUpdateNumber").val(Data.Number);
                $("#modalUpdateFloor").val(Data.Floor);*/
            },
            error: function () {
                CreateModal("Error", "Hubo un error al buscar los datos del cliente");
            }
        });
    });


    $("#update").click(function () {
        if (validateInputs("modalUpdt", "updtInput")) {
            $.ajax({
                type: "POST",
                url: "/Clients/UpdateClient",
                data: {
                    id: modelId,
                    surname: $("#updtSurname").find("input").val(),
                    name: $("#updtName").find("input").val(),
                    dni: parseInt($("#updtDni").find("input").val()),
                    email: $("#updtEmail").find("input").val(),
                    telephone: parseInt($("#updtTelephone").find("input").val()),
                    cellphone: parseInt($("#updtCellphone").find("input").val())/*,
                    Town: $("#modalUpdateTown").val(),
                    Address: $("#modalUpdateAddress").val(),
                    Province: 1,
                    Leter: $("#modalUpdateAppartment").val(),
                    Number: $("#modalUpdateNumber").val(),
                    Floor: $("#modalUpdateFloor").val()*/
                },
                success: function () {
                    location.reload();
                },
                error: function () {
                    CreateModal("Error", "Hubo un error al buscar los datos del cliente");
                }
            });
        }
    });

    $("deleteButton").click(function () {
        modelId = $(this).attr("modelId");
        $("#confirm").click(function () {
            $.ajax({
                type: "DELETE",
                url: "/Clients/DeleteClient",
                data: { id: modelId },
                success: function () {
                    location.reload();
                },
                error: function () {
                    CreateModal("Error", "Hubo un error al eliminar al cliente");
                }
            });
        });
    });

    
});