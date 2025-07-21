$(document).ready(function() {
    // Cargar usuarios para el resumen
    cargarUsuarios();
    
    // Manejar el botón de resetear filtros
    $('#btnResetFiltros').click(function() {
        $('#filtroForm')[0].reset();
        window.location.href = AppContext.endpoints.caja.list;
    });
    
    // Manejar el botón de resumen
    $('#btnResumen').click(function() {
        // Establecer fechas por defecto (últimos 30 días)
        const fechaFin = new Date();
        const fechaInicio = new Date();
        fechaInicio.setDate(fechaInicio.getDate() - 30);
        
        $('#resumenFechaInicio').val(formatDate(fechaInicio));
        $('#resumenFechaFin').val(formatDate(fechaFin));
        
        $('#resumenModal').modal('show');
    });
    
    // Generar resumen
    $('#btnGenerarResumen').click(function() {
        const fechaInicio = $('#resumenFechaInicio').val();
        const fechaFin = $('#resumenFechaFin').val();
        const idUsuario = $('#resumenUsuario').val();
        
        if (!fechaInicio || !fechaFin) {
            Swal.fire('Error', 'Debe seleccionar ambas fechas', 'error');
            return;
        }
        
        $.ajax({
            url: AppContext.endpoints.caja.resumen,
            type: 'GET',
            data: {
                fechaInicio: fechaInicio,
                fechaFin: fechaFin,
                idUsuario: idUsuario
            },
            success: function(resumen) {
                $('#resumenTotalCajas').text(resumen.totalCajas);
                $('#resumenTotalInicial').text('S/ ' + formatCurrency(resumen.totalInicial));
                $('#resumenTotalFinal').text('S/ ' + formatCurrency(resumen.totalFinal));
                $('#resumenTotalRecaudado').text('S/ ' + formatCurrency(resumen.totalRecaudado));
                
                const diferencia = resumen.diferenciaTotal;
                const $diferenciaElement = $('#resumenDiferencia');
                $diferenciaElement.text('S/ ' + formatCurrency(Math.abs(diferencia)));
                
                if (diferencia >= 0) {
                    $diferenciaElement.removeClass('text-danger').addClass('text-success');
                } else {
                    $diferenciaElement.removeClass('text-success').addClass('text-danger');
                }
                
                $('#resumenResultados').show();
            },
            error: function() {
                Swal.fire('Error', 'No se pudo generar el resumen', 'error');
            }
        });
    });
    
    // Manejar el botón de detalles
    $(document).on('click', '.btn-detalles', function() {
        const idCaja = $(this).data('id');
        
        $.ajax({
            url: AppContext.endpoints.caja.detalles + idCaja,
            type: 'GET',
            success: function(data) {
                $('#detallesCajaBody').html(data);
                $('#detallesModal').modal('show');
            },
            error: function() {
                Swal.fire('Error', 'No se pudieron cargar los detalles', 'error');
            }
        });
    });
    
    // Función para cargar usuarios en el select
    function cargarUsuarios() {
        $.ajax({
            url: AppContext.endpoints.usuario.list,
            type: 'GET',
            success: function(usuarios) {
                const $select = $('#resumenUsuario');
                $select.empty();
                $select.append('<option value="">Todos los usuarios</option>');
                
                usuarios.forEach(function(usuario) {
                    $select.append(`<option value="${usuario.idUsuario}">${usuario.nombre} ${usuario.apellido}</option>`);
                });
            }
        });
    }
    
    // Función para formatear fecha como YYYY-MM-DD
    function formatDate(date) {
        const d = new Date(date);
        let month = '' + (d.getMonth() + 1);
        let day = '' + d.getDate();
        const year = d.getFullYear();
        
        if (month.length < 2) 
            month = '0' + month;
        if (day.length < 2) 
            day = '0' + day;
        
        return [year, month, day].join('-');
    }
    
    // Función para formatear moneda
    function formatCurrency(amount) {
        return parseFloat(amount).toFixed(2).replace(/\d(?=(\d{3})+\.)/g, '$&,');
    }
});
