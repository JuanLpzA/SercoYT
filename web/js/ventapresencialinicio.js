$(document).ready(function() {
    // Verificar estado de caja al cargar la página
    verificarEstadoCaja();
    
    // Configurar botones
    $('#btnAbrirCaja').click(function() {
        $('#montoInicial').val('');
        $('#abrirCajaModal').modal('show');
    });
    
    $('#btnCerrarCaja').click(function() {
        cargarResumenCaja();
        $('#cerrarCajaModal').modal('show');
    });
    
    $('#btnConfirmarAbrirCaja').click(abrirCaja);
    $('#btnConfirmarCerrarCaja').click(cerrarCaja);
    $('#btnNuevaVenta').click(function() {
        verificarEstadoCaja(function(caja) {
            if (caja && caja.cajaAbierta) {
                window.location.href = AppContext.endpoints.ventaPresencial.ventaInicio + '&nuevaVenta=true&idCaja=' + caja.idCaja;
            } else {
                mostrarError('No hay una caja abierta para realizar ventas');
            }
        });
    });
    
    // Configurar botón de iniciar venta de la guía
    $('#btnIniciarVenta').click(function() {
        $('#btnNuevaVenta').click(); // Reutilizar la lógica del botón nueva venta
    });
    
    // Configurar validación de monto recaudado
    $('#montoRecaudado').on('input', calcularDiferencia);
    
    // Función para verificar estado de caja
    function verificarEstadoCaja(callback) {
        $.ajax({
            url: AppContext.endpoints.ventaPresencial.verificarEstadoCaja,
            type: 'GET',
            dataType: 'json',
            success: function(response) {
                if (response.cajaAbierta) {
                    // Caja abierta - Actualizar monto total de caja
                    $('#btnAbrirCaja').hide();
                    $('#btnCerrarCaja').prop('disabled', false);
                    $('#btnNuevaVenta').prop('disabled', false);
                    
                    // Obtener el total real de la caja (monto inicial + ventas)
                    obtenerMontoTotalCaja(response.idCaja, response.montoInicial);
                    
                    // Actualizar lista de ventas de esta caja
                    actualizarVentasCaja(response.idCaja);
                    
                    if (typeof callback === 'function') {
                        callback({
                            cajaAbierta: true,
                            idCaja: response.idCaja,
                            montoInicial: response.montoInicial
                        });
                    }
                } else {
                    // Caja cerrada
                    $('#btnAbrirCaja').show();
                    $('#btnCerrarCaja').prop('disabled', true);
                    $('#btnNuevaVenta').prop('disabled', true);
                    $('#montoCaja').text('S/. 0.00');
                    
                    if (typeof callback === 'function') {
                        callback({ cajaAbierta: false });
                    }
                }
            },
            error: function(xhr) {
                console.error('Error al verificar estado de caja:', xhr.responseText);
                mostrarError('Error al verificar estado de caja');
                
                if (typeof callback === 'function') {
                    callback({ cajaAbierta: false });
                }
            }
        });
    }
    
    // Nueva función para obtener el monto total de la caja
    function obtenerMontoTotalCaja(idCaja, montoInicial) {
        $.ajax({
            url: AppContext.endpoints.ventaPresencial.obtenerResumenCaja,
            type: 'GET',
            dataType: 'json',
            success: function(response) {
                const totalVentas = response.totalVentas || 0;
                const montoTotalCaja = montoInicial + totalVentas;
                $('#montoCaja').text('S/. ' + montoTotalCaja.toFixed(2));
            },
            error: function(xhr) {
                console.error('Error al obtener monto total de caja:', xhr.responseText);
                // Si hay error, mostrar al menos el monto inicial
                $('#montoCaja').text('S/. ' + montoInicial.toFixed(2));
            }
        });
    }
    
    // Función para abrir caja
    function abrirCaja() {
        const montoInicial = parseFloat($('#montoInicial').val());
        
        if (isNaN(montoInicial) || montoInicial <= 0) {
            mostrarError('Ingrese un monto inicial válido mayor a cero');
            return;
        }
        
        mostrarCargando('#btnConfirmarAbrirCaja');
        
        $.ajax({
            url: AppContext.endpoints.ventaPresencial.abrirCaja,
            type: 'POST',
            data: {
                montoInicial: montoInicial.toFixed(2)
            },
            dataType: 'json',
            success: function(response) {
                if (response.success) {
                    $('#abrirCajaModal').modal('hide');
                    mostrarExito('Caja aperturada correctamente con S/.' + montoInicial.toFixed(2));
                    $('#montoCaja').text('S/. ' + montoInicial.toFixed(2));
                    $('#btnAbrirCaja').hide();
                    $('#btnCerrarCaja').prop('disabled', false);
                    $('#btnNuevaVenta').prop('disabled', false);
                } else {
                    mostrarError(response.error || 'Error al aperturar caja');
                }
            },
            error: function(xhr) {
                mostrarError('Error al aperturar caja: ' + xhr.responseText);
            },
            complete: function() {
                ocultarCargando('#btnConfirmarAbrirCaja', '<i class="fas fa-check"></i> Aperturar Caja');
            }
        });
    }
    
    // Función para cargar resumen de caja
    function cargarResumenCaja() {
        mostrarCargando('#btnCerrarCaja');
        
        $.ajax({
            url: AppContext.endpoints.ventaPresencial.obtenerResumenCaja,
            type: 'GET',
            dataType: 'json',
            success: function(response) {
                const $resumenVentas = $('#resumenVentas');
                $resumenVentas.empty();
                
                // Mostrar ventas
                if (response.ventas && response.ventas.length > 0) {
                    response.ventas.forEach(function(venta) {
                        const fecha = new Date(venta.fecha);
                        const hora = fecha.getHours().toString().padStart(2, '0') + ':' + 
                                     fecha.getMinutes().toString().padStart(2, '0');
                        
                        $resumenVentas.append(`
                            <tr>
                                <td>#${venta.idVenta}</td>
                                <td>${hora}</td>
                                <td>S/. ${venta.total.toFixed(2)}</td>
                            </tr>
                        `);
                    });
                } else {
                    $resumenVentas.append(`
                        <tr>
                            <td colspan="3" class="text-center">No hay ventas registradas</td>
                        </tr>
                    `);
                }
                
                // Calcular totales
                const totalVentas = response.totalVentas || 0;
                const montoInicial = parseFloat($('#montoCaja').text().replace('S/. ', '')) - totalVentas; // Obtener solo el monto inicial
                const totalCaja = montoInicial + totalVentas;
                
                $('#totalVentas').text('S/. ' + totalVentas.toFixed(2));
                $('#montoInicialResumen').val('S/. ' + montoInicial.toFixed(2));
                $('#totalCaja').val('S/. ' + totalCaja.toFixed(2));
                
                // Configurar máximo para monto recaudado
                $('#montoRecaudado').attr('max', totalCaja).val(totalCaja.toFixed(2));
                calcularDiferencia();
            },
            error: function(xhr) {
                mostrarError('Error al cargar resumen de caja: ' + xhr.responseText);
            },
            complete: function() {
                ocultarCargando('#btnCerrarCaja', '<i class="fas fa-lock"></i> Finalizar Caja');
            }
        });
    }
    
    // Función para calcular diferencia al cerrar caja
    function calcularDiferencia() {
        const montoRecaudado = parseFloat($('#montoRecaudado').val()) || 0;
        const totalCaja = parseFloat($('#totalCaja').val().replace('S/. ', '')) || 0;
        
        const diferencia = montoRecaudado - totalCaja;
        const $diferenciaInput = $('#diferenciaCaja');
        
        $diferenciaInput.val('S/. ' + Math.abs(diferencia).toFixed(2));
        
        if (diferencia > 0) {
            $diferenciaInput.removeClass('negativo').addClass('positivo');
        } else if (diferencia < 0) {
            $diferenciaInput.removeClass('positivo').addClass('negativo');
        } else {
            $diferenciaInput.removeClass('positivo negativo');
        }
    }
    
    // Función para cerrar caja
    function cerrarCaja() {
        const montoRecaudado = parseFloat($('#montoRecaudado').val());
        const observaciones = $('#observacionesCaja').val();
        const totalCaja = parseFloat($('#totalCaja').val().replace('S/. ', ''));
        
        if (isNaN(montoRecaudado)) {
            mostrarError('Ingrese un monto recaudado válido');
            return;
        }
        
        if (montoRecaudado > totalCaja) {
            mostrarError('El monto recaudado no puede ser mayor al total de caja');
            return;
        }
        
        const diferencia = montoRecaudado - totalCaja;
        if (diferencia < 0) {
            Swal.fire({
                title: '¿Confirmar diferencia?',
                text: `Hay una diferencia de S/. ${Math.abs(diferencia).toFixed(2)}. ¿Está seguro de continuar?`,
                icon: 'warning',
                showCancelButton: true,
                confirmButtonText: 'Sí, continuar',
                cancelButtonText: 'Cancelar'
            }).then((result) => {
                if (result.isConfirmed) {
                    confirmarCierreCaja(montoRecaudado, observaciones, diferencia);
                }
            });
        } else {
            confirmarCierreCaja(montoRecaudado, observaciones, diferencia);
        }
    }
    
    function confirmarCierreCaja(montoRecaudado, observaciones, diferencia) {
        mostrarCargando('#btnConfirmarCerrarCaja');
        
        $.ajax({
            url: AppContext.endpoints.ventaPresencial.cerrarCaja,
            type: 'POST',
            data: {
                montoRecaudado: montoRecaudado,
                observaciones: observaciones
            },
            dataType: 'json',
            success: function(response) {
                if (response.success) {
                    $('#cerrarCajaModal').modal('hide');
                    
                    // Mostrar mensaje de éxito o advertencia
                    const mensaje = diferencia < 0 ? 
                        `Caja cerrada con una diferencia de S/. ${Math.abs(diferencia).toFixed(2)}` : 
                        'Caja cerrada correctamente';
                    
                    const tipoMensaje = diferencia < 0 ? 'warning' : 'success';
                    
                    Swal.fire({
                        icon: tipoMensaje,
                        title: diferencia < 0 ? 'Advertencia' : 'Éxito',
                        text: mensaje,
                        timer: 2000,
                        showConfirmButton: false
                    }).then(() => {
                        // Recargar la página después de mostrar el mensaje
                        window.location.reload();
                    });
                } else {
                    mostrarError(response.error || 'Error al cerrar caja');
                }
            },
            error: function(xhr) {
                mostrarError('Error al cerrar caja: ' + xhr.responseText);
            },
            complete: function() {
                ocultarCargando('#btnConfirmarCerrarCaja', '<i class="fas fa-check"></i> Finalizar Caja');
            }
        });
    }
    
    // Función para actualizar lista de ventas de la caja actual
    function actualizarVentasCaja(idCaja) {
        $.ajax({
            url: AppContext.endpoints.ventaPresencial.obtenerVentasCaja,
            type: 'GET',
            data: { idCaja: idCaja },
            dataType: 'json',
            success: function(response) {
                if (response && response.length > 0) {
                    const $ventasTable = $('.ventas-table tbody');
                    $ventasTable.empty();
                    
                    response.forEach(function(venta) {
                        const fecha = new Date(venta.fecha);
                        const fechaStr = fecha.getDate().toString().padStart(2, '0') + '/' + 
                                         (fecha.getMonth() + 1).toString().padStart(2, '0') + '/' + 
                                         fecha.getFullYear().toString().substr(-2) + ' ' + 
                                         fecha.getHours().toString().padStart(2, '0') + ':' + 
                                         fecha.getMinutes().toString().padStart(2, '0');
                        
                        $ventasTable.append(`
                            <tr>
                                <td><strong>#${venta.idVenta}</strong></td>
                                <td>${fechaStr}</td>
                                <td>${venta.clienteNombre || 'Sin cliente'}</td>
                                <td>${venta.clienteDni || '--'}</td>
                                <td>${venta.tipoVentaNombre}</td>
                                <td>
                                    <span class="status-badge status-${venta.estadoNombre.toLowerCase().replace(' ', '-')}">
                                        ${venta.estadoNombre}
                                    </span>
                                </td>
                                <td>${venta.metodoPagoNombre}</td>
                                <td class="text-success font-weight-bold">S/${venta.total.toFixed(2)}</td>
                            </tr>
                        `);
                    });
                    
                    // También mostrar el empty state si no hay ventas después de la actualización
                } else {
                    const $emptyStateContainer = $('.left-column .table-container');
                    if ($emptyStateContainer.find('.empty-state').length === 0) {
                        $emptyStateContainer.html(`
                            <div class="empty-state">
                                <i class="fas fa-receipt"></i>
                                <h6>No hay ventas registradas</h6>
                                <p>Comienza realizando tu primera venta presencial</p>
                            </div>
                        `);
                    }
                }
            },
            error: function(xhr) {
                console.error('Error al obtener ventas de caja:', xhr.responseText);
            }
        });
    }
    
    // Funciones auxiliares
    function mostrarCargando(selector) {
        const $btn = $(selector);
        $btn.data('original-text', $btn.html());
        $btn.prop('disabled', true).html('<i class="fas fa-spinner fa-spin"></i> Procesando...');
    }
    
    function ocultarCargando(selector, texto) {
        const $btn = $(selector);
        const originalText = $btn.data('original-text') || texto;
        $btn.prop('disabled', false).html(originalText);
    }
    
    function mostrarError(mensaje) {
        Swal.fire({
            icon: 'error',
            title: 'Error',
            text: mensaje,
            timer: 3000
        });
    }
    
    function mostrarExito(mensaje) {
        Swal.fire({
            icon: 'success',
            title: 'Éxito',
            text: mensaje,
            timer: 2000
        });
    }
    
    function mostrarAdvertencia(mensaje) {
        Swal.fire({
            icon: 'warning',
            title: 'Advertencia',
            text: mensaje,
            timer: 3000
        });
    }
});