$(document).ready(function () {

    $("#searchInput").keyup(
        function () {
            var input, filter, i, txtValue;
            input = document.getElementById('searchInput');
            filter = input.value.toUpperCase();
            table = document.getElementById("ClientsTable");
            rows = table.getElementsByClassName('clientRow');

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
            url: "/Clients/GetDataClient",
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
                url: "/Clients/UpdateClient",
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
                url: "/Clients/DeleteClient",
                data: { pos: Index },
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
                url: "/Clients/CreateClient",
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