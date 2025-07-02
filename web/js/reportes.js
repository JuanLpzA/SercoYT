$(document).ready(function() {
    // Botón para cambiar estado
    $(document).on('click', '.change-status', function() {
        const idVenta = $(this).data('id');
        const currentEstado = $(this).data('current');
        
        $('#idVenta').val(idVenta);
        
        // Configurar el select según el estado actual
        const $select = $('#nuevoEstado');
        $select.val(currentEstado + 1); // Siguiente estado por defecto
        
        // Si ya está en el último estado, mostrar el mismo
        if (currentEstado >= 3) {
            $select.val(currentEstado);
        }
        
        // Actualizar mensaje de advertencia
        updateWarningMessage($select.val());
        
        $('#cambiarEstadoModal').modal('show');
    });
    
    // Cambiar mensaje de advertencia cuando cambia el select
    $('#nuevoEstado').change(function() {
        updateWarningMessage($(this).val());
    });
    
    function updateWarningMessage(estado) {
        const $warning = $('#warningMessage');
        
        switch(estado) {
            case '3': // Entregado
                $warning.text('Cambiar el estado a "Entregado" es irreversible. ¿Está seguro?');
                break;
            case '4': // Cancelado
                $warning.text('Cambiar el estado a "Cancelado" es irreversible. ¿Está seguro?');
                break;
            default:
                $warning.text('Cambiar el estado es una acción importante. ¿Está seguro?');
        }
    }
    
    // Formulario para cambiar estado
    $('#cambiarEstadoForm').submit(function(e) {
        e.preventDefault();
        
        const idVenta = $('#idVenta').val();
        const nuevoEstado = $('#nuevoEstado').val();
        
        Swal.fire({
            title: 'Confirmar Cambio de Estado',
            text: '¿Está seguro que desea cambiar el estado de esta venta?',
            icon: 'warning',
            showCancelButton: true,
            confirmButtonColor: '#3085d6',
            cancelButtonColor: '#d33',
            confirmButtonText: 'Sí, cambiar',
            cancelButtonText: 'Cancelar'
        }).then((result) => {
            if (result.isConfirmed) {
                cambiarEstadoVenta(idVenta, nuevoEstado);
            }
        });
    });
    
    function cambiarEstadoVenta(idVenta, nuevoEstado) {
        $.ajax({
            url: AppContext.endpoints.reporte.cambiarEstado,
            type: 'POST',
            data: {
                idVenta: idVenta,
                nuevoEstado: nuevoEstado
            },
            dataType: 'json',
            beforeSend: function() {
                // Mostrar loading
                $('#cambiarEstadoModal').modal('hide');
                Swal.fire({
                    title: 'Procesando',
                    html: 'Actualizando estado de la venta...',
                    allowOutsideClick: false,
                    didOpen: () => {
                        Swal.showLoading();
                    }
                });
            },
            success: function(response) {
                if (response.success) {
                    Swal.fire({
                        icon: 'success',
                        title: '¡Éxito!',
                        text: response.message,
                        timer: 2000,
                        showConfirmButton: false
                    }).then(() => {
                        window.location.reload();
                    });
                } else {
                    Swal.fire({
                        icon: 'error',
                        title: 'Error',
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
            }
        });
    }
    
    // Tooltips
    $('[data-toggle="tooltip"], .btn-action').tooltip({
        placement: 'top',
        trigger: 'hover'
    });
    
    // Auto-dismiss alerts
    setTimeout(function() {
        $('.alert').fadeOut();
    }, 5000);
});