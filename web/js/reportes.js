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
    
    // Mostrar detalles de venta en modal
$(document).on('click', '.btn-action.view', function(e) {
    e.preventDefault();
    const idVenta = $(this).data('id');
    
    if (!idVenta || isNaN(idVenta)) {
        Swal.fire({
            icon: 'error',
            title: 'Error',
            text: 'ID de venta inválido',
            confirmButtonText: 'Entendido'
        });
        return;
    }
    
    $.ajax({
        url: AppContext.endpoints.reporte.obtenerDetalles + idVenta,
        type: 'GET',
        data: { idVenta: idVenta }, // Enviar como parámetro GET
        dataType: 'json',
        beforeSend: function() {
            $('#detallesVentaModal').modal('show');
            $('#detalleIdVenta').text(idVenta);
            $('#infoVenta').html('<p class="text-center"><i class="fas fa-spinner fa-spin"></i> Cargando...</p>');
            $('#infoDireccion').html('<p class="text-center"><i class="fas fa-spinner fa-spin"></i> Cargando...</p>');
            $('#tablaProductos').html('<tr><td colspan="4" class="text-center"><i class="fas fa-spinner fa-spin"></i> Cargando...</td></tr>');
        },
        success: function(data) {
            // Verificar si hay error en la respuesta
            if (data.error) {
                $('#infoVenta').html('<p class="text-danger">' + data.message + '</p>');
                $('#infoDireccion').html('');
                $('#tablaProductos').html('<tr><td colspan="4" class="text-center text-danger">Error al cargar datos</td></tr>');
                return;
            }

            // Llenar información de la venta
            const venta = data.venta || {};
            let estadoBadge = '';
            
            if (venta.estadoNombre) {
                const estadoClass = venta.estadoNombre.toLowerCase().replace(/\s+/g, '-');
                estadoBadge = `<span class="status-badge status-${estadoClass}">${venta.estadoNombre}</span>`;
            } else {
                estadoBadge = `<span class="status-badge status-sd">S/D</span>`;
            }
            
            let htmlVenta = `
                <p><strong>Fecha:</strong> ${venta.fecha ? formatDate(venta.fecha) : 'S/D'}</p>
                <p><strong>Cliente:</strong> ${venta.clienteNombre || 'S/D'}</p>
                <p><strong>DNI:</strong> ${venta.documento || 'S/D'}</p>
                <p><strong>Tipo:</strong> ${venta.nombre || 'S/D'}</p>
                <p><strong>Estado:</strong> ${venta.descripcion}</p>
                <p><strong>Método Pago:</strong> ${venta.metodo || 'S/D'}</p>
            `;
            $('#infoVenta').html(htmlVenta);

            // Llenar información de dirección
            const direccion = data.direccion || {};
            let htmlDireccion = '';
            
            if (Object.keys(direccion).length > 0) {
                htmlDireccion = `
                    <p><strong>Receptor:</strong> ${direccion.nombreReceptor || 'S/D'}</p>
                    <p><strong>Teléfono:</strong> ${direccion.telefono || 'S/D'}</p>
                    <p><strong>Provincia:</strong> ${direccion.provincia || 'S/D'}</p>
                    <p><strong>Dirección:</strong> ${direccion.direccion || 'S/D'}</p>
                    <p><strong>Referencia:</strong> ${direccion.referencia || 'S/D'}</p>
                    <p><strong>Código Postal:</strong> ${direccion.codigoPostal || 'S/D'}</p>
                `;
            } else {
                htmlDireccion = '<p class="text-muted">No disponible (Venta presencial)</p>';
            }
            $('#infoDireccion').html(htmlDireccion);

            // Llenar tabla de productos
            let htmlProductos = '';
            const productos = data.productos || [];
            
            if (productos.length > 0) {
                productos.forEach(producto => {
                    const precioUnitario = parseFloat(producto.precioUnitario || 0).toFixed(2);
                    const cantidad = producto.cantidad || 0;
                    const subtotal = parseFloat(producto.subtotal || 0).toFixed(2);
                    
                    htmlProductos += `
                        <tr>
                            <td>${producto.nombre || 'Producto sin nombre'}</td>
                            <td>S/${precioUnitario}</td>
                            <td>${cantidad}</td>
                            <td>S/${subtotal}</td>
                        </tr>
                    `;
                });
            } else {
                htmlProductos = '<tr><td colspan="4" class="text-center text-muted">No hay productos registrados</td></tr>';
            }
            $('#tablaProductos').html(htmlProductos);

            // Llenar totales
            const subtotal = parseFloat(venta.subtotal || 0).toFixed(2);
            const igv = parseFloat(venta.igv || 0).toFixed(2);
            const total = parseFloat(venta.total || 0).toFixed(2);
            
            $('#subtotalDetalle').text('S/' + subtotal);
            $('#igvDetalle').text('S/' + igv);
            $('#totalDetalle').text('S/' + total);
        },
        error: function(xhr, status, error) {
            console.error('Error AJAX:', status, error);
            console.error('Response:', xhr.responseText);
            
            let errorMessage = 'Error al cargar los detalles de la venta';
            
            if (xhr.responseText) {
                try {
                    const response = JSON.parse(xhr.responseText);
                    errorMessage = response.message || errorMessage;
                } catch (e) {
                    errorMessage = xhr.responseText.length > 100 ? 
                                  'Error de servidor' : 
                                  xhr.responseText;
                }
            }
            
            $('#infoVenta').html('<p class="text-danger">' + errorMessage + '</p>');
            $('#infoDireccion').html('');
            $('#tablaProductos').html('<tr><td colspan="4" class="text-center text-danger">Error al cargar productos</td></tr>');
        }
    });
});

function formatDate(dateString) {
    if (!dateString) return 'S/D';
    
    try {
        const date = new Date(dateString);
        return date.toLocaleDateString('es-PE', {
            day: '2-digit',
            month: '2-digit',
            year: 'numeric',
            hour: '2-digit',
            minute: '2-digit'
        });
    } catch (e) {
        console.error('Error formateando fecha:', e);
        return dateString; // Retornar el string original si falla el formateo
    }
}

// Filtros
$('#filtroForm').submit(function(e) {
    e.preventDefault();
    const params = $(this).serialize();
    const currentUrl = window.location.href.split('?')[0];
    const urlParams = new URLSearchParams(window.location.search);
    const accion = urlParams.get('accion') || '';

    let newUrl = currentUrl + '?';
    if (accion) {
        newUrl += 'accion=' + accion;
        if (params) {
            newUrl += '&' + params;
        }
    } else {
        newUrl += params;
    }
    window.location.href = newUrl;
});

$('#btnResetFiltros').click(function() {
    $('#filtroForm')[0].reset();
    const currentUrl = window.location.href.split('?')[0];
    const currentAction = currentUrl.includes('listarOnline') ? 'listarOnline' : 
                         currentUrl.includes('listarPresencial') ? 'listarPresencial' : '';
    
    let newUrl = currentUrl;
    if (currentAction) {
        newUrl += '?accion=' + currentAction;
    }
    
    window.location.href = newUrl;
});
    
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