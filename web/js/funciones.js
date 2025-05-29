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
            success: function () {
                // La recarga se maneja en el swal
            }
        });
    }

    // Función para actualizar cantidad
    function actualizarCantidad(input) {
        var idp = $(input).parent().find("#idpro").val();
        var cantidad = parseInt($(input).val());

        // Validar que sea un número y mínimo 1
        if (isNaN(cantidad) || cantidad < 1) {
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
            success: function () {
                location.reload();
            },
            error: function () {
                swal("Error", "No se pudo actualizar la cantidad", "error");
                $(input).prop('disabled', false);
                location.reload();
            }
        });
    }

    // Evento para cambios con las flechas
    $(document).on('change', '.quantity-input', function () {
        actualizarCantidad(this);
    });

    // Evento para cuando pierde el foco (edición manual)
    $(document).on('blur', '.quantity-input', function () {
        if (parseInt($(this).val()) < 1) {
            $(this).val(1);
        }
        actualizarCantidad(this);
    });

    // Prevenir valores negativos al escribir
    $(document).on('keydown', '.quantity-input', function (e) {
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

    // Validación de formulario de pago
    function validarFormularioPago() {
        const metodoPago = document.querySelector('input[name="metodoPago"]:checked').value;

        if (metodoPago === 'tarjeta') {
            const numeroTarjeta = document.getElementById('numeroTarjeta').value;
            const nombreTitular = document.getElementById('nombreTitular').value;
            const fechaExpiracion = document.getElementById('fechaExpiracion').value;
            const cvv = document.getElementById('cvv').value;

            if (numeroTarjeta.length !== 16 || !/^\d+$/.test(numeroTarjeta)) {
                alert('El número de tarjeta debe tener 16 dígitos');
                return false;
            }

            if (nombreTitular.trim() === '') {
                alert('Ingrese el nombre del titular de la tarjeta');
                return false;
            }

            if (!/^\d{2}\/\d{2}$/.test(fechaExpiracion)) {
                alert('La fecha de expiración debe tener el formato MM/AA');
                return false;
            }

            if (cvv.length !== 3 || !/^\d+$/.test(cvv)) {
                alert('El CVV debe tener 3 dígitos');
                return false;
            }
        }

        return true;
    }

// Mostrar u ocultar formularios según método de pago
    document.addEventListener('DOMContentLoaded', function () {
        const metodoPagoRadios = document.querySelectorAll('input[name="metodoPago"]');
        const tarjetaForm = document.getElementById('tarjetaForm');
        const yapeForm = document.getElementById('yapeForm');

        metodoPagoRadios.forEach(radio => {
            radio.addEventListener('change', function () {
                if (this.value === 'tarjeta') {
                    tarjetaForm.style.display = 'block';
                    yapeForm.style.display = 'none';
                } else {
                    tarjetaForm.style.display = 'none';
                    yapeForm.style.display = 'block';
                }
            });
        });

        // Formatear número de tarjeta
        const numeroTarjeta = document.getElementById('numeroTarjeta');
        if (numeroTarjeta) {
            numeroTarjeta.addEventListener('input', function () {
                this.value = this.value.replace(/[^\d]/g, '');
            });
        }

        // Formatear fecha de expiración
        const fechaExpiracion = document.getElementById('fechaExpiracion');
        if (fechaExpiracion) {
            fechaExpiracion.addEventListener('input', function () {
                this.value = this.value.replace(/[^\d\/]/g, '');
                if (this.value.length === 2 && !this.value.includes('/')) {
                    this.value += '/';
                }
            });
        }

        // Formatear CVV
        const cvv = document.getElementById('cvv');
        if (cvv) {
            cvv.addEventListener('input', function () {
                this.value = this.value.replace(/[^\d]/g, '');
            });
        }

    });
    
    
});