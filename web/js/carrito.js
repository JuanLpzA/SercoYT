$(document).ready(function() {
    var metodoPagoSeleccionado = '';
    
    // Mostrar modal de pago
    $('#btnRealizarPago').click(function() {
        $('#paymentModal').css('display', 'flex');
    });
    
    // Selección de método de pago
    $('.payment-method').click(function() {
        $('.payment-method').removeClass('selected');
        $(this).addClass('selected');
        
        var method = $(this).data('method');
        metodoPagoSeleccionado = method;
        
        $('.payment-form').hide();
        $('#' + method + 'Form').show();
    });
    
    // Cancelar pago
    $('#cancelPayment, #cancelYape').click(function() {
        $('#paymentModal').hide();
    });
    
    // Validación de tarjeta de crédito
    $('#cardNumber').on('input', function() {
        var value = $(this).val().replace(/\s+/g, '').replace(/[^0-9]/g, '');
        if (value.length > 0) {
            value = value.match(new RegExp('.{1,4}', 'g')).join(' ');
        }
        $(this).val(value);
        
        if (value.replace(/\s+/g, '').length === 16) {
            $(this).removeClass('input-error');
            $('#cardNumberError').hide();
        } else {
            $(this).addClass('input-error');
            $('#cardNumberError').show();
        }
    });
    
    // Validación de fecha de expiración
    $('#expiryDate').on('input', function() {
        var value = $(this).val().replace(/\//g, '').replace(/[^0-9]/g, '');
        if (value.length > 2) {
            value = value.substring(0, 2) + '/' + value.substring(2, 4);
        }
        $(this).val(value);
        
        var isValid = /^(0[1-9]|1[0-2])\/?([0-9]{2})$/.test(value);
        if (isValid) {
            $(this).removeClass('input-error');
            $('#expiryDateError').hide();
        } else {
            $(this).addClass('input-error');
            $('#expiryDateError').show();
        }
    });
    
    // Validación de CVV
    $('#cvv').on('input', function() {
        var value = $(this).val().replace(/[^0-9]/g, '');
        $(this).val(value);
        
        if (value.length === 3) {
            $(this).removeClass('input-error');
            $('#cvvError').hide();
        } else {
            $(this).addClass('input-error');
            $('#cvvError').show();
        }
    });
    
    // Validación de nombre en tarjeta
    $('#cardName').on('input', function() {
        if ($(this).val().trim().length > 0) {
            $(this).removeClass('input-error');
            $('#cardNameError').hide();
        } else {
            $(this).addClass('input-error');
            $('#cardNameError').show();
        }
    });
    
    // Confirmar pago con tarjeta
    $('#confirmPayment').click(function() {
        // Validación completa
        var isValid = true;
        
        if ($('#cardNumber').val().replace(/\s+/g, '').length !== 16) {
            $('#cardNumber').addClass('input-error');
            $('#cardNumberError').show();
            isValid = false;
        }
        
        if (!/^(0[1-9]|1[0-2])\/?([0-9]{2})$/.test($('#expiryDate').val())) {
            $('#expiryDate').addClass('input-error');
            $('#expiryDateError').show();
            isValid = false;
        }
        
        if ($('#cvv').val().length !== 3) {
            $('#cvv').addClass('input-error');
            $('#cvvError').show();
            isValid = false;
        }
        
        if ($('#cardName').val().trim() === '') {
            $('#cardName').addClass('input-error');
            $('#cardNameError').show();
            isValid = false;
        }
        
        if (!isValid) {
            swal("Error", "Por favor complete todos los campos correctamente", "error");
            return;
        }
        
        // Simular pago exitoso
        swal({
            title: "Pago Exitoso!",
            text: "Su pago con tarjeta ha sido procesado correctamente",
            icon: "success"
        }).then(function() {
            $('#paymentModal').hide();
            $('#btnRealizarPago').hide();
            $('#btnGenerarCompra').show();
            $('#metodoPagoSelected').val(metodoPagoSeleccionado);
        });
    });
    
    // Confirmar pago con Yape
    $('#confirmYape').click(function() {
        swal({
            title: "Pago Exitoso!",
            text: "Su pago con Yape ha sido confirmado",
            icon: "success"
        }).then(function() {
            $('#paymentModal').hide();
            $('#btnRealizarPago').hide();
            $('#btnGenerarCompra').show();
            $('#metodoPagoSelected').val(metodoPagoSeleccionado);
        });
    });
    
    // Cancelar dirección
    $('#cancelAddress').click(function() {
        $('#addressModal').hide();
    });
    
    // Generar compra
    $('#btnGenerarCompra').click(function() {
        // Validar que se haya seleccionado método de pago
        if (!metodoPagoSeleccionado) {
            swal("Error", "Por favor seleccione un método de pago", "error");
            return;
        }
        
        // Determinar idPago (2 para tarjeta, 3 para yape)
        var idPago = metodoPagoSeleccionado === 'tarjeta' ? 2 : 3;
        
        console.log('Enviando datos:', {
            accion: 'generarCompra',
            metodoPago: idPago.toString()
        });
        
        // Enviar datos al servidor
        $.post('VentaControlador', {
            accion: 'generarCompra',
            metodoPago: idPago.toString()
        }, function(response) {
            console.log('Respuesta recibida:', response);
            
            if (response.success) {
                $('#addressModal').css('display', 'flex');
            } else {
                swal("Error", response.error || "Error al procesar la compra", "error");
            }
        }, 'json').fail(function(xhr, status, error) {
            console.log('Error details:', xhr.responseText);
            console.log('Status:', status);
            console.log('Error:', error);
            swal("Error", "Ocurrió un error al procesar la compra", "error");
        });
    });
    
    // Validación de formulario de dirección
    $('#addressForm').submit(function(e) {
        e.preventDefault();
        
        var isValid = true;
        
        // Validar campos requeridos
        if ($('#direccion').val().trim() === '') {
            $('#direccion').addClass('input-error');
            $('#direccionError').show();
            isValid = false;
        } else {
            $('#direccion').removeClass('input-error');
            $('#direccionError').hide();
        }
        
        if ($('#distrito').val() === '') {
            $('#distrito').addClass('input-error');
            $('#distritoError').show();
            isValid = false;
        } else {
            $('#distrito').removeClass('input-error');
            $('#distritoError').hide();
        }
        
        if ($('#ciudad').val() === '') {
            $('#ciudad').addClass('input-error');
            $('#ciudadError').show();
            isValid = false;
        } else {
            $('#ciudad').removeClass('input-error');
            $('#ciudadError').hide();
        }
        
        if ($('#referencia').val().trim() === '') {
            $('#referencia').addClass('input-error');
            $('#referenciaError').show();
            isValid = false;
        } else {
            $('#referencia').removeClass('input-error');
            $('#referenciaError').hide();
        }
        
        if (!isValid) {
            swal("Error", "Por favor complete todos los campos requeridos", "error");
            return;
        }
        
        // Enviar formulario
        $.post('VentaControlador', $(this).serialize(), function(response) {
            if (response.success) {
                var idVenta = response.idVenta;
                if (idVenta) {
                    swal({
                        title: "Compra Exitosa!",
                        text: "Su compra ha sido registrada correctamente",
                        icon: "success"
                    }).then(function() {
                        window.open('VentaControlador?accion=generarBoleta&id=' + idVenta, '_blank');
                        window.location.href = 'index.jsp';
                    });
                }
            } else {
                swal("Error", response.error || "Error al guardar la dirección", "error");
            }
        }, 'json').fail(function(xhr, status, error) {
            console.log('Error details:', xhr.responseText);
            swal("Error", "Ocurrió un error al guardar la dirección", "error");
        });
    });
    
    // Cerrar modal al hacer clic fuera
    $('.modal-overlay').click(function(e) {
        if (e.target === this) {
            $(this).hide();
        }
    });
    
    // Actualizar ciudad según distrito seleccionado
    $('#distrito').change(function() {
        var distrito = $(this).val();
        var ciudad = '';
        
        switch(distrito) {
            case 'Chiclayo':
            case 'José Leonardo Ortiz':
            case 'La Victoria':
            case 'Pimentel':
            case 'Santa Rosa':
                ciudad = 'Chiclayo';
                break;
            case 'Lambayeque':
            case 'Monsefú':
            case 'Eten':
            case 'Picsi':
            case 'Pomalca':
            case 'Reque':
            case 'San José':
            case 'Túcume':
                ciudad = 'Lambayeque';
                break;
            case 'Ferreñafe':
                ciudad = 'Ferreñafe';
                break;
        }
        
        $('#ciudad').val(ciudad);
    });
});