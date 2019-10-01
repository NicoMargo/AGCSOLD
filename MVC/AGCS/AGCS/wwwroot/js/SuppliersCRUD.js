$(document).ready(function () {
    var modelId;
    RowSearcher("CRUDTable", "searchInput")

    $("#btnModalCrt").click(function () {
        normalizeInputs("modalCrt", "crtInput");
    });

    $("#add").click(function () {
        if (validateInputs("modalCrt", "crtInput")) {
            $.ajax({
                type: "POST",
                url: "/Suppliers/CreateSupplier",
                data: {
                    surname: $("#crtSurname").find("input").val(),
                    name: $("#crtName").find("input").val(),
                    mail: $("#crtMail").find("input").val(),
                    telephone: parseInt($("#crtTelephone").find("input").val()),
                    cellphone: parseInt($("#crtCellphone").find("input").val()),
                    factory: $("#crtFactory").find("input").val(),
                    address: $("#crtAddress").find("input").val()
                },
                success: function () {
                    location.reload();
                },
                error: function () {
                    CreateModal("Error", "Hubo un error al crear el proveedor");
                }
            });
        }
    });

    $("updateButton").click(function () {
        normalizeInputs("modalUpdt", "updtInput");
        modelId = $(this).attr("modelId");
        $.ajax({
            type: "POST",
            url: "/Suppliers/GetDataSupplier",
            data: { id: modelId },
            success: function (DataJson) {
                var Data = JSON.parse(DataJson);
                $("#updtSurname").find("input").val(Data.Surname);
                $("#updtName").find("input").val(Data.Name);
                $("#updtMail").find("input").val(Data.Mail);
                $("#updtTelephone").find("input").val(checkInt(Data.Telephone));
                $("#updtCellphone").find("input").val(checkInt(Data.Cellphone));
                $("#updtFactory").find("input").val(Data.Factory);
                $("#updtAddress").find("input").val(Data.Address);
            },
            error: function () {
                CreateModal("Error", "Hubo un error al buscar los datos del proveedor");
            }
        });
    });


    $("#update").click(function () {
        if (validateInputs("modalUpdt", "updtInput")) {
            $.ajax({
                type: "POST",
                url: "/Suppliers/UpdateSupplier",
                data: {
                    id: modelId,
                    surname: $("#updtSurname").find("input").val(),
                    name: $("#updtName").find("input").val(),
                    mail: $("#updtMail").find("input").val(),
                    telephone: parseInt($("#updtTelephone").find("input").val()),
                    cellphone: parseInt($("#updtCellphone").find("input").val()),
                    factory: $("#updtFactory").find("input").val(),
                    address: $("#updtAddress").find("input").val()
                },
                success: function () {
                    location.reload();
                },
                error: function () {
                    CreateModal("Error", "Hubo un error al buscar los datos del proveedor");
                }
            });
        }
    });

    $("deleteButton").click(function () {
        modelId = $(this).attr("modelId");
        $("#confirm").click(function () {
            $.ajax({
                type: "DELETE",
                url: "/Suppliers/DeleteSupplier",
                data: { id: modelId },
                success: function () {
                    location.reload();
                },
                error: function () {
                    CreateModal("Error", "Hubo un error al eliminar al proveedor");
                }
            });
        });
    });

    
});