$(document).ready(function () {

    function validInt(element, expectedCondition = true) {
        let valid = false;
        let value = element.getElementsByTagName("input")[0].value;
        if (!(expectedCondition && value > 0 && value != "")) {
            element.getElementsByTagName("input")[0].classList.add("validation_error");
            element.getElementsByClassName("validation_msg")[0].classList.remove("hidden");
        }
        else {
            element.getElementsByTagName("input")[0].classList.remove("validation_error");
            element.getElementsByClassName('validation_msg')[0].classList.add("hidden");
            valid = true;
        }
        return valid;
    }

    function validPositive(element, expectedCondition = true) {
        let valid = false;
        let value = element.getElementsByTagName("input")[0].value;
        if (!(expectedCondition && value > 0 && value != "")) {
            element.getElementsByTagName("input")[0].classList.add("validation_error");
            element.getElementsByClassName("validation_msg")[0].classList.remove("hidden");
        }
        else {
            element.getElementsByTagName("input")[0].classList.remove("validation_error");
            element.getElementsByClassName('validation_msg')[0].classList.add("hidden");
            valid = true;
        }
        return valid;
    }

    function validString(element, expectedCondition = true) {
        let valid = false;
        if (!(expectedCondition && element.getElementsByTagName("input")[0].value != '')) {
            element.getElementsByTagName("input")[0].classList.add("validation_error");
            element.getElementsByClassName("validation_msg")[0].classList.remove("hidden");
        }
        else {          
            element.getElementsByTagName("input")[0].classList.remove("validation_error");
            element.getElementsByClassName('validation_msg')[0].classList.add("hidden");
            valid = true;
        }
        return valid;
    }


    function validateInputs(parentId) {
        let valid = true;
        element = document.getElementById(parentId);
        notEmptyList = element.getElementsByClassName("updtInput notEmpty");
        for (i = 0; i < notEmptyList.length; i++) {
            valid = validString(notEmptyList[i]) && valid;
        }

        PositivesList = element.getElementsByClassName("updtInput validPositive");
        for (i = 0; i < PositivesList.length; i++) {
            valid = validPositive(PositivesList[i]) && valid;
        }

        IntergersList = element.getElementsByClassName("updtInput validInt");
        for (i = 0; i < IntergersList.length; i++) {
            valid = validInt(IntergersList[i]) && valid;
        }
        return valid;

    }

    function inputNormal(parentId) {
        var element = document.getElementById(parentId);
        element.getElementsByTagName("input")[0].classList.remove("validation_error");
        element.getElementsByClassName('validation_msg')[0].classList.add("hidden")
    }

    function normalizeInputs(parentId) { //Modal type: create , update
        var element = document.getElementById(parentId);
        li = element.getElementsByClassName("updtInput");
        for (i = 0; i < li.length; i++) {
            inputNormal(li[i].id);
        }
    }

    $(".btnProductUpdate").click(function () {
        normalizeInputs("productUpdate")
        let Index = $(this).attr("position");
        $.ajax({
            type: "POST",
            url: "/Products/GetProduct",
            data: { pos: Index },
            success: function (DataJsonClient) {
                var Data = JSON.parse(DataJsonClient);
                $("#updtNumber").find("input").val(Data.ArticleNumber);
                $("#updtDescription").find("input").val(Data.Description);
                $("#updtCode").find("input").val(Data.Code);
                $("#updtCost").find("input").val(Data.Cost);
                $("#updtPrice").find("input").val(Data.Price);
                $("#updtPriceW").find("input").val(Data.PriceW);
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
        if (validateInputs("productUpdate")) {
            $.ajax({
                type: "POST",
                url: "/Products/UpdateProduct",
                data: {
                    number: parseInt($("#updtNumber").find("input").val()),
                    description: $("#updtDescription").find("input").val(),
                    code: $("#updtCode").find("input").val(),
                    cost: parseFloat($("#updtCost").find("input").val()),
                    price: parseFloat($("#updtPrice").find("input").val()),
                    priceW: parseFloat($("#updtPriceW").find("input").val()),
                    stock: parseInt($("#updtStock").find("input").val()),
                    idSupplier: parseInt($("#updtSupplier").find("select").val())
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
        validateInputs("productsCreate");
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
                $("#modalCreateName").classList.add("validation_error");
            }
        }
    });
});