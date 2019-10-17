$(document).ready(function () {
    var modelId;
    RowSearcher("CRUDTable", "searchInput");
    
    $("#btnModalCrt").click(function () {
    });

    $("#add").click(function () {
        if (validateInputs("modalCrt", "crtInput")) {
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
                },
                error: function () {
                    CreateModal("Error", "Hubo un error al crear el producto");
                }
            });
        }
    });

    $("updateButton").click(function () {
        normalizeInputs("modalUpdt", "updtInput");
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


    $("#update").click(function () {
        if (validateInputs("modalUpdt","updtInput")) {
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
    

    $("#updt").click(function () {
        modelId = $(this).attr("modelId");
        if (parseInt($('#subtractStock').val()) < 0) {
            CreateModal("Error", "No puedes restar stock negativo");
        } else {
            if (parseInt($("#subtractStock").val()) <= parseInt($('#quant').html())) {
                $.ajax({
                    type: "POST",
                    url: "/Products/UpdateStock",
                    data: {
                        id: parseInt(modelId),
                        stock: $("#subtractStock").val(),
                        description: $(this).parent().find("#description").val()
                    },
                    success: function () {
                        $('#quant').html("hoal");
                        CreateModal("Stock", "Se modifico el stock correctamente");
                    },
                    error: function () {
                        CreateModal("Error", "Hubo un error al modificar el stock");
                    }
                });
            } else {
                CreateModal("Error", "No puedes quitar mas stock del que hay");
            }
        }
        
    });
});