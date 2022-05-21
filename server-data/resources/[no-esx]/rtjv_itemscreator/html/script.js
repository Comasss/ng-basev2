$(".contenido").fadeOut();
$(".contenido2").fadeOut();

$(() => {
    display = (bool) => {
        if (bool) {
            $(".container").show();
        } else {
            $(".container").hide();
        }
    }

    display(false)

    addEventListener('message', (event) => {
        var item = event.data;
        if (item.type === "ui") {
            if (item.status == true) {
                display(true)
            } else {
                display(false)
            }
        }
    })
    
    document.onkeyup = (data) => {
        if (data.which === 27) {
            $.post('http://'+GetParentResourceName()+'/salir', JSON.stringify({}));
            $(".contenido").fadeOut();
            $(".contenido2").fadeOut();
        }
    };
})

// Funciones

$('.crear').on('click', () => {
    $(".container").fadeOut();
    $(".contenido").fadeIn();
})

$('.aceptar').on('click', () => {
    $.post('https://'+GetParentResourceName()+'/crearitem1', JSON.stringify({
        name:$('.input1').val(),
        label:$('.input2').val(),
        weight:$('.input3').val(),
        status:$('.input4').val(),
        quantity:$('.input5').val()
    }));
    $(".contenido").fadeOut();
})

$('.boton3').on('click', () => {
    $.post('https://'+GetParentResourceName()+'/eliminaritem', JSON.stringify({
        name:$('.input6').val()
    }));
    $(".contenido2").fadeOut();
})

$('.eliminar').on('click', () => {
    $(".container").fadeOut();
    $(".contenido2").fadeIn();
})
