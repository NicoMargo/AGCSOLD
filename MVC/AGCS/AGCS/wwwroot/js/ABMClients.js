

$(document).ready(function () {
    function validate(id,expectedCondition = true) {
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
        inputNormal(modalType +"Surname");
        inputNormal(modalType +"Name");
        inputNormal(modalType +"Dni");
        inputNormal(modalType +"Email");
        inputNormal(modalType +"Telephone");
        inputNormal(modalType +"Cellphone");
        inputNormal(modalType +"Town");
        inputNormal(modalType +"Address");
        inputNormal(modalType +"Appartment");
        inputNormal(modalType +"Number");
        inputNormal(modalType +"Floor");
    }
    function validInt(number) {
        if (number <= 0) {
            number = "";
        }
        return number;
    }

    $(".imgClientUpdate").click(function () {
        modalNormal("Update");
        let Index = $(this).attr("position");
        $.ajax({
            type: "POST",
            url: "/backend/GetDataClient",
            data: { pos: Index },
            success: function (DataJsonClient) {
                var Data = JSON.parse(DataJsonClient);
                $("#modalUpdateSurname").val(Data.Surname);
                $("#modalUpdateName").val(Data.Name);
                $("#modalUpdateDni").val(validInt(Data.Dni));
                $("#modalUpdateEmail").val(Data.Email);
                $("#modalUpdateTelephone").val(validInt(Data.Telephone));
                $("#modalUpdateCellphone").val(validInt(Data.Cellphone));
                $("#modalUpdateTown").val(Data.Town);
                $("#modalUpdateAddress").val(Data.Address);
                $("#modalUpdateAppartment").val(Data.Leter);
                $("#modalUpdateNumber").val(Data.Number);
                $("#modalUpdateFloor").val(Data.Floor);
            },
            error: function () {
                alert("ERROR");
            }
        });
    });

    $("#createClient").click(function () {
        modalNormal("Create");
    });

    $("#UpdateSubmit").click(function () {
        valid = validate("UpdateSurname", $("#modalUpdateSurname").val() !== "");
        valid = validate("UpdateName", $("#modalUpdateName").val() !== "") && valid;
        valid = validate("UpdateDni", $("#modalUpdateDni").val() !== "" && $("#modalUpdateDni").val() > 0) && valid;

        if (valid) {
            $.ajax({
                type: "POST",
                url: "/backend/UpdateClient",
                data: {
                    Surname: $("#modalUpdateSurname").val(),
                    Name: $("#modalUpdateName").val(),
                    dni: $("#modalUpdateDni").val(),
                    email: $("#modalUpdateEmail").val(),
                    Telephone: $("#modalUpdateTelephone").val(),
                    Cellphone: $("#modalUpdateCellphone").val(),
                    Town: $("#modalUpdateTown").val(),
                    Address: $("#modalUpdateAddress").val(),
                    Province: 1,
                    Leter: $("#modalUpdateAppartment").val(),
                    Number: $("#modalUpdateNumber").val(),
                    Floor: $("#modalUpdateFloor").val()
                },
                success: function () {
                    location.reload();
                    $("#updateClient").modal("toggle");
                },
                error: function () {
                    alert("ERROR");
                }
            });
        }
    });

    $("deleteButton").click(function () {
        let Index = $(this).attr("position");
         $("#confirm").click(function () {
            $.ajax({
                type: "DELETE",
                url: "/backend/DeleteClient",
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
        valid = validate("CreateSurname", $("#modalCreateSurname").val() !== "");
        valid = validate("CreateName", $("#modalCreateName").val() !== "") && valid;
        valid = validate("CreateDni", $("#modalCreateDni").val() !== "" && $("#modalCreateDni").val() > 0) && valid;

        if (valid) {
            $.ajax({
                type: "POST",
                url: "/backend/CreateClient",
                data: {
                    surname: $("#modalCreateSurname").val(),
                    name: $("#modalCreateName").val(),
                    dni: $("#modalCreateDni").val(),
                    email: $("#modalCreateEmail").val(),
                    telephone: $("#modalCreateTelephone").val(),
                    cellphone: $("#modalCreateCellphone").val(),
                    town: $("#modalCreateTown").val(),
                    address: $("#modalCreateAddressC").val(),
                    province: 1,
                    leter: $("#modalCreateAppartment").val(),
                    number: $("#modalCreateNumber").val(),
                    floor: $("#modalCreateFloor").val()
                },
                success: function () {
                    location.reload();
                    $("#createClient").modal("toggle");
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