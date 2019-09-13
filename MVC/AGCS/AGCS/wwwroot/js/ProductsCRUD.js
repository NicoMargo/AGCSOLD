$(document).ready(function () {
    var modelId;
    $("#searchInput").keyup(
        function () {
            var input, filter, i, txtValue;
            input = document.getElementById('searchInput');
            filter = input.value.toUpperCase();
            table = document.getElementById("ProductsTable");
            rows = table.getElementsByClassName('productRow');

            // Loop through all list items, and hide those who don't match the search query
            for (i = 0; i < rows.length; i++) {
                let tdn = rows[i].getElementsByClassName('colNumber')[0];
                let number = tdn.textContent || tdn.innerText;
                let tdd = rows[i].getElementsByClassName('colDescription')[0];
                let desc = tdd.textContent || tdd.innerText;
                let tdc = rows[i].getElementsByClassName('colCode')[0];
                let code = tdc.textContent || tdc.innerText;
                if (number.toUpperCase().indexOf(filter) > -1 || desc.toUpperCase().indexOf(filter) > -1 || code.toUpperCase().indexOf(filter) > -1) {
                    rows[i].style.display = "";
                } else {
                    rows[i].style.display = "none";
                }
            }
        }
    );

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


    function validateInputs(parentId, inputClassname) {
        let valid = true;
        element = document.getElementById(parentId);
        notEmptyList = element.getElementsByClassName(inputClassname+" notEmpty");
        for (i = 0; i < notEmptyList.length; i++) {
            valid = validString(notEmptyList[i]) && valid;
        }

        PositivesList = element.getElementsByClassName(inputClassname +" validPositive");
        for (i = 0; i < PositivesList.length; i++) {
            valid = validPositive(PositivesList[i]) && valid;
        }

        IntergersList = element.getElementsByClassName(inputClassname +" validInt");
        for (i = 0; i < IntergersList.length; i++) {
            valid = validInt(IntergersList[i]) && valid;
        }
        return valid;

    }

    function inputNormal(parentId) {
        var element = document.getElementById(parentId);
        element.getElementsByTagName("input")[0].classList.remove("validation_error");
        element.getElementsByClassName('validation_msg')[0].classList.add("hidden");
    }

    function normalizeInputs(parentId, inputClassname) { //Modal type: create , update
        var element = document.getElementById(parentId);
        li = element.getElementsByClassName(inputClassname);
        for (i = 0; i < li.length; i++) {
            inputNormal(li[i].id);
        }
    }

    $(".btnProductUpdate").click(function () {
        normalizeInputs("productUpdate", "updtInput");
        modelId = $(this).attr("modelId");
        $.ajax({
            type: "POST",
            url: "/Products/GetProduct",
            data: { id: modelId },
            success: function (DataJsonClient) {
                var Data = JSON.parse(DataJsonClient);
                $("#updtNumber").find("input").val(Data.ArticleNumber);
                $("#updtDescription").find("input").val(Data.Description);
                $("#updtCode").find("input").val(Data.Code);
                $("#updtCost").find("input").val(Data.Cost);
                $("#updtPrice").find("input").val(Data.Price);
                $("#updtPriceW").find("input").val(Data.PriceW);
                $("#updtStock").find("input").val(Data.Stock);
                $("#updtSupplier").val(Data.IdSupplier);
            },
            error: function () {
                CreateModal("Error", "Hubo un error al modificar el producto");
            }
        });
    });


    $("#UpdateSubmit").click(function () {
        if (validateInputs("productUpdate","updtInput")) {
            $.ajax({
                type: "POST",
                url: "/Products/UpdateProduct",
                data: {
                    id: modelId,
                    number: parseInt($("#updtNumber").find("input").val()),
                    description: $("#updtDescription").find("input").val(),
                    code: $("#updtCode").find("input").val(),
                    cost: $("#updtCost").find("input").val(),
                    price: $("#updtPrice").find("input").val(),
                    priceW: $("#updtPriceW").find("input").val(),
                    stock: parseInt($("#updtStock").find("input").val()),
                    idSupplier: parseInt($("#updtSupplier").val())
                },
                success: function () {
                    location.reload();
                    $("#productUpdate").modal("toggle");
                },
                error: function () {
                    CreateModal("Error", "Hubo un error al actualizar el cliente");
                }
            });
        }
    });

    $("deleteButton").click(function () {
        modelId = $(this).attr("modelId");
         $("#confirm").click(function () {
            $.ajax({
                type: "DELETE",
                url: "/Products/DeleteProduct",
                data: { id: modelId },
                success: function () {
                    location.reload();
                },
                error: function () {
                    CreateModal("Error", "Hubo un error al eliminar al producto");
                }
            });
        });
    });
    
    $("#addProduct").click(function () {
    });

    $("#newProduct").click(function () {
        if (validateInputs("productCreate", "crtInput")) {
            $.ajax({
                type: "POST",
                url: "/Products/CreateProduct",
                data: {
                    number: parseInt($("#crtNumber").find("input").val()),
                    description: $("#crtDescription").find("input").val(),
                    code: $("#crtCode").find("input").val(),
                    cost: parseFloat($("#crtCost").find("input").val()),
                    price: parseFloat($("#crtPrice").find("input").val()),
                    priceW: parseFloat($("#crtPriceW").find("input").val()),
                    stock: parseInt($("#crtStock").find("input").val()),
                    idSupplier: parseInt($("#crtSupplier").val()) 
                },
                success: function () {
                    location.reload();
                    $("#productCreate").modal("toggle");
                },
                error: function () {
                    CreateModal("Error", "Hubo un error al crear el producto");
                }
            });
        }
    });

    $(".btnStockUpdt").click(function () {
        modelId = $(this).attr("modelId");
        $.ajax({
            type: "POST",
            url: "/Products/UpdateStock",
            data: {
                id: parseInt(modelId),
                stock: parseInt($(this).parent().find("input").val())
            },
            success: function () {
                
                location.reload();
                CreateModal("Stock", "Se modifico el stock correctamente");
            },
            error: function () {
                CreateModal("Error", "Hubo un error al modificar el stock");
            }
        });
    });
});