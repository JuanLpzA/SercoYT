$(document).ready(function () {
    // New client button
    $('#btnNuevoCliente').click(function () {
        $('#nuevoClienteForm')[0].reset();
        $('#tipoDni').prop('checked', true);
        toggleFormFields('1');
        $('#nuevoClienteModal').modal('show');
    });

    // Toggle form fields based on client type (New client modal)
    $('input[name="tipoCliente"]').change(function () {
        toggleFormFields($(this).val());
    });

    // Toggle form fields based on client type (Edit client modal)
    $(document).on('change', '#editarClienteModal input[name="tipoCliente"]', function () {
        toggleEditFormFields($(this).val());
    });

    function toggleFormFields(tipo) {
        if (tipo === '1') { // DNI
            $('#labelDocumento').text('DNI *');
            $('#labelNombre').text('Nombre *');
            $('#helpDocumento').text('Ingrese el DNI para buscar automáticamente');
            $('#dni').attr('maxlength', '8').attr('pattern', '[0-9]{8}').attr('title', 'Ingrese 8 dígitos numéricos');
            $('#grupoApellido').show();
            $('#apellido').prop('required', true);
            $('#nombre').attr('maxlength', '50').attr('pattern', '[A-Za-záéíóúÁÉÍÓÚñÑ\\s]+');
            $('#btnConsultarDocumento').show();
        } else if (tipo === '2') { // RUC
            $('#labelDocumento').text('RUC *');
            $('#labelNombre').text('Razón Social *');
            $('#helpDocumento').text('Ingrese el RUC para buscar automáticamente');
            $('#dni').attr('maxlength', '11').attr('pattern', '[0-9]{11}').attr('title', 'Ingrese 11 dígitos numéricos');
            $('#grupoApellido').hide();
            $('#apellido').prop('required', false).val('');
            $('#nombre').attr('maxlength', '100').removeAttr('pattern');
            $('#btnConsultarDocumento').show();
        } else if (tipo === '3') { // Carnet de Extranjería
            $('#labelDocumento').text('Carnet de Extranjería *');
            $('#labelNombre').text('Nombre *');
            $('#helpDocumento').text('Ingrese el número de carnet de extranjería');
            $('#dni').attr('maxlength', '10').attr('pattern', '[0-9]{10}').attr('title', 'Ingrese 10 dígitos numéricos');
            $('#grupoApellido').show();
            $('#apellido').prop('required', true);
            $('#nombre').attr('maxlength', '50').attr('pattern', '[A-Za-záéíóúÁÉÍÓÚñÑ\\s]+');
            $('#btnConsultarDocumento').hide();
        }
        // Clear validation states
        $('#dni, #nombre, #apellido').removeClass('is-invalid').next('.invalid-feedback').remove();
    }

    function toggleEditFormFields(tipo) {
        if (tipo === '1') { // DNI
            $('#editLabelDocumento').text('DNI *');
            $('#editLabelNombre').text('Nombre *');
            $('#editHelpDocumento').text('Ingrese el DNI para buscar automáticamente');
            $('#edit_dni').attr('maxlength', '8').attr('pattern', '[0-9]{8}').attr('title', 'Ingrese 8 dígitos numéricos');
            $('#editGrupoApellido').show();
            $('#edit_apellido').prop('required', true);
            $('#edit_nombre').attr('maxlength', '50').attr('pattern', '[A-Za-záéíóúÁÉÍÓÚñÑ\\s]+');
            $('#btnConsultarDocumentoEdit').show();
        } else if (tipo === '2') { // RUC
            $('#editLabelDocumento').text('RUC *');
            $('#editLabelNombre').text('Razón Social *');
            $('#editHelpDocumento').text('Ingrese el RUC para buscar automáticamente');
            $('#edit_dni').attr('maxlength', '11').attr('pattern', '[0-9]{11}').attr('title', 'Ingrese 11 dígitos numéricos');
            $('#editGrupoApellido').hide();
            $('#edit_apellido').prop('required', false).val('');
            $('#edit_nombre').attr('maxlength', '100').removeAttr('pattern');
            $('#btnConsultarDocumentoEdit').show();
        } else if (tipo === '3') { // Carnet de Extranjería
            $('#editLabelDocumento').text('Carnet de Extranjería *');
            $('#editLabelNombre').text('Nombre *');
            $('#editHelpDocumento').text('Ingrese el número de carnet de extranjería');
            $('#edit_dni').attr('maxlength', '10').attr('pattern', '[0-9]{10}').attr('title', 'Ingrese 10 dígitos numéricos');
            $('#editGrupoApellido').show();
            $('#edit_apellido').prop('required', true);
            $('#edit_nombre').attr('maxlength', '50').attr('pattern', '[A-Za-záéíóúÁÉÍÓÚñÑ\\s]+');
            $('#btnConsultarDocumentoEdit').hide();
        }
        // Clear validation states
        $('#edit_dni, #edit_nombre, #edit_apellido').removeClass('is-invalid').next('.invalid-feedback').remove();
    }

    // Edit client button
    $(document).on('click', '.btn-editar', function () {
        const id = $(this).data('id');
        const $btn = $(this);
        $btn.prop('disabled', true);

        $.ajax({
            url: AppContext.endpoints.cliente.edit + id,
            type: 'GET',
            dataType: 'json',
            success: function (data) {
                // PRIMERO: Configurar el tipo de cliente y los campos
                const tipoCliente = data.tipoCliente || (data.dni.length === 8 ? '1' : '2');
                $('#edit_tipoClienteOriginal').val(tipoCliente);
                $('#edit_tipoClienteHidden').val(tipoCliente);

                if (data.tipoCliente === 1 || data.tipoCliente === '1') {
                    $('#editTipoDni').prop('checked', true);
                    toggleEditFormFields('1');
                } else if (data.tipoCliente === 2 || data.tipoCliente === '2') {
                    $('#editTipoRuc').prop('checked', true);
                    toggleEditFormFields('2');
                } else if (data.tipoCliente === 3 || data.tipoCliente === '3') {
                    $('#editTipoCarnet').prop('checked', true);
                    toggleEditFormFields('3');
                }

                // SEGUNDO: Llenar los campos con los datos (después de configurar las limitaciones)
                $('#edit_id').val(data.id);
                $('#edit_dni').val(data.dni);
                $('#edit_nombre').val(data.nombre);
                $('#edit_apellido').val(data.apellido);
                $('#edit_telefono').val(data.telefono);

                $('#editarClienteModal').modal('show');
            },
            error: function (xhr) {
                Swal.fire({
                    icon: 'error',
                    title: 'Error',
                    text: xhr.responseText || 'Error al cargar el cliente',
                    timer: 3000
                });
            },
            complete: function () {
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
        $form.find('[required]').each(function () {
            if (!$(this).val().trim()) {
                markAsInvalid($(this), AppContext.messages.requiredField);
                isValid = false;
            }
        });

        // Validate document format
        const $documento = $form.find('[name="dni"]');
        let tipoCliente = $form.find('input[name="tipoCliente"]:checked').val();

// Si no se encuentra (modal de edición con campos deshabilitados), usar el campo hidden
        if (!tipoCliente) {
            tipoCliente = $form.find('input[name="tipoCliente"][type="hidden"]').val();
        }

// Valor por defecto si aún no se encuentra
        tipoCliente = tipoCliente || '1';

        if (tipoCliente === '1') { // DNI
            if ($documento.length && !/^\d{8}$/.test($documento.val())) {
                markAsInvalid($documento, 'El DNI debe tener 8 dígitos numéricos');
                isValid = false;
            }
        } else if (tipoCliente === '2') { // RUC
            if ($documento.length && !/^\d{11}$/.test($documento.val())) {
                markAsInvalid($documento, 'El RUC debe tener 11 dígitos numéricos');
                isValid = false;
            }
        } else if (tipoCliente === '3') { // Carnet de Extranjería
            if ($documento.length && !/^\d{10}$/.test($documento.val())) {
                markAsInvalid($documento, 'El Carnet de Extranjería debe tener 10 dígitos numéricos');
                isValid = false;
            }
        }

        // Validate phone format (9 digits if provided)
        const $telefono = $form.find('[name="telefono"]');
        if ($telefono.length && $telefono.val() && !/^\d{9}$/.test($telefono.val())) {
            markAsInvalid($telefono, AppContext.messages.telefonoInvalid);
            isValid = false;
        }

        // Validar que para carnet de extranjería el apellido tenga al menos dos palabras
        if (tipoCliente === '3') {
            const $apellido = $form.find('[name="apellido"]');
            if ($apellido.length && $apellido.val()) {
                const apellidos = $apellido.val().trim().split(/\s+/);
                if (apellidos.length < 2) {
                    markAsInvalid($apellido, 'Debe ingresar al menos dos apellidos');
                    isValid = false;
                }
            }
        }

        return isValid;
    }

    function markAsInvalid($element, message) {
        $element.addClass('is-invalid');
        $element.after(`<div class="invalid-feedback">${message}</div>`);
    }

    // Validate unique document
    function validateUniqueDocument(documento, id, callback) {
        $.ajax({
            url: AppContext.endpoints.cliente.validarDocumento,
            type: 'GET',
            data: {documento: documento, id: id || ''},
            dataType: 'json',
            success: function (data) {
                callback(!data.existe);
            },
            error: function () {
                callback(true); // En caso de error, permitir continuar
            }
        });
    }

    // New client form submission
    $('#nuevoClienteForm').submit(function (e) {
        e.preventDefault();

        if (!validateClienteForm($(this))) {
            scrollToFirstError();
            return false;
        }

        const documento = $('#dni').val();
        const $btn = $(this).find('[type="submit"]');

        showButtonLoading($btn);

        validateUniqueDocument(documento, null, function (isUnique) {
            if (!isUnique) {
                Swal.fire({
                    icon: 'error',
                    title: 'Documento duplicado',
                    text: 'Este documento ya está registrado. Por favor verifique.',
                    timer: 3000
                });
                resetButton($btn);
                return;
            }

            // Submit form
            $('#nuevoClienteForm')[0].submit();
        });
    });

    // Edit client form submission
    $('#editarClienteForm').submit(function (e) {
        e.preventDefault();

        if (!validateClienteForm($(this))) {
            scrollToFirstError();
            return false;
        }

        const documento = $('#edit_dni').val();
        const id = $('#edit_id').val();
        const $btn = $(this).find('[type="submit"]');

        showButtonLoading($btn, 'edit');

        validateUniqueDocument(documento, id, function (isUnique) {
            if (!isUnique) {
                Swal.fire({
                    icon: 'error',
                    title: 'Documento duplicado',
                    text: 'Este documento ya está registrado. Por favor verifique.',
                    timer: 3000
                });
                resetEditButton($btn);
                return;
            }

            // Submit form
            $('#editarClienteForm')[0].submit();
        });
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

    function showButtonLoading($btn, type = 'new') {
        $btn.addClass('btn-loading')
                .prop('disabled', true)
                .html('<i class="fas fa-spinner fa-spin"></i> Procesando...');
    }

    function resetButton($btn) {
        $btn.removeClass('btn-loading')
                .prop('disabled', false)
                .html('<i class="fas fa-save"></i> Guardar Cliente');
    }

    function resetEditButton($btn) {
        $btn.removeClass('btn-loading')
                .prop('disabled', false)
                .html('<i class="fas fa-save"></i> Actualizar Cliente');
    }

    // Filter form
    $('#filtroForm').submit(function (e) {
        e.preventDefault();
        showLoading();

        const $form = $(this);
        const params = $form.serialize();
        window.location.href = AppContext.endpoints.cliente.filter + '&' + params;
    });

    // Reset filters
    $('#btnResetFiltros').click(function () {
        $('#filtroForm')[0].reset();
        showLoading();
        window.location.href = AppContext.endpoints.cliente.list;
    });

    // Delete client
    $(document).on('click', '.btn-eliminar', function () {
        const id = $(this).data('id');

        $('#confirmModal').modal('show');
        $('#btn-confirmar').attr('href', AppContext.endpoints.cliente.delete + id);
    });

    // Consult document API for new client modal
    $('#btnConsultarDocumento').click(function () {
        const documento = $('#dni').val().trim();
        const tipoCliente = $('input[name="tipoCliente"]:checked').val();

        if (tipoCliente === '1') { // DNI
            if (!documento || !/^\d{8}$/.test(documento)) {
                markAsInvalid($('#dni'), 'El DNI debe tener 8 dígitos numéricos');
                return;
            }
            consultarDni(documento, false);
        } else { // RUC
            if (!documento || !/^\d{11}$/.test(documento)) {
                markAsInvalid($('#dni'), 'El RUC debe tener 11 dígitos numéricos');
                return;
            }
            consultarRuc(documento, false);
        }
    });

    // Consult document API for edit client modal
    $('#btnConsultarDocumentoEdit').click(function () {
        const documento = $('#edit_dni').val().trim();
        const tipoCliente = $('#editarClienteModal input[name="tipoCliente"]:checked').val();

        if (tipoCliente === '1') { // DNI
            if (!documento || !/^\d{8}$/.test(documento)) {
                markAsInvalid($('#edit_dni'), 'El DNI debe tener 8 dígitos numéricos');
                return;
            }
            consultarDni(documento, true);
        } else { // RUC
            if (!documento || !/^\d{11}$/.test(documento)) {
                markAsInvalid($('#edit_dni'), 'El RUC debe tener 11 dígitos numéricos');
                return;
            }
            consultarRuc(documento, true);
        }
    });

    function consultarDni(dni, isEdit = false) {
        const btnId = isEdit ? '#btnConsultarDocumentoEdit' : '#btnConsultarDocumento';
        const $btn = $(btnId);

        $btn.prop('disabled', true)
                .html('<i class="fas fa-spinner fa-spin"></i> Buscando...');

        $.ajax({
            url: AppContext.endpoints.cliente.consultarDni + dni,
            type: 'GET',
            dataType: 'json',
            success: function (data) {
                if (data.nombres && data.apellidoPaterno && data.apellidoMaterno) {
                    const nombreField = isEdit ? '#edit_nombre' : '#nombre';
                    const apellidoField = isEdit ? '#edit_apellido' : '#apellido';
                    const telefonoField = isEdit ? '#edit_telefono' : '#telefono';

                    $(nombreField).val(data.nombres);
                    $(apellidoField).val(data.apellidoPaterno + ' ' + data.apellidoMaterno);
                    $(telefonoField).focus();

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
            error: function (xhr) {
                Swal.fire({
                    icon: 'error',
                    title: 'Error',
                    text: xhr.responseJSON?.error || 'Error al consultar el DNI',
                    timer: 3000
                });
            },
            complete: function () {
                $btn.prop('disabled', false)
                        .html('<i class="fas fa-search"></i> Buscar');
            }
        });
    }

    function consultarRuc(ruc, isEdit = false) {
        const btnId = isEdit ? '#btnConsultarDocumentoEdit' : '#btnConsultarDocumento';
        const $btn = $(btnId);

        $btn.prop('disabled', true)
                .html('<i class="fas fa-spinner fa-spin"></i> Buscando...');

        $.ajax({
            url: AppContext.endpoints.cliente.consultarRuc + ruc,
            type: 'GET',
            dataType: 'json',
            success: function (data) {
                if (data.nombre || data.razonSocial) {
                    const nombreField = isEdit ? '#edit_nombre' : '#nombre';
                    const telefonoField = isEdit ? '#edit_telefono' : '#telefono';

                    const razonSocial = data.nombre || data.razonSocial;
                    $(nombreField).val(razonSocial);
                    $(telefonoField).focus();

                    Swal.fire({
                        icon: 'success',
                        title: 'Datos encontrados',
                        text: 'Los datos del RUC se han cargado automáticamente',
                        timer: 2000
                    });
                } else {
                    Swal.fire({
                        icon: 'info',
                        title: 'Datos no encontrados',
                        text: 'No se encontraron datos para este RUC. Por favor ingréselos manualmente.',
                        timer: 2000
                    });
                }
            },
            error: function (xhr) {
                Swal.fire({
                    icon: 'error',
                    title: 'Error',
                    text: xhr.responseJSON?.error || 'Error al consultar el RUC',
                    timer: 3000
                });
            },
            complete: function () {
                $btn.prop('disabled', false)
                        .html('<i class="fas fa-search"></i> Buscar');
            }
        });
    }

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

    $(document).on('click', '.btn-cambiar-estado', function () {
        const id = $(this).data('id');
        const estado = $(this).data('estado');

        Swal.fire({
            title: 'Confirmar cambio',
            text: `¿Está seguro que desea ${estado === 'activo' ? 'activar' : 'desactivar'} este cliente?`,
            icon: 'warning',
            showCancelButton: true,
            confirmButtonText: 'Sí, cambiar',
            cancelButtonText: 'Cancelar'
        }).then((result) => {
            if (result.isConfirmed) {
                showLoading();

                // Primero hacer el cambio de estado
                $.ajax({
                    url: AppContext.endpoints.cliente.cambiarEstado,
                    type: 'POST',
                    data: {
                        id: id,
                        estado: estado
                    },
                    success: function (response) {
                        // Después del cambio exitoso, redirigir al list
                        window.location.href = AppContext.endpoints.cliente.list;
                    },
                    error: function (xhr, status, error) {
                        hideLoading();
                        Swal.fire({
                            title: 'Error',
                            text: 'Error al cambiar el estado del cliente',
                            icon: 'error'
                        });
                    }
                });
            }
        });
    });


    function hideLoading() {
        $('.loading-overlay').remove();
    }

    // Modal events
    $('#nuevoClienteModal').on('shown.bs.modal', function () {
        $('#dni').focus();
    });

    $('#editarClienteModal').on('shown.bs.modal', function () {
        $('#edit_dni').focus();
    });

    $('.modal').on('hidden.bs.modal', function () {
        $(this).find('form').trigger('reset');
        $(this).find('.is-invalid').removeClass('is-invalid');
        $(this).find('.invalid-feedback').remove();
    });

    // Auto-dismiss alerts
    setTimeout(function () {
        $('.alert').fadeOut();
    }, 5000);

    // Hide loading when page fully loads
    $(window).on('load', function () {
        hideLoading();
    });
});