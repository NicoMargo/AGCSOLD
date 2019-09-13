function CreateModal(title, body) {
    $("body").append('<div class="modal fade" id="' + title.replace(/ /g, "") + '" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true"> <div class="modal-dialog" role="document"> <div class="modal-content"> <div class="modal-header"> <h5 class="modal-title" id="exampleModalLabel">' + title + '</h5> <button type="button" class="close" data-dismiss="modal" aria-label="Close"> <span aria-hidden="true">&times;</span> </button> </div><div class="modal-body">' + body +'</div><div class="modal-footer"><button type="button" class="btn btn-primary" data-dismiss="modal">Aceptar</button> </div></div></div></div>');
    $('#' + title.replace(/ /g, "")).modal('show');
    }
function validate(id, expectedCondition = true) {
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
function validInt(number) {
    if (number <= 0) {
        number = "";
    }
    return number;
}
function inputNormal(id) {
    $("#modal" + id).removeClass("validation_error");
    $("#msg" + id).addClass("hidden");
}

function modalNormal(modalType) { //Modal type: create , update
    inputNormal(modalType + "Surname");
    inputNormal(modalType + "Name");
    inputNormal(modalType + "Dni");
    inputNormal(modalType + "Email");
    inputNormal(modalType + "Telephone");
    inputNormal(modalType + "Cellphone");
    inputNormal(modalType + "Town");
    inputNormal(modalType + "Address");
    inputNormal(modalType + "Appartment");
    inputNormal(modalType + "Number");
    inputNormal(modalType + "Floor");
}
    
