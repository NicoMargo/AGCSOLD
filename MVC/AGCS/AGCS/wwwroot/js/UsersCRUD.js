
$(document).ready(function () {   
    var modelId;
    RowSearcher("CRUDTable", "searchInput");
    
    $("#add").click(function () {
        let valid = validString(document.getElementById("crtPassConfirm"), ($("#crtPass").find("input").val() === $("#crtPassConfirm").find("input").val()));
        if (validateInputs("modalCrt", "crtInput") && valid) {
            $.ajax({
                type: "POST",
                url: "/Users/CreateUser",
                data: {
                    surname: $("#crtSurname").find("input").val(),
                    name: $("#crtName").find("input").val(),
                    secondName: $("#crtSecond").find("input").val(),
                    email: $("#crtEmail").find("input").val(),
                    passUser: $("#crtPass").find("input").val(),
                    cPassUser: $("#crtPassConfirm").find("input").val(),
                    telephone: parseInt($("#crtTelephone").find("input").val()),
                    cellphone: parseInt($("#crtCellphone").find("input").val()),
                    dni: parseInt($("#crtDni").find("input").val()),
                    address: $("#crtAddress").find("input").val(),
                    telephoneM: parseInt($("#crtTelM").find("input").val()),
                    telephoneF: parseInt($("#crtTelF").find("input").val()),
                    telephoneB: parseInt($("#crtTelB").find("input").val())
                },
                success: function (success) {
                    if (success == "True")
                        location.reload();
                    else {
                        CreateModal("Error", "Error al crear el usuario. Reintentar");
                    }
                },
                error: function () {
                    CreateModal("Error", "Error al crear el usuario. Reintentar");
                }
            });
        }
    });

    $("updateButton").click(function () {
        normalizeInputs("modalUpdt", "updtInput");
        modelId = $(this).attr("modelId");
        $.ajax({
            type: "POST",
            url: "/Users/GetDataUser",
            data: { id: modelId },
            success: function (DataJsonClient) {
                var Data = JSON.parse(DataJsonClient);
                $("#modalUpdateSurname").val(Data.Surname);
                $("#modalUpdateName").val(Data.Name);
                $("#modalUpdateDni").val(checkInt(Data.Dni));
                $("#modalUpdateEmail").val(Data.Email);
                $("#modalUpdateTelephone").val(checkInt(Data.Telephone));
                $("#modalUpdateCellphone").val(checkInt(Data.Cellphone));
                $("#modalUpdateTelephoneMother").val(Data.TelephoneM);
                $("#modalUpdateTelephoneFather").val(Data.TelephoneF);
                $("#modalUpdateTelephoneBrother").val(Data.TelephoneB);
                $("#modalUpdateAddress").val(Data.Address);
                $("#modalUpdateSecondName").val(Data.SecondName);
            },
            error: function () {
                CreateModal("Error", "Hubo un error al buscar los datos del cliente");
            }
        });
    });

    $("#update").click(function () {
        valid = validate("UpdateSurname", $("#modalUpdateSurname").val() !== "");
        valid = validate("UpdateName", $("#modalUpdateName").val() !== "") && valid;
        valid = validate("UpdateDni", $("#modalUpdateDni").val() !== "") && valid;
        valid = validate("UpdatePassword", $("#modalUpdatePassword").val() !== "") && valid;
        valid = validate("UpdateConfirmPassword", $("#modalUpdateConfirmPassword").val() !== "") && valid;
        valid = validate("UpdateEmail", $("#modalUpdateEmail").val() !== "") && valid;

        if (valid) {
            $.ajax({
                type: "POST",
                url: "/Users/UpdateUser",
                data: {
                    id: modelId,
                    surname: $("#modalUpdateSurname").val(),
                    name: $("#modalUpdateName").val(),
                    secondName: $("#modalUpdateSecondName").val(),
                    dni: $("#modalUpdateDni").val(),
                    email: $("#modalUpdateEmail").val(),
                    telephone: $("#modalUpdateTelephone").val(),
                    cellphone: $("#modalUpdateCellphone").val(),
                    address: $("#modalUpdateAddress").val(),
                    telephoneM: $("#modalUpdateTelephoneMother").val(),
                    telephoneF: $("#modalUpdateTelephoneFather").val(),
                    telephoneB: $("#modalUpdateTelephoneBrother").val()
                },
                success: function (success) {
                    if (success) {
                        location.reload();
                    }
                    else {
                        CreateModal("Datos no validos", "Ya existe un usuario con ese email o Dni");
                    }
                },
                error: function () {
                    CreateModal("Error", "Falla al registrar el usuario. Reintentar");
                }

            });
        }
        else {
            if ($("#modalUpdateName").val() === "") {
                $("#modalUpdateName").addClass("validation_error");
            }
        }
    });


    $("deleteButton").click(function () {
        let modelId = $(this).attr("modelId");
        $("#confirm").click(function () {
            $.ajax({
                type: "DELETE",
                url: "/Users/DeleteUser",
                data: { id: modelId },
                success: function () {
                    location.reload();
                },
                error: function () {
                    CreateModal("Error", "Error al eliminar el usuario. Reintentar");
                }
            });
        });
    });

});
