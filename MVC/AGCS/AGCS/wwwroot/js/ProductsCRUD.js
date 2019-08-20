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

    $(".btnProductUpdate").click(function () {
        modalNormal("Update");
        let Index = $(this).attr("position");
        $.ajax({
            type: "POST",
            url: "/Products/GetProduct",
            data: { pos: Index },
            success: function (DataJsonClient) {
                var Data = JSON.parse(DataJsonClient);
                $("#updtNumber").find("input").val(Data.ArticleNumber);
                $("#updtDescription").find("input").val(Data.Description);
                $("#updtCode").find("input").val(validInt(Data.Code));
                $("#updtCost").find("input").val(Data.Cost);
                $("#updtPrice").find("input").val(validInt(Data.Price));
                $("#updtPriceW").find("input").val(validInt(Data.PriceW));
                $("#updtStock").find("input").val(Data.Stock);
                $("#updtSupplier").find("input").val(Data.idSupplier);
            },
            error: function () {
                alert("ERROR");
            }
        });
    });

    $("#addProduct").click(function () {
        modalNormal("Create");
    });

    $("#UpdateSubmit").click(function () {
        valid = validate("UpdateSurname", $("#updtSurname").val() !== "");
        valid = validate("UpdateName", $("#updtName").val() !== "") && valid;
        valid = validate("UpdateDni", $("#updtDni").val() !== "" && $("#updtDni").val() > 0) && valid;

        if (valid) {
            $.ajax({
                type: "POST",
                url: "/Products/UpdateProduct",
                data: {
                    number: $("#updtSurname").val(),
                    description: $("#updtName").val(),
                    code: $("#updtTown").val(),
                    cost: $("#updtDni").val(),
                    price: $("#updtEmail").val(),
                    priceW: $("#updtTelephone").val(),
                    stock: $("#updtCellphone").val(),
                    idSupplier: $("#updtAddress").val()
                },
                success: function () {
                    location.reload();
                    $("#productUpdate").modal("toggle");
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
                url: "/Products/DeleteProduct",
                data: { index: Index },
                success: function () {
                    location.reload();
                },
                error: function () {
                    alert("ERROR");
                }
            });
        });
    });

    $("#newProduct").click(function () {
        valid = validate("CreateSurname", $("#modalCreateSurname").val() !== "");
        valid = validate("CreateName", $("#modalCreateName").val() !== "") && valid;
        valid = validate("CreateDni", $("#modalCreateDni").val() !== "" && $("#modalCreateDni").val() > 0) && valid;
        if (valid) {
            $.ajax({
                type: "POST",
                url: "/Products/CreateProduct",
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
                    $("#addProduct").modal("toggle");
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