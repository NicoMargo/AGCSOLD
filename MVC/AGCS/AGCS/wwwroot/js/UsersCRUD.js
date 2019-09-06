
$(document).ready(function () {
    function validate(id, expectedCondition = true) {
        if (!expectedCondition) {
            $("#modal" + id).addClass("validation_error");
            $("#msg" + id).removeClass("hidden");
        }
        else {
            $("#modal" + id).removeClass("validation_error");
            $("#msg" + id).addClass("hidden");
        }
        return expectedCondition;
    }

    function inputNormal(id) {
        $("#modal" + id).removeClass("validation_error");
        $("#msg" + id).addClass("hidden");
    }

    function modalNormal(modalType) { //Modal type: create , update
        inputNormal(modalType + "Surname");
        inputNormal(modalType + "Name");
        inputNormal(modalType + "SecondName");
        inputNormal(modalType + "Password");
        inputNormal(modalType + "ConfirmPassword");
        inputNormal(modalType + "Dni");
        inputNormal(modalType + "Email");
        inputNormal(modalType + "Telephone");
        inputNormal(modalType + "Cellphone");
        inputNormal(modalType + "Town");
        inputNormal(modalType + "Address");
        inputNormal(modalType + "Appartment");
        inputNormal(modalType + "Number");
        inputNormal(modalType + "Floor");
    }
    function validInt(number) {
        if (number <= 0) {
            number = "";
        }
        return number;
    }
    var Index;

    $("#searchInput").keyup(
        function () {
            var input, filter, i, txtValue;
            input = document.getElementById('searchInput');
            filter = input.value.toUpperCase();
            table = document.getElementById("UsersTable");
            rows = table.getElementsByClassName('tableRow');

            // Loop through all list items, and hide those who don't match the search query
            for (i = 0; i < rows.length; i++) {
                let tdn = rows[i].getElementsByClassName('colName')[0];
                let name = tdn.textContent || tdn.innerText;
                let tdd = rows[i].getElementsByClassName('colDNI')[0];
                let dni = tdd.textContent || tdd.innerText;
                let tds = rows[i].getElementsByClassName('colSurname')[0];
                let surname = tds.textContent || tds.innerText;
                if (name.toUpperCase().indexOf(filter) > -1 || dni.toUpperCase().indexOf(filter) > -1 || surname.toUpperCase().indexOf(filter) > -1) {
                    rows[i].style.display = "";
                } else {
                    rows[i].style.display = "none";
                }
            }
        }
    );

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
                alert("ERROR");
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
                        alert("Ya existe un usuario con ese email o Dni");
                    }
                },
                error: function () {
                    alert("Falla al registrar el usuario. Reintentar");
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
                alert("ERROR");
            }
        });
    });
});

$("#newUser").click(function () {
    valid = validate("CreateSurname", $("#modalCreateSurname").val() !== "");
    valid = validate("CreateName", $("#modalCreateName").val() !== "") && valid;
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
                        alert(success);
                    }
                },
                error: function () {
                    alert("Falla al registrar el usuario. Reintentar");
                }

            });
        }
        else {
            if ($("#modalCreateName").val() === "") {
                $("#modalCreateName").addClass("validation_error");
            }
        }
    } else {
        alert("Las contraseñas no coinciden");
    }
});
});
