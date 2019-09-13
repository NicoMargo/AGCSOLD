$(document).ready(function () {
    var clientId;
    RowSearcher("ClientsTable","searchInput")
    /*$("#searchInput").keyup(
        function () {
            var input, filter, i, txtValue;
            input = document.getElementById('searchInput');
            filter = input.value.toUpperCase();
            table = document.getElementById("ClientsTable");
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
    );*/
    $("#Submit").click(function () {
        $.ajax({
            type: "POST",
            url: "/Clients/UpdateClient",
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
                CreateModal("Error", "Hubo un error al buscar los datos del cliente");
            }
        });
    });
    $(".updateClient").click(function () {
        let Index = $(this).attr("position");
        $.ajax({
            type: "POST",
            url: "/Clients/GetDataClient",
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
                CreateModal("Error", "Hubo un error al Actualizar el cliente");
            }
        });
    });
    $(".w-50").click(function () {
        let Index = $(this).attr("position");
        $("#confirm").click(function () {
            $.ajax({
                type: "DELETE",
                url: "/Clients/DeleteClient",
                data: { id: Index },
                success: function () {
                    location.reload();
                },
                error: function () {
                    CreateModal("Error", "Hubo un error al eliminar el cliente");
                }
            });
        });
    });

    $(".updtModalBtn").click(function () {
        modalNormal("Update");
        clientId = $(this).attr("clientId");
        $.ajax({
            type: "POST",
            url: "/Clients/GetDataClient",
            data: { id: clientId },
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
                CreateModal("Error", "Hubo un error al buscar los datos del cliente");
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
                    id: clientId,
                    surname: $("#modalUpdateSurname").val(),
                    name: $("#modalUpdateName").val(),
                    dni: $("#modalUpdateDni").val(),
                    email: $("#modalUpdateEmail").val(),
                    telephone: $("#modalUpdateTelephone").val(),
                    cellphone: $("#modalUpdateCellphone").val(),
                    Town: $("#modalUpdateTown").val(),
                    Address: $("#modalUpdateAddress").val(),
                    Province: 1,
                    Leter: $("#modalUpdateAppartment").val(),
                    Number: $("#modalUpdateNumber").val(),
                    Floor: $("#modalUpdateFloor").val()
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
        clientId = $(this).attr("clientId");
         $("#confirm").click(function () {
            $.ajax({
                type: "DELETE",
                url: "/Clients/DeleteClient",
                data: { id: clientId },
                success: function () {
                    location.reload();
                },
                error: function () {
                    CreateModal("Error", "Hubo un error al eliminar al cliente");
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
                },
                error: function () {
                    CreateModal("Error", "Hubo un error al crear el cliente");
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