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
                    name: $("#crtName").find("input").val(),
                    description: $("#crtDescription").find("textArea").val(),
                    code: $("#crtCode").find("input").val(),
                    cost: parseFloat($("#crtCost").find("input").val()),
                    price: parseFloat($("#crtPrice").find("input").val()),
                    priceW: parseFloat($("#crtPriceW").find("input").val()),
                    idSupplier: parseInt($("#crtSupplier").val()),
                    image: $("#crtImage").find("input").val(),
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
            success: function (DataJson) {
                var Data = JSON.parse(DataJson);
                $("#updtNumber").find("input").val(Data.ArticleNumber);
                $("#updtName").find("input").val(Data.Name);
                $("#updtDescription").find("textArea").val(Data.Description);
                $("#updtCode").find("input").val(Data.Code);
                $("#updtCost").find("input").val(Data.Cost);
                $("#updtPrice").find("input").val(Data.Price);
                $("#updtPriceW").find("input").val(Data.PriceW);
                $("#updtSupplier").val(Data.IdSupplier);
                $("#updtImage").find("input").val(Data.Image);
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
                    name: $("#updtName").find("input").val(),
                    description: $("#updtDescription").find("textArea").val(),
                    code: $("#updtCode").find("input").val(),
                    cost: $("#updtCost").find("input").val(),
                    price: $("#updtPrice").find("input").val(),
                    priceW: $("#updtPriceW").find("input").val(),
                    idSupplier: parseInt($("#updtSupplier").val()),
                    image: $("#updtImage").find("input").val()
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
        if (!parseInt($('#subtractStock').val().isNaN) && $('#description').val() != "") {
            if (parseInt($('#subtractStock').val()) < 0) {
                CreateModal("Numero invalido", "No puedes restar stock negativo");
            } else {
                if (parseInt($("#subtractStock").val()) <= parseInt($('#quant').html())) {
                    $.ajax({
                        type: "POST",
                        url: "/Products/UpdateStock",
                        data: {
                            id: parseInt(modelId),
                            stock: $("#subtractStock").val(),
                            description: $('#description').val()
                        },
                        success: function (s) {
                            if (s) {
                                $('#quant').html(parseInt($('#quant').html()) - parseInt($("#subtractStock").val()));
                                CreateModal("Stock", "Se modifico el stock correctamente", function () { location.reload();});
                            } else {
                                CreateModal("Error", "Hubo un error al modificar el stock");
                            }
                        },
                        error: function () {
                            CreateModal("Error del sistema", "Hubo un error al modificar el stock");
                        }
                    });
                } else {
                    CreateModal("Datos Invalidos", "No puedes quitar mas stock del que hay");
                }
            }
        } else {
            CreateModal("Campos incompletos", "Ingresar ajuste de stock y motivo");
        }
    });
});