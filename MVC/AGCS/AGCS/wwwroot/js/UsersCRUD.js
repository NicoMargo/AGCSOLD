
$(document).ready(function () {   
    var Index;
    RowSearcher("UsersTable", "searchInput");

    $(".imgClientUpdate").click(function () {
        modalNormal("Update");
        Index = $(this).attr("position");
        $.ajax({
            type: "POST",
            url: "/Users/GetDataUser",
            data: { id: Index },
            success: function (DataJsonClient) {
                var Data = JSON.parse(DataJsonClient);
                $("#modalUpdateSurname").val(Data.Surname);
                $("#modalUpdateName").val(Data.Name);
                $("#modalUpdateDni").val(validInt(Data.Dni));
                $("#modalUpdateEmail").val(Data.Email);
                $("#modalUpdateTelephone").val(validInt(Data.Telephone));
                $("#modalUpdateCellphone").val(validInt(Data.Cellphone));
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

    $("#UpdateUser").click(function () {
        modalNormal("Update");
    });

    $("#UpdateSubmit").click(function () {
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
                    id: Index,
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
    let Index = $(this).attr("position");
    $("#confirm").click(function () {
        $.ajax({
            type: "DELETE",
            url: "/Users/DeleteUser",
            data: { id: Index },
            success: function () {
                location.reload();
            },
            error: function () {
                CreateModal("Error", "Error al eliminar el usuario. Reintentar");
            }
        });
    });
});

$("#newUser").click(function () {
    valid = validate("CreateSurname", $("#modalCreateSurname").val() !== "");
    valid = validate("CreateName", $("#modalCreateName").val() !== "") && valid;
    valid = validate("CreateDni", $("#modalCreateDni").val() !== "") && valid;
    valid = validate("CreatePassword", $("#modalCreatePassword").val() !== "") && valid;
    valid = validate("CreateConfirmPassword", $("#modalCreateConfirmPassword").val() !== "") && valid;
    valid = validate("CreateEmail", $("#modalCreateEmail").val() !== "") && valid;
    if ($("#modalCreateConfirmPassword").val() === $("#modalCreatePassword").val()) {
        if (valid) {
            $.ajax({
                type: "POST",
                url: "/Users/CreateUser",
                data: {
                    surname: $("#modalCreateSurname").val(),
                    name: $("#modalCreateName").val(),
                    secondName: $("#modalCreateSecondName").val(),
                    passUser: $("#modalCreatePassword").val(),
                    cPassUser: $("#modalCreateConfirmPassword").val(),
                    dni: $("#modalCreateDni").val(),
                    email: $("#modalCreateEmail").val(),
                    telephone: $("#modalCreateTelephone").val(),
                    cellphone: $("#modalCreateCellphone").val(),
                    address: $("#modalCreateAddress").val(),
                    telephoneM: $("#modalCreateTelephoneMother").val(),
                    telephoneF: $("#modalCreateTelephoneFather").val(),
                    telephoneB: $("#modalCreateTelephoneBrother").val()
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
        else {
            if ($("#modalCreateName").val() === "") {
                $("#modalCreateName").addClass("validation_error");
            }
        }
    } else {
        $("#modalCreateConfirmPassword").addClass("validation_error");
        $("#msgCreatePassword2").removeClass("hidden");
        $("#modalCreatePassword").addClass("validation_error");
        $("#msgCreateConfirmPassword2").removeClass("hidden");
    }
});
});
