$(document).ready(function() {
    // Toggle sidebar
    $('.sidebar-toggle').click(function() {
        $('.dashboard-container').toggleClass('sidebar-collapsed');
    });

    // Mostrar/ocultar submenús
    $('.has-submenu').click(function(e) {
        e.preventDefault();
        $(this).parent().toggleClass('open');
        $(this).next('.submenu').slideToggle();
    });

    // Inicializar tooltips
    $('[data-toggle="tooltip"]').tooltip();

    // Verificar stock bajo
    verificarStockBajo();

    // Cerrar alertas después de 5 segundos
    setTimeout(() => {
        $('.alert').alert('close');
    }, 5000);
});

function verificarStockBajo() {
    $.get('${pageContext.request.contextPath}/ProductoControlador?accion=stockBajo', function(data) {
        if (data.length > 0) {
            const mensaje = `Tienes ${data.length} producto(s) con stock bajo. <a href="${pageContext.request.contextPath}/ProductoControlador?accion=filtrar&stockMin=0&stockMax=5">Ver productos</a>`;
            const alerta = $(`
                <div class="alert alert-warning alert-dismissible fade show" role="alert">
                    <strong>¡Atención!</strong> ${mensaje}
                    <button type="button" class="close" data-dismiss="alert" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>
                </div>
            `);
            
            $('.dashboard-main').prepend(alerta);
        }
    }).fail(function() {
        console.error('Error al verificar stock bajo');
    });
}

function showAlert(type, message) {
    const alert = $(`
        <div class="alert alert-${type} alert-dismissible fade show" role="alert">
            ${message}
            <button type="button" class="close" data-dismiss="alert" aria-label="Close">
                <span aria-hidden="true">&times;</span>
            </button>
        </div>
    `);
    
    $('.dashboard-main').prepend(alert);
    
    setTimeout(() => {
        alert.alert('close');
    }, 5000);
}