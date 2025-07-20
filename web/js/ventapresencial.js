$(document).ready(function () {
    
    verificarEstadoCaja();
    // Variables globales
    let carrito = [];
    let clienteSeleccionado = null;
    
    $('#tipoDocumento').change(function () {
        const tipo = $(this).val();
        const $documento = $('#documento');

        if (tipo === '1') { // DNI
            $documento.attr('maxlength', '8').attr('placeholder', 'Ingrese DNI (8 dígitos)');
        } else if (tipo === '2') { // RUC
            $documento.attr('maxlength', '11').attr('placeholder', 'Ingrese RUC (11 dígitos)');
        } else { // Carnet extranjería
            $documento.attr('maxlength', '10').attr('placeholder', 'Ingrese Carnet (10 dígitos)');
        }

        $documento.val('');
        $('#clienteInfo').hide();
        $('#nuevoClienteForm').hide();
    });

    // Configurar límites de documento según tipo
    $('input[name="tipoDocumentoModal"]').change(function() {
    const tipo = $(this).val();
    const $documento = $('#documentoModal');
    
    
    if (tipo === '1') { // DNI
        $documento.attr('maxlength', '8').attr('pattern', '[0-9]{8}').attr('title', 'Ingrese 8 dígitos numéricos');
        $('#labelDocumentoModal').text('DNI');
        $('#labelNombreModal').text('Nombre');
        $('#labelApellidoModal').text('Apellido').parent().show();
    } else if (tipo === '2') { // RUC
        $documento.attr('maxlength', '11').attr('pattern', '[0-9]{11}').attr('title', 'Ingrese 11 dígitos numéricos');
        $('#labelDocumentoModal').text('RUC');
        $('#labelNombreModal').text('Razón Social');
        $('#labelApellidoModal').parent().hide();
    } else { // Carnet extranjería
        $documento.attr('maxlength', '10').attr('pattern', '[0-9]{10}').attr('title', 'Ingrese 10 dígitos numéricos');
        $('#labelDocumentoModal').text('Carnet Extranjería');
        $('#labelNombreModal').text('Nombre');
        $('#labelApellidoModal').text('Apellido').parent().show();
    }
});

    // Buscar cliente
    $('#btnBuscarCliente').click(buscarCliente);
    $('#documento').keypress(function (e) {
        if (e.which === 13) {
            buscarCliente();
        }
    });

    // Buscar producto
    $('#btnBuscarProducto').click(buscarProductos);
    $('#filtroProducto').keypress(function (e) {
        if (e.which === 13) {
            buscarProductos();
        }
    });

    // Registrar nuevo cliente
    $('#btnRegistrarCliente').click(registrarCliente);

    // Finalizar venta
    $('#btnFinalizarVenta').click(finalizarVenta);

    // Imprimir boleta
    $('#btnImprimirBoleta').click(function () {
        document.getElementById('boletaIframe').contentWindow.print();
    });
    $('#boletaModal .btn-secondary[data-dismiss="modal"]').click(function () {
        $('#boletaModal').modal('hide');
    });

    // Funciones
    function buscarCliente() {
    const tipoDocumento = $('#tipoDocumento').val();
    const documento = $('#documento').val().trim();

    if (!documento) {
        mostrarError('Ingrese un número de documento');
        return;
    }

    // Validar longitud según tipo de documento
    if ((tipoDocumento === '1' && documento.length !== 8) ||
            (tipoDocumento === '2' && documento.length !== 11) ||
            (tipoDocumento === '3' && documento.length !== 10)) {
        mostrarError('El documento no tiene la longitud correcta');
        return;
    }

    mostrarCargando('#btnBuscarCliente');

    $.ajax({
        url: AppContext.endpoints.ventaPresencial.buscarCliente,
        type: 'GET',
        data: {
            tipoDocumento: tipoDocumento,
            documento: documento
        },
        dataType: 'json',
        success: function (response) {
            if (response.error) {
                mostrarError(response.error);
                return;
            }

            if (response.existe) {
                // Cliente existe - CAMBIAR ESTA PARTE
                clienteSeleccionado = response.cliente;
                $('#nombreCompleto').val(response.cliente.nombre + ' ' + response.cliente.apellido);
                $('#idCliente').val(response.cliente.idCliente);

                // Habilitar botón de finalizar si hay productos
                if (carrito.length > 0) {
                    $('#btnFinalizarVenta').prop('disabled', false);
                }
            } else {
                // Cliente no existe, mostrar modal
                mostrarModalNuevoCliente(tipoDocumento, documento);
            }
        },
        error: function (xhr) {
            mostrarError('Error al buscar cliente: ' + xhr.responseText);
        },
        complete: function () {
            ocultarCargando('#btnBuscarCliente', '<i class="fas fa-search"></i> Buscar');
        }
    });
}

function mostrarModalNuevoCliente(tipoDocumento, documento) {
    // Configurar modal según tipo de documento
    $('#tipoDniModal').prop('checked', tipoDocumento === '1');
    $('#tipoRucModal').prop('checked', tipoDocumento === '2');
    $('#tipoCarnetModal').prop('checked', tipoDocumento === '3');
    
    // Disable tipo documento selection in modal
    $('input[name="tipoDocumentoModal"]').prop('disabled', true);
    
    // Trigger change event to update fields
    $('input[name="tipoDocumentoModal"]:checked').trigger('change');
    
    // Set documento value
    $('#documentoModal').val(documento).prop('readonly', true);
    
    // Clear other fields
    $('#nombreModal').val('');
    $('#apellidoModal').val('');
    $('#telefonoModal').val('');
    
    // Consultar API si es DNI o RUC
    if (tipoDocumento === '1') {
        consultarDni(documento);
    } else if (tipoDocumento === '2') {
        consultarRuc(documento);
    }
    
    // Mostrar modal
    $('#nuevoClienteModal').modal('show');
}

function consultarDni(dni) {
    $.ajax({
        url: AppContext.endpoints.cliente.consultarDni + dni,
        type: 'GET',
        dataType: 'json',
        beforeSend: function() {
            $('#nombreModal').prop('disabled', true);
            $('#apellidoModal').prop('disabled', true);
        },
        success: function (data) {
            if (data.nombres && data.apellidoPaterno && data.apellidoMaterno) {
                $('#nombreModal').val(data.nombres);
                $('#apellidoModal').val(data.apellidoPaterno + ' ' + data.apellidoMaterno);
                $('#telefonoModal').focus();
                mostrarExito('Datos del DNI cargados automáticamente');
            } else {
                mostrarInfo('No se encontraron datos para este DNI. Ingrese los datos manualmente.');
            }
        },
        error: function (xhr) {
            mostrarError('Error al consultar el DNI: ' + (xhr.responseJSON?.error || xhr.statusText));
        },
        complete: function () {
            $('#nombreModal').prop('disabled', false);
            $('#apellidoModal').prop('disabled', false);
        }
    });
}

function consultarRuc(ruc) {
    $.ajax({
        url: AppContext.endpoints.cliente.consultarRuc + ruc,
        type: 'GET',
        dataType: 'json',
        beforeSend: function() {
            $('#nombreModal').prop('disabled', true);
        },
        success: function (data) {
            if (data.nombre || data.razonSocial) {
                const razonSocial = data.nombre || data.razonSocial;
                $('#nombreModal').val(razonSocial);
                $('#telefonoModal').focus();
                mostrarExito('Datos del RUC cargados automáticamente');
            } else {
                mostrarInfo('No se encontraron datos para este RUC. Ingrese los datos manualmente.');
            }
        },
        error: function (xhr) {
            mostrarError('Error al consultar el RUC: ' + (xhr.responseJSON?.error || xhr.statusText));
        },
        complete: function () {
            $('#nombreModal').prop('disabled', false);
        }
    });
}

$('#btnGuardarClienteModal').click(function() {
    const tipoDocumento = $('input[name="tipoDocumentoModal"]:checked').val();
    const documento = $('#documentoModal').val().trim();
    const nombre = $('#nombreModal').val().trim();
    const apellido = tipoDocumento === '2' ? '' : $('#apellidoModal').val().trim();
    const telefono = $('#telefonoModal').val().trim();

    if (!nombre || (tipoDocumento !== '2' && !apellido)) {
        mostrarError('Complete todos los campos obligatorios');
        return;
    }

    mostrarCargando('#btnGuardarClienteModal');

    $.ajax({
        url: AppContext.endpoints.ventaPresencial.registrarCliente,
        type: 'POST',
        data: {
            tipoDocumento: tipoDocumento,
            documento: documento,
            nombre: nombre,
            apellido: apellido,
            telefono: telefono
        },
        dataType: 'json',
        success: function (response) {
            if (response.error) {
                mostrarError(response.error);
                return;
            }

            if (response.success) {
                // Cliente registrado correctamente
                clienteSeleccionado = {
                    idCliente: response.idCliente,
                    nombre: nombre,
                    apellido: apellido,
                    documento: documento
                };

                $('#clienteNombre').text(nombre + (apellido ? ' ' + apellido : ''));
                $('#idCliente').val(response.idCliente);
                $('#clienteInfo').show();
                $('#nuevoClienteModal').modal('hide');

                // Habilitar botón de finalizar si hay productos
                if (carrito.length > 0) {
                    $('#btnFinalizarVenta').prop('disabled', false);
                }

                mostrarExito('Cliente registrado correctamente');
            }
        },
        error: function (xhr) {
            mostrarError('Error al registrar cliente: ' + xhr.responseText);
        },
        complete: function () {
            ocultarCargando('#btnGuardarClienteModal', '<i class="fas fa-save"></i> Guardar Cliente');
        }
    });
});


    function registrarCliente() {
        const tipoDocumento = $('#tipoDocumento').val();
        const documento = $('#documento').val().trim();
        const nombre = $('#nombreCliente').val().trim();
        const apellido = $('#apellidoCliente').val().trim();
        const telefono = $('#telefonoCliente').val().trim();

        if (!nombre || !apellido) {
            mostrarError('Nombre y apellido son obligatorios');
            return;
        }

        mostrarCargando('#btnRegistrarCliente');

        $.ajax({
            url: AppContext.endpoints.ventaPresencial.registrarCliente,
            type: 'POST',
            data: {
                tipoDocumento: tipoDocumento,
                documento: documento,
                nombre: nombre,
                apellido: apellido,
                telefono: telefono
            },
            dataType: 'json',
            success: function (response) {
                if (response.error) {
                    mostrarError(response.error);
                    return;
                }

                if (response.success) {
                    // Cliente registrado correctamente
                    clienteSeleccionado = {
                        idCliente: response.idCliente,
                        nombre: nombre,
                        apellido: apellido,
                        documento: documento
                    };

                    $('#clienteNombre').text(nombre + ' ' + apellido);
                    $('#idCliente').val(response.idCliente);
                    $('#clienteInfo').show();
                    $('#nuevoClienteForm').hide();

                    // Habilitar botón de finalizar si hay productos
                    if (carrito.length > 0) {
                        $('#btnFinalizarVenta').prop('disabled', false);
                    }

                    mostrarExito('Cliente registrado correctamente');
                }
            },
            error: function (xhr) {
                mostrarError('Error al registrar cliente: ' + xhr.responseText);
            },
            complete: function () {
                ocultarCargando('#btnRegistrarCliente', '<i class="fas fa-save"></i> Registrar Cliente');
            }
        });
    }

    function buscarProductos() {
        const filtro = $('#filtroProducto').val().trim();

        mostrarCargando('#btnBuscarProducto');

        $.ajax({
            url: AppContext.endpoints.ventaPresencial.buscarProducto,
            type: 'GET',
            data: {
                filtro: filtro
            },
            dataType: 'json',
            success: function (response) {
                const $productosList = $('#productosList');
                $productosList.empty();

                if (response.productos && response.productos.length > 0) {
                    response.productos.forEach(function (producto) {
                        const productoHtml = `
                            <div class="producto-item" data-id="${producto.id}">
                                <div class="producto-imagen">
                                    <img src="ControladorIMG?id=${producto.id}" 
                                         alt="${producto.nombre}">
                                </div>
                                <div class="producto-info">
                                    <h6>${producto.nombres}</h6>
                                    <div class="producto-marca">${producto.nombreMarca}</div>
                                    <div class="producto-precio">S/. ${producto.precio.toFixed(2)}</div>
                                    <div class="producto-stock">Stock: ${producto.stock}</div>
                                </div>
                                <div class="producto-acciones">
                                    <div class="input-group cantidad-group">
                                        <div class="input-group-prepend">
                                            <button class="btn btn-outline-secondary btn-restar" type="button">-</button>
                                        </div>
                                        <input type="number" class="form-control cantidad-input" value="1" min="1" max="${producto.stock}">
                                        <div class="input-group-append">
                                            <button class="btn btn-outline-secondary btn-sumar" type="button">+</button>
                                        </div>
                                    </div>
                                    <button class="btn btn-primary btn-agregar">
                                        <i class="fas fa-cart-plus"></i> Agregar
                                    </button>
                                </div>
                            </div>
                        `;
                        $productosList.append(productoHtml);
                    });

                    // Configurar eventos para los botones recién creados
                    $('.btn-agregar').click(agregarAlCarrito);
                    $('.btn-sumar').click(function () {
                        const input = $(this).closest('.cantidad-group').find('.cantidad-input');
                        const max = parseInt(input.attr('max'));
                        let value = parseInt(input.val()) || 0;
                        if (value < max) {
                            input.val(value + 1);
                        }
                    });
                    $('.btn-restar').click(function () {
                        const input = $(this).closest('.cantidad-group').find('.cantidad-input');
                        let value = parseInt(input.val()) || 0;
                        if (value > 1) {
                            input.val(value - 1);
                        }
                    });
                } else {
                    $productosList.html('<div class="no-products">No se encontraron productos</div>');
                }
            },
            error: function (xhr) {
                mostrarError('Error al buscar productos: ' + xhr.responseText);
            },
            complete: function () {
                ocultarCargando('#btnBuscarProducto', '<i class="fas fa-search"></i> Buscar');
            }
        });
    }

    function agregarAlCarrito() {
        const $productoItem = $(this).closest('.producto-item');
        const idProducto = $productoItem.data('id');
        const nombre = $productoItem.find('h6').text();
        const precioConIgv = parseFloat($productoItem.find('.producto-precio').text().replace('S/. ', ''));
        const cantidad = parseInt($productoItem.find('.cantidad-input').val()) || 1;
        const stock = parseInt($productoItem.find('.producto-stock').text().replace('Stock: ', ''));

        // Verificar si el producto ya está en el carrito
        const itemExistente = carrito.find(item => item.idProducto === idProducto);
        if (itemExistente) {
            // Verificar que no exceda el stock
            if (itemExistente.cantidad + cantidad > stock) {
                mostrarError('No hay suficiente stock para este producto');
                return;
            }
            // Actualizar cantidad
            itemExistente.cantidad += cantidad;
            itemExistente.subtotal = itemExistente.cantidad * itemExistente.precioConIgv;
        } else {
            // Verificar que no exceda el stock
            if (cantidad > stock) {
                mostrarError('No hay suficiente stock para este producto');
                return;
            }
            // Agregar nuevo item al carrito
            carrito.push({
                idProducto: idProducto,
                nombre: nombre,
                precioConIgv: precioConIgv, // Precio con IGV incluido
                cantidad: cantidad,
                subtotal: precioConIgv * cantidad
            });
        }
        actualizarCarrito();
        mostrarExito('Producto agregado al carrito');
        // Habilitar botón de finalizar si hay cliente seleccionado
        if (clienteSeleccionado) {
            $('#btnFinalizarVenta').prop('disabled', false);
        }
    }

    function actualizarCarrito() {
        const $carritoItems = $('#carritoItems');
        $carritoItems.empty();

        if (carrito.length === 0) {
            $carritoItems.html('<div class="empty-cart">No hay productos en el carrito</div>');
            $('#btnFinalizarVenta').prop('disabled', true);
        } else {
            carrito.forEach(function (item, index) {
                const itemHtml = `
                <div class="carrito-item">
                    <div class="item-info">
                        <div class="item-nombre">${item.nombre}</div>
                        <div class="item-precio">S/. ${item.precioConIgv.toFixed(2)}</div>
                    </div>
                    <div class="item-cantidad">
                        <button class="btn btn-sm btn-outline-secondary btn-restar-item" data-index="${index}">-</button>
                        <span class="cantidad">${item.cantidad}</span>
                        <button class="btn btn-sm btn-outline-secondary btn-sumar-item" data-index="${index}">+</button>
                    </div>
                    <div class="item-subtotal">S/. ${item.subtotal.toFixed(2)}</div>
                    <button class="btn btn-sm btn-danger btn-eliminar-item" data-index="${index}">
                        <i class="fas fa-trash"></i>
                    </button>
                </div>
            `;
                $carritoItems.append(itemHtml);
            });

            // Configurar eventos para los botones del carrito
            $('.btn-restar-item').click(function () {
                const index = $(this).data('index');
                if (carrito[index].cantidad > 1) {
                    carrito[index].cantidad--;
                    carrito[index].subtotal = carrito[index].cantidad * carrito[index].precioConIgv;
                    actualizarCarrito();
                }
            });

            $('.btn-sumar-item').click(function () {
                const index = $(this).data('index');
                // Aquí deberíamos verificar el stock disponible
                carrito[index].cantidad++;
                carrito[index].subtotal = carrito[index].cantidad * carrito[index].precioConIgv;
                actualizarCarrito();
            });

            $('.btn-eliminar-item').click(function () {
                const index = $(this).data('index');
                carrito.splice(index, 1);
                actualizarCarrito();
            });
        }

        // Calcular totales correctamente
        const totalConIgv = carrito.reduce((sum, item) => sum + item.subtotal, 0);
        const subtotalSinIgv = totalConIgv / 1.18; // Calcular subtotal sin IGV
        const igv = totalConIgv - subtotalSinIgv; // El IGV es la diferencia

        $('#subtotal').text('S/. ' + subtotalSinIgv.toFixed(2));
        $('#igv').text('S/. ' + igv.toFixed(2));
        $('#total').text('S/. ' + totalConIgv.toFixed(2));
    }

    function verificarEstadoCaja() {
        // Solo si estamos en la página de venta presencial (no en el inicio)
        if (window.location.pathname.includes('ventapresencial.jsp')) {
            $.ajax({
                url: AppContext.endpoints.ventaPresencial.verificarEstadoCaja,
                type: 'GET',
                dataType: 'json',
                success: function(response) {
                    if (!response.cajaAbierta) {
                        mostrarError('No hay una caja abierta. Debe aperturar caja primero.');
                        setTimeout(function() {
                            window.location.href = AppContext.endpoints.ventaPresencial.ventaInicio;
                        }, 2000);
                    }
                },
                error: function(xhr) {
                    console.error('Error al verificar estado de caja:', xhr.responseText);
                }
            });
        }
    }
    
    // Modificar la función finalizarVenta para verificar caja abierta
    function finalizarVenta() {
        if (!clienteSeleccionado) {
            mostrarError('Seleccione un cliente antes de finalizar la venta');
            return;
        }
        if (carrito.length === 0) {
            mostrarError('Agregue productos al carrito antes de finalizar la venta');
            return;
        }

        // Verificar estado de caja antes de continuar
        $.ajax({
            url: AppContext.endpoints.ventaPresencial.verificarEstadoCaja,
            type: 'GET',
            dataType: 'json',
            success: function(response) {
                if (!response.cajaAbierta) {
                    mostrarError('No hay una caja abierta. No se puede registrar la venta.');
                    return;
                }
                
                // Resto del código de finalizarVenta...
                procesarVenta();
            },
            error: function(xhr) {
                mostrarError('Error al verificar estado de caja: ' + xhr.responseText);
            }
        });
    }
    
    function procesarVenta() {
        const metodoPago = $('#metodoPago').val();
        mostrarCargando('#btnFinalizarVenta');

        $.ajax({
            url: AppContext.endpoints.ventaPresencial.finalizarVenta,
            type: 'POST',
            data: {
                accion: 'finalizarVenta',
                datos: JSON.stringify({
                    idCliente: clienteSeleccionado.idCliente,
                    metodoPago: metodoPago,
                    carrito: carrito
                })
            },
            dataType: 'json',
            success: function (response) {
                if (response.error) {
                    mostrarError(response.error);
                    return;
                }
                if (response.success) {
                    mostrarExito('Venta registrada correctamente');
                    // Verificar primero si el PDF se puede generar
                    const boletaUrl = AppContext.endpoints.ventaPresencial.generarBoleta + '&id=' + response.idVenta;
                    // Hacer una prueba AJAX para verificar que el PDF se genere correctamente
                    $.ajax({
                        url: boletaUrl,
                        type: 'HEAD', // Solo verificar headers
                        success: function (data, status, xhr) {
                            const contentType = xhr.getResponseHeader('Content-Type');
                            if (contentType && contentType.includes('application/pdf')) {
                                // Si es PDF, mostrar en iframe
                                $('#boletaIframe').attr('src', boletaUrl);
                                // Remover event listeners previos para evitar duplicados
                                $('#boletaModal').off('hidden.bs.modal.ventaPresencial');
                                // Agregar event listener para detectar cierre del modal
                                $('#boletaModal').on('hidden.bs.modal.ventaPresencial', function () {
                                    // Redirigir a VentaInicioControlador cuando se cierre el modal
                                    window.location.href = AppContext.endpoints.ventaPresencial.ventaInicio;
                                });
                                $('#boletaModal').modal('show');
                            } else {
                                // Si no es PDF, abrir en nueva pestaña
                                window.open(boletaUrl, '_blank');
                                mostrarError('El PDF se abrió en una nueva pestaña. Si no se abrió, verifique el bloqueador de ventanas emergentes.');
                                // También redirigir en este caso después de un breve delay
                                setTimeout(function () {
                                    window.location.href = AppContext.endpoints.ventaPresencial.ventaInicio;
                                }, 2000);
                            }
                        },
                        error: function (xhr) {
                            mostrarError('Error al generar el PDF: ' + xhr.status + ' - ' + xhr.statusText);
                            console.log('Error details:', xhr.responseText);
                            // Redirigir también en caso de error después de un delay
                            setTimeout(function () {
                                window.location.href = AppContext.endpoints.ventaPresencial.ventaInicio;
                            }, 3000);
                        }
                    });
                    // Limpiar carrito y cliente
                    carrito = [];
                    clienteSeleccionado = null;
                    $('#documento').val('');
                    $('#nombreCompleto').val('');
                    $('#idCliente').val('');
                    $('#btnFinalizarVenta').prop('disabled', true);
                    actualizarCarrito();
                }
            },
            error: function (xhr) {
                mostrarError('Error al finalizar venta: ' + xhr.responseText);
            },
            complete: function () {
                ocultarCargando('#btnFinalizarVenta', '<i class="fas fa-check-circle"></i> Finalizar Venta');
            }
        });
    }

    $('#btnDescargarBoleta').on('click', function () {
        const iframe = document.getElementById('boletaIframe');
        const url = iframe.src;
        // Crear un enlace temporal para descargar
        const a = document.createElement('a');
        a.href = url;
        a.download = 'boleta_' + response.idVenta + '.pdf';
        document.body.appendChild(a);
        a.click();
        document.body.removeChild(a);
    });

    // Funciones auxiliares
    function mostrarCargando(selector) {
        $(selector).prop('disabled', true).html('<i class="fas fa-spinner fa-spin"></i> Procesando...');
    }

    function ocultarCargando(selector, texto) {
        $(selector).prop('disabled', false).html(texto);
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

    // Cargar productos al inicio
    buscarProductos();
});