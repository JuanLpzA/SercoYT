$(function() {
    // Abrir modal nuevo rol
    $('#btnNuevoRol').click(function() {
        $('#formNuevoRol')[0].reset();
        $('#modalNuevoRol').modal('show');
    });

    // Validación AJAX antes de guardar nuevo rol
    $('#formNuevoRol').submit(function(e) {
        e.preventDefault();
        const form = this;
        const nombre = $(form).find('[name="nombre"]').val().trim();
        $.get('TipoUsuarioControlador?accion=existeNombre&nombre=' + encodeURIComponent(nombre), function(data) {
            if (data.existe) {
                Swal.fire({icon: 'warning', title: 'Duplicado', text: 'Ya existe un rol con ese nombre.'});
            } else {
                $.post('TipoUsuarioControlador?accion=agregar', $(form).serialize(), function(resp) {
                    if (resp.success) {
                        $('#modalNuevoRol').modal('hide');
                        Swal.fire({icon:'success',title:'¡Éxito!',text:resp.message}).then(()=>location.reload());
                    } else {
                        Swal.fire({icon:'error',title:'Error',text:resp.message});
                    }
                },'json');
            }
        },'json');
    });

    // Abrir modal de edición
    $('.btnEditar').click(function() {
        const btn = $(this);
        $('#edit_idTipoUsuario').val(btn.data('id'));
        $('#edit_nombre').val(btn.data('nombre'));
        $('#edit_estadoTipo').val(btn.data('estado'));
        $('#editAdvertencia').hide();
        $('#modalEditarRol').modal('show');
    });

    // Mostrar advertencia si cambia a inactivo
    $('#edit_estadoTipo').change(function() {
        if ($(this).val() === 'inactivo') {
            $('#editAdvertencia').show();
        } else {
            $('#editAdvertencia').hide();
        }
    });

    // Validación AJAX antes de guardar edición
    $('#formEditarRol').submit(function(e) {
        e.preventDefault();
        const form = this;
        const id = $('#edit_idTipoUsuario').val();
        const nombre = $('#edit_nombre').val().trim();
        $.get('TipoUsuarioControlador?accion=existeNombre&nombre=' + encodeURIComponent(nombre) + '&idTipoUsuario=' + id, function(data) {
            if (data.existe) {
                Swal.fire({icon: 'warning', title: 'Duplicado', text: 'Ya existe un rol con ese nombre.'});
            } else {
                $.post('TipoUsuarioControlador?accion=actualizar', $(form).serialize(), function(resp) {
                    if (resp.success) {
                        $('#modalEditarRol').modal('hide');
                        Swal.fire({icon:'success',title:'¡Éxito!',text:resp.message}).then(()=>location.reload());
                    } else {
                        Swal.fire({icon:'error',title:'Error',text:resp.message});
                    }
                },'json');
            }
        },'json');
    });

    // Reset advertencia modal al cerrar
    $('#modalEditarRol').on('hidden.bs.modal', function() { $('#editAdvertencia').hide(); });
});

