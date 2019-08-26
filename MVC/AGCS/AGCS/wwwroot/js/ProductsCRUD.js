$(document).ready(function () {

    function validInt(id, expectedCondition = true) {
        if (!expectedCondition && element.find("input").val > 0 && element.find('input').val != "") {
            element.find("input").addClass("validation_error");
            element.getElementByClassName("validation_msg").removeClass("hidden");
        }
        else {
            element.find("input").removeClass("validation_error");
            element.getElementByClassName('validation_msg').addClass("hidden");
        }
    }

    function validPositive(id, expectedCondition = true) {
        if (!expectedCondition && element.find("input").val > 0 && element.find('input').val != "") {
            element.find("input").addClass("validation_error");
            element.getElementByClassName("validation_msg").removeClass("hidden");
        }
        else {
            element.find("input").removeClass("validation_error");
            element.getElementByClassName('validation_msg').addClass("hidden");
        }
    }

    function validString(element, expectedCondition = true) {
        if (!expectedCondition && element.find("input").val != '') {
            element.find("input").addClass("validation_error");
            element.getElementByClassName("validation_msg").removeClass("hidden");
        }
        else {
            element.find("input").remove("validation_error");
            element.getElementByClassName('validation_msg').addClass("hidden");
        }
    }


    function validateInputs(parentId) {
        element = document.getElementById(parentId);
        notEmptyList = element.getElementsByClassName("notEmpty");
        for (i = 0; i < notEmptyList.length; i++) {
            validString(notEmptyList[i]);
        }

        notEmptyList = element.getElementsByClassName("validPositive");
        for (i = 0; i < notEmptyList.length; i++) {
            validPositive(notEmptyList[i]);
        }

        notEmptyList = element.getElementsByClassName("validInt");
        for (i = 0; i < notEmptyList.length; i++) {
            validInt(notEmptyList[i]);
        }
        

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
        validateInputs("productUpdate")

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
                $("#modalCreateName").addClass("validation_error");
            }
        }
    });
});