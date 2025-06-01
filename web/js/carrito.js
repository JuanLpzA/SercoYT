$(document).ready(function() {
    var metodoPagoSeleccionado = '';
    var googleMapsLoaded = false;
    
   

    // 2. Inicializar autocompletado de direcciones (versión corregida)
    function initAutocomplete() {
        const provincia = $('#provincia').val();
        if (!provincia) {
            $('#autocomplete').prop('disabled', true);
            $('#autocomplete').attr('placeholder', 'Seleccione una provincia primero');
            return;
        }

        $('#autocomplete').prop('disabled', false);
        $('#autocomplete').attr('placeholder', 'Escribe tu dirección');

        // Limpiar autocomplete anterior si existe
        if (window.currentAutocomplete) {
            google.maps.event.clearInstanceListeners(window.currentAutocomplete);
        }

        // Configurar bounds según la provincia seleccionada
        let bounds;
        switch (provincia.toLowerCase()) {
            case 'chiclayo':
                bounds = new google.maps.LatLngBounds(
                        new google.maps.LatLng(-6.85, -79.95),
                        new google.maps.LatLng(-6.70, -79.80)
                        );
                break;
            case 'ferreñafe':
                bounds = new google.maps.LatLngBounds(
                        new google.maps.LatLng(-6.65, -79.85),
                        new google.maps.LatLng(-6.55, -79.70)
                        );
                break;
            case 'lambayeque':
                bounds = new google.maps.LatLngBounds(
                        new google.maps.LatLng(-6.75, -79.95),
                        new google.maps.LatLng(-6.60, -79.85)
                        );
                break;
        }

        const input = document.getElementById('autocomplete');
        const options = {
            bounds: bounds,
            strictBounds: true,
            types: ['address'],
            componentRestrictions: {country: 'pe'},
            fields: ['address_components', 'formatted_address', 'geometry']
        };

        window.currentAutocomplete = new google.maps.places.Autocomplete(input, options);

        window.currentAutocomplete.addListener('place_changed', function () {
            const place = window.currentAutocomplete.getPlace();
            if (!place.address_components) {
                $('#autocomplete').addClass('input-error');
                $('#direccionError').text('Seleccione una dirección válida de la lista').show();
                return;
            }

            // Verificar que la dirección esté dentro de los bounds
            if (bounds && !bounds.contains(place.geometry.location)) {
                swal("Ubicación no válida", "La dirección debe estar en " + provincia, "error");
                $('#autocomplete').val('');
                return;
            }

            $('#autocomplete').removeClass('input-error');
            $('#direccionError').hide();
        });
    }

    // 3. Configurar modales para evitar cierre accidental
    function setupModalBehavior() {
        $('.modal-overlay').click(function(e) {
            if (e.target === this) {
                if (!confirm("¿Estás seguro de que quieres cancelar el proceso de compra? Los datos no guardados se perderán.")) {
                    return;
                }
                $(this).fadeOut();
            }
        });
        
        $('.close-modal').click(function() {
            if (!confirm("¿Estás seguro de que quieres cancelar el proceso de compra? Los datos no guardados se perderán.")) {
                return;
            }
            $(this).closest('.modal-overlay').fadeOut();
        });
    }

// 4. Validación de formulario de dirección (actualizado)
    function validateAddressForm() {
        let isValid = true;

        // Validar nombre del receptor
        if ($('#nombreReceptor').val().trim() === '') {
            $('#nombreReceptor').addClass('input-error');
            $('#nombreReceptorError').text('Ingrese el nombre del receptor').show();
            isValid = false;
        } else {
            $('#nombreReceptor').removeClass('input-error');
            $('#nombreReceptorError').hide();
        }

        // Validar teléfono
        let telefono = $('#telefonoContacto').val().trim(); // elimina espacios antes/después
        telefono = telefono.replace(/\s+/g, ''); // elimina espacios dentro del string (si hubiera)

        if (!/^\d{9}$/.test(telefono)) {
            $('#telefonoContacto').addClass('input-error');
            $('#telefonoError').text('Ingrese un número válido de 9 dígitos (solo números)').show();
            isValid = false;
        } else {
            $('#telefonoContacto').removeClass('input-error');
            $('#telefonoError').hide();
        }

        // Validar provincia
        if ($('#provincia').val() === '') {
            $('#provincia').addClass('input-error');
            $('#provinciaError').text('Seleccione una provincia').show();
            isValid = false;
        } else {
            $('#provincia').removeClass('input-error');
            $('#provinciaError').hide();
        }

        // Validar dirección
        if ($('#autocomplete').val().trim() === '') {
            $('#autocomplete').addClass('input-error');
            $('#direccionError').text('Ingrese una dirección válida').show();
            isValid = false;
        } else if ($('#autocomplete').val().trim().length < 10) {
            $('#autocomplete').addClass('input-error');
            $('#direccionError').text('La dirección es demasiado corta').show();
            isValid = false;
        } else {
            $('#autocomplete').removeClass('input-error');
            $('#direccionError').hide();
        }
        
        // Validar código postal si se ingresó
        const codigoPostal = $('#codigoPostal').val().trim();
        if (codigoPostal !== '') {
            // Códigos postales válidos para Lambayeque (rangos aproximados)
            const codigosValidos = {
                'Chiclayo': /^13[7-8]\d{2}$/,
                'Ferreñafe': /^141\d{2}$/,
                'Lambayeque': /^14[0-1]\d{2}$/
            };

            const provincia = $('#provincia').val();
            const regex = codigosValidos[provincia];

            if (!regex || !regex.test(codigoPostal)) {
                $('#codigoPostal').addClass('input-error');
                $('#codigoPostalError').text('Código postal no válido para ' + provincia).show();
                isValid = false;
            } else {
                $('#codigoPostal').removeClass('input-error');
                $('#codigoPostalError').hide();
            }
        }

        return isValid;
    }
    
// 5. Construir objeto de dirección para enviar al servidor (actualizado)
    function buildShippingData() {
        return {
            nombreReceptor: $('#nombreReceptor').val().trim(),
            telefono: $('#telefonoContacto').val().trim(),
            provincia: $('#provincia').val(),
            direccion: $('#autocomplete').val().trim(),
            referencia: $('#referencia').val().trim(),
            codigoPostal: $('#codigoPostal').val().trim()
        };
    }
    
    // 6. Procesar pago simulado
    function processPayment() {
        return new Promise((resolve) => {
            // Simular procesamiento de pago
            const paymentMethod = metodoPagoSeleccionado === 'tarjeta' ? 'Tarjeta' : 'Yape';
            
            swal({
                title: "Procesando pago",
                text: `Estamos procesando su pago con ${paymentMethod}`,
                icon: "info",
                buttons: false,
                closeOnClickOutside: false,
                closeOnEsc: false
            });
            
            setTimeout(() => {
                swal.close();
                resolve();
            }, 2000);
        });
    }
    
    // 7. Generar orden de compra completa
    function generateCompleteOrder() {
        const shippingData = buildShippingData();
        
        swal({
            title: "Procesando compra",
            text: "Estamos registrando su pedido",
            icon: "info",
            buttons: false,
            closeOnClickOutside: false,
            closeOnEsc: false
        });
        
        // Determinar idPago (2 para tarjeta, 3 para yape)
        const idPago = metodoPagoSeleccionado === 'tarjeta' ? 2 : 3;
        
        $.ajax({
            url: 'VentaControlador',
            type: 'POST',
            data: {
                accion: 'generarCompraCompleta',
                metodoPago: idPago,
                direccion: JSON.stringify(shippingData)
            },
            dataType: 'json',
            success: function(response) {
                swal.close();
                
                if (response.success) {
                    // Mostrar boleta y redirigir
                    window.open('VentaControlador?accion=generarBoleta&id=' + response.idVenta, '_blank');
                    
                    swal({
                        title: "¡Compra exitosa!",
                        text: "Su pedido sera entregado de 1 a 3 dias habiles",
                        icon: "success"
                    }).then(() => {
                        window.location.href = 'index.jsp';
                    });
                } else {
                    swal("Error", response.error || "Ocurrió un error al procesar su compra", "error");
                }
            },
            error: function(xhr) {
                swal.close();
                swal("Error", "Ocurrió un error al comunicarse con el servidor", "error");
                console.error("Error en la solicitud AJAX:", xhr.responseText);
            }
        });
    }
    
    // 8. Inicialización principal
    function initialize() {
        setupModalBehavior();
        
        
        

        // Mostrar modal de dirección al hacer clic en Generar Compra
        $('#btnGenerarCompra').click(function () {
            $('#addressModal').css('display', 'flex');
        });
        
        // Selección de método de pago
        $('.payment-method').click(function() {
            $('.payment-method').removeClass('selected');
            $(this).addClass('selected');
            
            metodoPagoSeleccionado = $(this).data('method');
            $('.payment-form').hide();
            $('#' + metodoPagoSeleccionado + 'Form').show();
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
        $('#expiryDate').on('input', function () {
            var value = $(this).val().replace(/\//g, '').replace(/[^0-9]/g, '');
            if (value.length > 2) {
                value = value.substring(0, 2) + '/' + value.substring(2, 4);
            }
            $(this).val(value);

            var isValidFormat = /^(0[1-9]|1[0-2])\/?([0-9]{2})$/.test(value);

            if (isValidFormat) {
                var parts = value.split('/');
                var inputMonth = parseInt(parts[0], 10);
                var inputYear = parseInt('20' + parts[1], 10); // convierte '25' en 2025

                var today = new Date();
                var currentMonth = today.getMonth() + 1; // enero = 0
                var currentYear = today.getFullYear();

                // Verifica que la fecha no haya expirado
                if (inputYear > currentYear || (inputYear === currentYear && inputMonth >= currentMonth)) {
                    $(this).removeClass('input-error');
                    $('#expiryDateError').hide();
                } else {
                    $(this).addClass('input-error');
                    $('#expiryDateError').text('La tarjeta ya expiró').show();
                }

            } else {
                $(this).addClass('input-error');
                $('#expiryDateError').text('Formato MM/AA (ej. 12/25)').show();
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
        
        // Confirmar dirección y continuar con pago
        $('#confirmAddress').click(function() {
            if (validateAddressForm()) {
                $('#addressModal').fadeOut();
                $('#paymentModal').css('display', 'flex');
            }
        });
        
        // Cancelar dirección
        $('#cancelAddress').click(function() {
            if (confirm("¿Estás seguro de que quieres cancelar el proceso de compra?")) {
                $('#addressModal').fadeOut();
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
            
            // Procesar pago y luego generar orden
            processPayment().then(() => {
                $('#paymentModal').hide();
                generateCompleteOrder();
            });
        });
        
        // Confirmar pago con Yape
        $('#confirmYape').click(function() {
            processPayment().then(() => {
                $('#paymentModal').hide();
                generateCompleteOrder();
            });
        });
        
        // Cancelar pago
        $('#cancelPayment, #cancelYape').click(function() {
            if (confirm("¿Estás seguro de que quieres cancelar el pago?")) {
                $('#paymentModal').hide();
            }
        });
        
        
    }
    
    // Iniciar la aplicación
    initialize();
});