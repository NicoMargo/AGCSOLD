﻿
$(document).ready(function () {   
    var modelId;
    RowSearcher("CRUDTable", "searchInput");
    
    $("#add").click(function () {
        let valid = validString(document.getElementById("crtPassConfirm"), ($("#crtPass").find("input").val() == $("#crtPassConfirm").find("input").val()));
        if (validateInputs("modalCrt", "crtInput") && valid) {
            $.ajax({
                type: "POST",
                url: "/Users/CreateUser",
                data: {
                    surname: $("#crtSurname").find("input").val(),
                    name: $("#crtName").find("input").val(),
                    secondName: $("#crtSecond").find("input").val(),
                    mail: $("#crtMail").find("input").val(),
                    passUser: $("#crtPass").find("input").val(),
                    cPassUser: $("#crtPassConfirm").find("input").val(),
                    telephone: $("#crtTelephone").find("input").val(),
                    cellphone: $("#crtCellphone").find("input").val(),
                    dni: $("#crtDni").find("input").val(),
                    address: $("#crtAddress").find("input").val(),
                    telephoneM: $("#crtTelM").find("input").val(),
                    telephoneF: $("#crtTelF").find("input").val(),
                    telephoneB: $("#crtTelB").find("input").val()
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
            success: function (DataJson) {
                var Data = JSON.parse(DataJson);
                $("#updtSurname").find("input").val(Data.Surname);
                $("#updtName").find("input").val(Data.Name);
                $("#updtSecond").find("input").val(Data.SecondName);
                $("#updtDni").find("input").val(checkInt(Data.Dni));
                $("#updtMail").find("input").val(Data.Mail);
                $("#updtTelephone").find("input").val(checkInt(Data.Telephone));
                $("#updtCellphone").find("input").val(checkInt(Data.Cellphone));
                $("#updtAddress").find("input").val(Data.Address);
                $("#updtTelM").find("input").val(Data.TelephoneM);
                $("#updtTelF").find("input").val(Data.TelephoneF);
                $("#updtTelB").find("input").val(Data.TelephoneB);
            },
            error: function () {
                CreateModal("Error", "Hubo un error al buscar los datos del cliente");
            }
        });
    });

    $("#update").click(function () {
        if (validateInputs("modalUpdt", "updtInput") ){
            $.ajax({
                type: "POST",
                url: "/Users/UpdateUser",
                data: {
                    id: modelId,
                    surname: $("#updtSurname").find("input").val(),
                    name: $("#updtName").find("input").val(),
                    secondName: $("#updtSecond").find("input").val(),
                    dni: parseInt($("#updtDni").find("input").val()),
                    mail: $("#updtMail").find("input").val(),
                    telephone: $("#updtTelephone").find("input").val(),
                    cellphone: $("#updtCellphone").find("input").val(),
                    address: $("#updtAddress").find("input").val(),
                    telephoneM: $("#updtTelM").find("input").val(),
                    telephoneF: $("#updtTelF").find("input").val(),
                    telephoneB: $("#updtTelB").find("input").val(),
                },
                success: function (code) {
                    if (code == 1) {
                        location.reload();
                    }
                    else if (code == 2) {
                        CreateModal("Datos no validos", "Ya existe un usuario con ese Mail");
                    } else {
                        CreateModal("Error", "Falla al registrar el usuario. Reintentar");
                    }
                },
                error: function () {
                    CreateModal("Error", "Falla al registrar el usuario. Reintentar");
                }

            });
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
