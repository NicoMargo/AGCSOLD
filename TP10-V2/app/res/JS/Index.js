
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
	if (!(expectedCondition && value > 0 )) {
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

	notEmptyList = element.getElementsByClassName(inputClassname + " notEmpty");
	for (i = 0; i < notEmptyList.length; i++) {
		valid = validString(notEmptyList[i]) && valid;
	}
	PositivesList = element.getElementsByClassName(inputClassname + " validPositive");
	for (i = 0; i < PositivesList.length; i++) {
		valid = validPositive(PositivesList[i]) && valid;
	}
	IntergersList = element.getElementsByClassName(inputClassname + " validInt");
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

var modelId, productos;
$(document).ready(function () {
	$.ajax({
		type: "GET",
		url: "http://localhost:51031/api/Ecomerce/getproducts/1",
		success: function (productos) {
			for (var i = 0; i < productos.length; i++) {
				$("#cardGroup").append(
					'<div class="card mb-3 mr-3 col-md-3"><div style="height: 250px;">' +
					'<img class="card-img-top ml-4 w-auto pt-3 h-100"  src="'+productos[i].image +'" alt="Card image cap">' +
					'</div>' +
					'<div class="card-body">' +
					'<div class="d-flex">' +
					'<h5 class="card-title mr-auto">' + productos[i].description + '</h5>' +
					'<div class="text-success font-weight-bold">$' + productos[i].price + '</div>' +
					'</div>' +
					'</div>' +
					'</div>'
				);
			}
		},
		error: function () {
			alert("ERROR");
		}
	});

	$("#btnAgregModal").click(function () {
		normalizeInputs("agregModal","agregInput");
	});
	$("#confirm").click(function () {
		$.ajax({
			type: "POST",
			url: "../../../../TP10/api/controller/productoController.php",
			data: {
				action: "Bjuguete",
				id: modelId
			},
			success: function () {
				location.reload();
			},
			error: function () {
				CreateModal("Error", "Hubo un error al eliminar al producto");
			}
		});
	});
	$("#add").click(function () {
		if (validateInputs("agregModal", "agregInput")) {
			$.ajax({
				type: "POST",
				url: "../../../../TP10/api/controller/productoController.php",
				data: {
					action: "Ajuguete",
					producto: {
						id: 0,
						nombre: $("#agregNombre").find("input").val(),
						descripcion: $("#agregDesc").find("textArea").val(),
						precio: $("#agregPrecio").find("input").val(),
						foto: $("#agregFoto").find("input").val(),
						stock: $("#agregStock").find("input").val()
					}
				},
				success: function () {
					location.reload();
				},
				error: function () {
					alert("Error al crear", "Hubo un error al crear al producto");
				}
			});
		}
	});
	$("#btnModificar").click(function () {
		if (validateInputs("modifModal", "modifInput")) {
			$.ajax({
				type: "POST",
				url: "../../../../TP10/api/controller/productoController.php",
				data: {
					action: "Mjuguete",
					producto: {
						id: modelId,
						nombre: $("#modifNombre").find("input").val(),
						descripcion: $("#modifDesc").find("textArea").val(),
						precio: $("#modifPrecio").find("input").val(),
						foto: $("#modifFoto").find("input").val(),
						stock: $("#modifStock").find("input").val()
					}
				},
				success: function () {
					location.reload();
				},
				error: function () {
					alert("Error al modificar", "Hubo un error al modificar al producto");
				}
			});
		}
	});
});