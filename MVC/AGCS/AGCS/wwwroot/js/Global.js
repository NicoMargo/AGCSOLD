function CreateModal(title, body, unique = false) {
    if (!unique) {
        $("body").append('<div class="modal fade" id="' + title.replace(/ /g, "") + '" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true"> <div class="modal-dialog" role="document"> <div class="modal-content"> <div class="modal-header"> <h5 class="modal-title" id="exampleModalLabel">' + title + '</h5> <button type="button" class="close" data-dismiss="modal" aria-label="Close"> <span aria-hidden="true">&times;</span> </button> </div><div class="modal-body">' + body + '</div><div class="modal-footer"><button type="button" class="btn btn-primary" data-dismiss="modal">Aceptar</button> </div></div></div></div>');
    } else {
        $("body").append('<div class="modal fade" id="' + title.replace(/ /g, "") + '" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true"> <div class="modal-dialog" role="document"> <div class="modal-content"> <div class="modal-header"> <h5 class="modal-title" id="exampleModalLabel">' + title + '</h5> <button type="button" class="close" data-dismiss="modal" aria-label="Close"> <span aria-hidden="true">&times;</span> </button> </div><div class="modal-body">' + body + '</div><div class="modal-footer"><button type="button" id="btn' + title.replace(/ /g, "") + '" class="btn btn-primary" data-dismiss="modal">Aceptar</button> </div></div></div></div>');
        $("#btn" + title.replace(/ /g, "")).click(function () {
            window.location= "/Backend/Index";
        });
    }
        $('#' + title.replace(/ /g, "")).modal('show');
}

function checkInt(number) {
    if (number <= 0) {
        number = "";
    }
    return number;
}

function RowSearcher(tableId, searchInputId) {
    $("#" + searchInputId).keyup(
        function () {
            let input, filter, table;
            input = document.getElementById(searchInputId);
            filter = input.value.toUpperCase();
            table = document.getElementById(tableId);
            rows = table.getElementsByClassName('tableRow');

            // Loop through all list items, and hide those who don't match the search query
            for (let i = 0; i < rows.length; i++) {
                let cols = rows[i].getElementsByClassName('colToSearch');
                let found = false;
                for (let i = 0; i < cols.length; i++) {
                    let text = cols[i].textContent || cols[i].innerText;
                    found = found || (text.toUpperCase().indexOf(filter) > -1);
                }
                if (found) {
                    rows[i].style.display = "";
                } else {
                    rows[i].style.display = "none";
                }
            }
        }
    );
}
    


function validInt(element, expectedCondition = true) {
    let valid = false;
    let value = element.getElementsByTagName("input")[0].value;
    if (expectedCondition && value < 0) {
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
    if (expectedCondition && value < 0) {
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

function validateInput(inputDiv) {
    let valid = true;
    if (inputDiv.classList.contains("notEmpty") && valid) {
        valid = validString(inputDiv) && valid;
    }
    if (inputDiv.classList.contains("validPositive") && valid) {
        valid = validPositive(inputDiv) && valid;
    }
    if (inputDiv.classList.contains("validInt") && valid) {
        valid = validInt(inputDiv) && valid;
    }
    return valid;
}

function validateInputs(parentId, inputClassname) {
    let valid = true;
    parent = document.getElementById(parentId);
    inputList = parent.getElementsByClassName(inputClassname);
    for (i = 0; i < inputList.length; i++) {
        valid = validateInput(inputList[i]) && valid;
    }
    return valid;
}

function inputNormal(inputDivId) {
    var element = document.getElementById(inputDivId);
    element.getElementsByTagName("input")[0].classList.remove("validation_error");
    element.getElementsByClassName('validation_msg')[0].classList.add("hidden");
}

function normalizeInputs(parentId, inputDivClass) { //Modal type: create , update
    var element = document.getElementById(parentId);
    li = element.getElementsByClassName(inputDivClass);
    for (i = 0; i < li.length; i++) {
        inputNormal(li[i].id);
    }
}

