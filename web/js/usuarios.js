
$(document).ready(function() {
    // New user button
    $('#btnNuevoUsuario').click(function() {
        $('#seleccionarTipoModal').modal('show');
    });

    // Select user type
    $('.tipo-option').click(function() {
        const tipoUsuario = $(this).data('tipo');
        $('#tipoUsuario').val(tipoUsuario);
        $('#seleccionarTipoModal').modal('hide');
        $('#nuevoUsuarioForm')[0].reset();
        $('#nuevoUsuarioModal').modal('show');
    });

    // Consult DNI API
    $('#btnConsultarDni').click(function() {
        const dni = $('#dni').val().trim();
        
        if (dni.length !== 8 || !/^\d+$/.test(dni)) {
            Swal.fire({
                icon: 'error',
                title: 'DNI Inválido',
                text: 'El DNI debe tener exactamente 8 dígitos numéricos',
                timer: 3000
            });
            return;
        }
        
        $.ajax({
            url: AppContext.endpoints.usuario.consultarDni + dni,
            type: 'GET',
            dataType: 'json',
            success: function(data) {
                if (data.error) {
                    Swal.fire({
                        icon: 'error',
                        title: 'Error',
                        text: data.error,
                        timer: 3000
                    });
                } else {
                    $('#nombre').val(data.nombres || '');
                    $('#apellido').val(data.apellidoPaterno + ' ' + (data.apellidoMaterno || ''));
                }
            },
            error: function(xhr) {
                Swal.fire({
                    icon: 'error',
                    title: 'Error',
                    text: 'No se pudo consultar el DNI',
                    timer: 3000
                });
            }
        });
    });

    // Edit user button
    $(document).on('click', '.btn-editar', function() {
        const id = $(this).data('id');
        const $btn = $(this);
        $btn.prop('disabled', true);

        $.ajax({
            url: AppContext.endpoints.usuario.edit + id,
            type: 'GET',
            dataType: 'json',
            success: function(data) {
                $('#edit_id').val(data.idUsuario);
                $('#edit_nombre').val(data.nombre);
                $('#edit_apellido').val(data.apellido);
                $('#edit_dni').val(data.dni);
                $('#edit_correo').val(data.correo || '');
                $('#edit_telefono').val(data.telefono || '');
                $('#edit_direccion').val(data.direccion || '');
                $('#edit_estado').val(data.estado);
                $('#editarUsuarioModal').modal('show');
            },
            error: function(xhr) {
                Swal.fire({
                    icon: 'error',
                    title: 'Error',
                    text: xhr.responseText || 'Error al cargar el usuario',
                    timer: 3000
                });
            },
            complete: function() {
                $btn.prop('disabled', false);
            }
        });
    });

    // Promote user button
    $(document).on('click', '.btn-ascender', function() {
        const id = $(this).data('id');
        const $btn = $(this);
        $btn.prop('disabled', true);

        $.ajax({
            url: AppContext.endpoints.usuario.edit + id,
            type: 'GET',
            dataType: 'json',
            success: function(data) {
                $('#rol_id').val(data.idUsuario);
                $('#rol_actual').val(data.tipoUsuario);
                
                // Set the current role as selected in the dropdown
                const tipoUsuarioMap = {
                    'administrador': 1,
                    'vendedor': 2,
                    'cliente': 3
                };
                
                $('#nuevo_rol').val(tipoUsuarioMap[data.tipoUsuario.toLowerCase()]);
                $('#cambiarRolModal').modal('show');
            },
            error: function(xhr) {
                Swal.fire({
                    icon: 'error',
                    title: 'Error',
                    text: xhr.responseText || 'Error al cargar el usuario',
                    timer: 3000
                });
            },
            complete: function() {
                $btn.prop('disabled', false);
            }
        });
    });

    // Change password button
    $(document).on('click', '.btn-contrasena', function() {
        const id = $(this).data('id');
        $('#contrasena_id').val(id);
        $('#cambiarContrasenaForm')[0].reset();
        $('#cambiarContrasenaModal').modal('show');
    });

    // Form validation
    function validateUsuarioForm($form) {
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

    // Validaciones para nuevo usuario
    if ($form.attr('id') === 'nuevoUsuarioForm') {
        const contrasena = $('#contrasena').val();
        const confirmarContrasena = $('#confirmarContrasena').val();
        
        if (contrasena && confirmarContrasena && contrasena !== confirmarContrasena) {
            markAsInvalid($('#confirmarContrasena'), AppContext.messages.contrasenaNoCoincide);
            isValid = false;
        }
        
        if (contrasena && !/(?=.*[a-zA-Z])(?=.*[0-9]).{8,}/.test(contrasena)) {
            markAsInvalid($('#contrasena'), AppContext.messages.contrasenaInvalida);
            isValid = false;
        }
    }

    // Validaciones para cambiar contraseña
    if ($form.attr('id') === 'cambiarContrasenaForm') {
        const contrasena = $('#nueva_contrasena').val();
        const confirmarContrasena = $('#confirmar_nueva_contrasena').val();
        
        if (contrasena && confirmarContrasena && contrasena !== confirmarContrasena) {
            markAsInvalid($('#confirmar_nueva_contrasena'), AppContext.messages.contrasenaNoCoincide);
            isValid = false;
        }
        
        if (contrasena && !/(?=.*[a-zA-Z])(?=.*[0-9]).{8,}/.test(contrasena)) {
            markAsInvalid($('#nueva_contrasena'), AppContext.messages.contrasenaInvalida);
            isValid = false;
        }
    }

    // Validar DNI solo si existe en el formulario
    const dniInput = $form.find('[name="dni"]');
    if (dniInput.length && (dniInput.val().length !== 8 || !/^\d+$/.test(dniInput.val()))) {
        markAsInvalid(dniInput, AppContext.messages.dniInvalido);
        isValid = false;
    }

    return isValid;
}

    function markAsInvalid($element, message) {
        $element.addClass('is-invalid');
        $element.after(`<div class="invalid-feedback">${message}</div>`);
    }

    // New user form submission
    $('#nuevoUsuarioForm').submit(function(e) {
        e.preventDefault();
        
        if (!validateUsuarioForm($(this))) {
            scrollToFirstError();
            return false;
        }

        const $form = $(this);
        const $submitBtn = $form.find('[type="submit"]');
        const originalBtnText = $submitBtn.html();
        
        // Mostrar loading en el botón
        $submitBtn.prop('disabled', true).html('<i class="fas fa-spinner fa-spin"></i> Guardando...');

        $.ajax({
            url: $form.attr('action'),
            type: 'POST',
            data: $form.serialize(),
            dataType: 'json',
            success: function(response) {
                if (response.success) {
                    // Cerrar modal
                    $('#nuevoUsuarioModal').modal('hide');
                    
                    // Mostrar mensaje de éxito
                    Swal.fire({
                        icon: 'success',
                        title: '¡Éxito!',
                        text: response.message,
                        timer: 2000,
                        showConfirmButton: false
                    }).then(() => {
                        // Recargar la página para mostrar el nuevo usuario
                        window.location.reload();
                    });
                } else {
                    // Mostrar error específico sin cerrar el modal
                    Swal.fire({
                        icon: 'error',
                        title: 'Error al crear usuario',
                        text: response.message,
                        confirmButtonText: 'Entendido'
                    });
                }
            },
            error: function(xhr) {
                let errorMessage = 'Error al procesar la solicitud';
                try {
                    const response = JSON.parse(xhr.responseText);
                    errorMessage = response.message || errorMessage;
                } catch (e) {
                    errorMessage = xhr.responseText || errorMessage;
                }
                
                Swal.fire({
                    icon: 'error',
                    title: 'Error',
                    text: errorMessage,
                    confirmButtonText: 'Entendido'
                });
            },
            complete: function() {
                // Restaurar botón
                $submitBtn.prop('disabled', false).html(originalBtnText);
            }
        });
    });

    // Edit user form submission
    $('#editarUsuarioForm').submit(function(e) {
        e.preventDefault();
        
        if (!validateUsuarioForm($(this))) {
            scrollToFirstError();
            return false;
        }

        const $form = $(this);
        const $submitBtn = $form.find('[type="submit"]');
        const originalBtnText = $submitBtn.html();
        
        // Mostrar loading en el botón
        $submitBtn.prop('disabled', true).html('<i class="fas fa-spinner fa-spin"></i> Actualizando...');

        $.ajax({
            url: $form.attr('action'),
            type: 'POST',
            data: $form.serialize(),
            dataType: 'json',
            success: function(response) {
                if (response.success) {
                    // Cerrar modal
                    $('#editarUsuarioModal').modal('hide');
                    
                    // Mostrar mensaje de éxito
                    Swal.fire({
                        icon: 'success',
                        title: '¡Éxito!',
                        text: response.message,
                        timer: 2000,
                        showConfirmButton: false
                    }).then(() => {
                        // Recargar la página para mostrar los cambios
                        window.location.reload();
                    });
                } else {
                    // Mostrar error específico sin cerrar el modal
                    Swal.fire({
                        icon: 'error',
                        title: 'Error al actualizar usuario',
                        text: response.message,
                        confirmButtonText: 'Entendido'
                    });
                }
            },
            error: function(xhr) {
                let errorMessage = 'Error al procesar la solicitud';
                try {
                    const response = JSON.parse(xhr.responseText);
                    errorMessage = response.message || errorMessage;
                } catch (e) {
                    errorMessage = xhr.responseText || errorMessage;
                }
                
                Swal.fire({
                    icon: 'error',
                    title: 'Error',
                    text: errorMessage,
                    confirmButtonText: 'Entendido'
                });
            },
            complete: function() {
                // Restaurar botón
                $submitBtn.prop('disabled', false).html(originalBtnText);
            }
        });
    });

    // Change role form submission
    $('#cambiarRolForm').submit(function(e) {
        e.preventDefault();
        
        const $form = $(this);
        const $submitBtn = $form.find('[type="submit"]');
        const originalBtnText = $submitBtn.html();
        
        // Mostrar loading en el botón
        $submitBtn.prop('disabled', true).html('<i class="fas fa-spinner fa-spin"></i> Actualizando...');

        $.ajax({
            url: $form.attr('action'),
            type: 'POST',
            data: $form.serialize(),
            dataType: 'json',
            success: function(response) {
                if (response.success) {
                    // Cerrar modal
                    $('#cambiarRolModal').modal('hide');
                    
                    // Mostrar mensaje de éxito
                    Swal.fire({
                        icon: 'success',
                        title: '¡Éxito!',
                        text: response.message,
                        timer: 2000,
                        showConfirmButton: false
                    }).then(() => {
                        // Recargar la página para mostrar los cambios
                        window.location.reload();
                    });
                } else {
                    // Mostrar error específico
                    Swal.fire({
                        icon: 'error',
                        title: 'Error al cambiar rol',
                        text: response.message,
                        confirmButtonText: 'Entendido'
                    });
                }
            },
            error: function(xhr) {
                let errorMessage = 'Error al procesar la solicitud';
                try {
                    const response = JSON.parse(xhr.responseText);
                    errorMessage = response.message || errorMessage;
                } catch (e) {
                    errorMessage = xhr.responseText || errorMessage;
                }
                
                Swal.fire({
                    icon: 'error',
                    title: 'Error',
                    text: errorMessage,
                    confirmButtonText: 'Entendido'
                });
            },
            complete: function() {
                // Restaurar botón
                $submitBtn.prop('disabled', false).html(originalBtnText);
            }
        });
    });

    // Change password form submission
    $('#cambiarContrasenaForm').submit(function(e) {
        e.preventDefault();
        
        if (!validateUsuarioForm($(this))) {
            scrollToFirstError();
            return false;
        }

        const $form = $(this);
        const $submitBtn = $form.find('[type="submit"]');
        const originalBtnText = $submitBtn.html();
        
        // Mostrar loading en el botón
        $submitBtn.prop('disabled', true).html('<i class="fas fa-spinner fa-spin"></i> Actualizando...');

        $.ajax({
            url: $form.attr('action'),
            type: 'POST',
            data: $form.serialize(),
            dataType: 'json',
            success: function(response) {
                if (response.success) {
                    // Cerrar modal
                    $('#cambiarContrasenaModal').modal('hide');
                    
                    // Mostrar mensaje de éxito
                    Swal.fire({
                        icon: 'success',
                        title: '¡Éxito!',
                        text: response.message,
                        timer: 2000,
                        showConfirmButton: false
                    }).then(() => {
                        // Recargar la página para mostrar los cambios
                        window.location.reload();
                    });
                } else {
                    // Mostrar error específico sin cerrar el modal
                    Swal.fire({
                        icon: 'error',
                        title: 'Error al cambiar contraseña',
                        text: response.message,
                        confirmButtonText: 'Entendido'
                    });
                }
            },
            error: function(xhr) {
                let errorMessage = 'Error al procesar la solicitud';
                try {
                    const response = JSON.parse(xhr.responseText);
                    errorMessage = response.message || errorMessage;
                } catch (e) {
                    errorMessage = xhr.responseText || errorMessage;
                }
                
                Swal.fire({
                    icon: 'error',
                    title: 'Error',
                    text: errorMessage,
                    confirmButtonText: 'Entendido'
                });
            },
            complete: function() {
                // Restaurar botón
                $submitBtn.prop('disabled', false).html(originalBtnText);
            }
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

    // Filter form
    $('#filtroForm').submit(function(e) {
        e.preventDefault();
        showLoading();
        
        const $form = $(this);
        const params = $form.serialize();
        window.location.href = AppContext.endpoints.usuario.filter + '&' + params;
    });

    // Reset filters
    $('#btnResetFiltros').click(function() {
        $('#filtroForm')[0].reset();
        showLoading();
        window.location.href = AppContext.endpoints.usuario.list;
    });

    // Activate/deactivate user
    $(document).on('click', '.btn-desactivar, .btn-activar', function() {
        const isActivate = $(this).hasClass('btn-activar');
        const id = $(this).data('id');
        
        Swal.fire({
            title: isActivate ? 'Confirmar Activación' : 'Confirmar Desactivación',
            text: isActivate ? 
                '¿Está seguro que desea activar este usuario?' : 
                '¿Está seguro que desea desactivar este usuario?',
            icon: 'warning',
            showCancelButton: true,
            confirmButtonColor: isActivate ? '#28a745' : '#dc3545',
            confirmButtonText: isActivate ? 'Activar' : 'Desactivar',
            cancelButtonText: 'Cancelar'
        }).then((result) => {
            if (result.isConfirmed) {
                const url = isActivate ? 
                    AppContext.endpoints.usuario.activate + id : 
                    AppContext.endpoints.usuario.deactivate + id;
                window.location.href = url;
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
    $('#nuevoUsuarioModal').on('shown.bs.modal', function() {
        $('#dni').focus();
    });

    $('.modal').on('hidden.bs.modal', function() {
        $(this).find('form').trigger('reset');
        $(this).find('.is-invalid').removeClass('is-invalid');
        $(this).find('.invalid-feedback').remove();
    });

    // Auto-dismiss alerts
    setTimeout(function() {
        $('.alert').fadeOut();
    }, 5000);

    // Tooltips
    $('[data-toggle="tooltip"], .btn-action').tooltip({
        placement: 'top',
        trigger: 'hover'
    });

    // Hide loading when page fully loads
    $(window).on('load', function() {
        hideLoading();
    });
});