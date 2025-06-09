$(document).ready(function() {
    // New client button
    $('#btnNuevoCliente').click(function() {
        $('#nuevoClienteForm')[0].reset();
        $('#nuevoClienteModal').modal('show');
    });

    // Edit client button
    $(document).on('click', '.btn-editar', function() {
        const id = $(this).data('id');
        const $btn = $(this);
        $btn.prop('disabled', true);

        $.ajax({
            url: AppContext.endpoints.cliente.edit + id,
            type: 'GET',
            dataType: 'json',
            success: function(data) {
                $('#edit_id').val(data.id);
                $('#edit_dni').val(data.dni);
                $('#edit_nombre').val(data.nombre);
                $('#edit_apellido').val(data.apellido);
                $('#edit_telefono').val(data.telefono);

                $('#editarClienteModal').modal('show');
            },
            error: function(xhr) {
                Swal.fire({
                    icon: 'error',
                    title: 'Error',
                    text: xhr.responseText || 'Error al cargar el cliente',
                    timer: 3000
                });
            },
            complete: function() {
                $btn.prop('disabled', false);
            }
        });
    });

    // Form validation
    function validateClienteForm($form) {
        let isValid = true;
        
        // Clear previous validations
        $form.find('.is-invalid').removeClass('is-invalid');
        $form.find('.invalid-feedback').remove();

        // Validate required fields
        $form.find('[required]').each(function() {
            if (!$(this).val().trim()) {
                markAsInvalid($(this), AppContext.messages.requiredField);
                isValid = false;
            }
        });

        // Validate DNI format (8 digits)
        const $dni = $form.find('[name="dni"]');
        if ($dni.length && !/^\d{8}$/.test($dni.val())) {
            markAsInvalid($dni, AppContext.messages.dniInvalid);
            isValid = false;
        }

        // Validate phone format (9 digits if provided)
        const $telefono = $form.find('[name="telefono"]');
        if ($telefono.length && $telefono.val() && !/^\d{9}$/.test($telefono.val())) {
            markAsInvalid($telefono, AppContext.messages.telefonoInvalid);
            isValid = false;
        }

        return isValid;
    }

    function markAsInvalid($element, message) {
        $element.addClass('is-invalid');
        $element.after(`<div class="invalid-feedback">${message}</div>`);
    }

    // New client form submission
    $('#nuevoClienteForm').submit(function(e) {
        if (!validateClienteForm($(this))) {
            e.preventDefault();
            scrollToFirstError();
            return false;
        }
        showButtonLoading($(this).find('[type="submit"]'));
    });

    // Edit client form submission
    $('#editarClienteForm').submit(function(e) {
        if (!validateClienteForm($(this))) {
            e.preventDefault();
            scrollToFirstError();
            return false;
        }
        showButtonLoading($(this).find('[type="submit"]'));
    });

    function scrollToFirstError() {
        const $firstError = $('.is-invalid').first();
        if ($firstError.length) {
            $('html, body').animate({
                scrollTop: $firstError.offset().top - 100
            }, 500);
            $firstError.focus();
        }
    }

    function showButtonLoading($btn) {
        $btn.addClass('btn-loading')
            .prop('disabled', true)
            .html('<i class="fas fa-spinner fa-spin"></i> Procesando...');
    }

    // Filter form
    $('#filtroForm').submit(function(e) {
        e.preventDefault();
        showLoading();
        
        const $form = $(this);
        const params = $form.serialize();
        window.location.href = AppContext.endpoints.cliente.filter + '&' + params;
    });

    // Reset filters
    $('#btnResetFiltros').click(function() {
        $('#filtroForm')[0].reset();
        showLoading();
        window.location.href = AppContext.endpoints.cliente.list;
    });

    // Delete client
    $(document).on('click', '.btn-eliminar', function() {
        const id = $(this).data('id');
        
        $('#confirmModal').modal('show');
        $('#btn-confirmar').attr('href', AppContext.endpoints.cliente.delete + id);
    });

    // Consult DNI API
    $('#btnConsultarDni').click(function() {
        const dni = $('#dni').val().trim();
        
        if (!dni || !/^\d{8}$/.test(dni)) {
            markAsInvalid($('#dni'), AppContext.messages.dniInvalid);
            return;
        }
        
        const $btn = $(this);
        $btn.prop('disabled', true)
            .html('<i class="fas fa-spinner fa-spin"></i> Buscando...');
        
        $.ajax({
            url: AppContext.endpoints.cliente.consultarDni + dni,
            type: 'GET',
            dataType: 'json',
            success: function(data) {
                if (data.nombres && data.apellidoPaterno && data.apellidoMaterno) {
                    $('#nombre').val(data.nombres);
                    $('#apellido').val(data.apellidoPaterno + ' ' + data.apellidoMaterno);
                    $('#telefono').focus();
                    
                    Swal.fire({
                        icon: 'success',
                        title: 'Datos encontrados',
                        text: 'Los datos del DNI se han cargado automáticamente',
                        timer: 2000
                    });
                } else {
                    Swal.fire({
                        icon: 'info',
                        title: 'Datos no encontrados',
                        text: 'No se encontraron datos para este DNI. Por favor ingréselos manualmente.',
                        timer: 2000
                    });
                }
            },
            error: function(xhr) {
                Swal.fire({
                    icon: 'error',
                    title: 'Error',
                    text: xhr.responseJSON?.error || 'Error al consultar el DNI',
                    timer: 3000
                });
            },
            complete: function() {
                $btn.prop('disabled', false)
                    .html('<i class="fas fa-search"></i> Buscar');
            }
        });
    });

    // Loading overlay
    function showLoading() {
        if ($('.loading-overlay').length === 0) {
            $('body').append(`
                <div class="loading-overlay">
                    <div class="loading-spinner"></div>
                </div>
            `);
        }
    }

    function hideLoading() {
        $('.loading-overlay').remove();
    }

    // Modal events
    $('#nuevoClienteModal').on('shown.bs.modal', function() {
        $('#dni').focus();
    });

});
