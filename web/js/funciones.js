$(document).ready(function() {
    // Función para eliminar producto (se mantiene igual)
    $("tr #btnDelete").click(function() {
        var idp = $(this).parent().find("#idp").val();
        swal({
            title: "¿Está seguro de eliminar?",
            text: "Una vez eliminado, deberá agregar el producto nuevamente!",
            icon: "warning",
            buttons: true,
            dangerMode: true,
        }).then((willDelete) => {
            if (willDelete) {
                eliminar(idp);
                swal("¡Producto eliminado!", {
                    icon: "success",
                }).then(() => {
                    location.reload();
                });
            }
        });
    });

    function eliminar(idp) {
        var url = "Controlador?accion=Delete";
        $.ajax({
            type: 'POST',
            url: url,
            data: "idp=" + idp,
            success: function() {
                // La recarga se maneja en el swal
            }
        });
    }
    
    // Función para actualizar cantidad
    function actualizarCantidad(input) {
        var idp = $(input).parent().find("#idpro").val();
        var cantidad = parseInt($(input).val());
        
        // Validar que sea un número y mínimo 1
        if(isNaN(cantidad) || cantidad < 1) {
            $(input).val(1);
            cantidad = 1;
        }
        
        // Deshabilitar temporalmente el input
        $(input).prop('disabled', true);
        
        $.ajax({
            type: 'POST',
            url: 'Controlador?accion=ActualizarCantidad',
            data: {
                idp: idp,
                Cantidad: cantidad
            },
            success: function() {
                location.reload();
            },
            error: function() {
                swal("Error", "No se pudo actualizar la cantidad", "error");
                $(input).prop('disabled', false);
                location.reload();
            }
        });
    }
    
    // Evento para cambios con las flechas
    $(document).on('change', '.quantity-input', function() {
        actualizarCantidad(this);
    });
    
    // Evento para cuando pierde el foco (edición manual)
    $(document).on('blur', '.quantity-input', function() {
        if(parseInt($(this).val()) < 1) {
            $(this).val(1);
        }
        actualizarCantidad(this);
    });
    
    // Prevenir valores negativos al escribir
    $(document).on('keydown', '.quantity-input', function(e) {
        // Permitir: teclas de navegación, borrar, tab, etc.
        if ([46, 8, 9, 27, 13, 110].includes(e.which) ||
            // Permitir: Ctrl+A, Ctrl+C, Ctrl+V, etc.
            (e.which === 65 && e.ctrlKey === true) || 
            (e.which === 67 && e.ctrlKey === true) ||
            (e.which === 86 && e.ctrlKey === true) ||
            // Permitir: flechas izquierda/derecha
            (e.which >= 35 && e.which <= 39)) {
            return;
        }
        
        // No permitir tecla de menos (-)
        if (e.which === 45 || e.which === 189) {
            e.preventDefault();
        }
    });

    // Agrega al final del documento ready en funciones.js
// Manejo del dropdown de usuario
    $(document).on('click', '.account-btn', function (e) {
        e.stopPropagation();
        $(this).siblings('.dropdown-content').toggle();
    });

// Cerrar dropdown al hacer clic fuera
    $(document).click(function () {
        $('.dropdown-content').hide();
    });

// Evitar que el dropdown se cierre al hacer clic dentro
    $(document).on('click', '.dropdown-content', function (e) {
        e.stopPropagation();
    });

});