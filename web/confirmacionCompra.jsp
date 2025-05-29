<!-- En el script JavaScript -->
<script>
    $(document).ready(function() {
        // ... (código existente)
        
        // Generar compra
        $('#btnGenerarCompra').click(function() {
            // Validar que se haya seleccionado método de pago
            if (!metodoPagoSeleccionado) {
                swal("Error", "Por favor seleccione un método de pago", "error");
                return;
            }
            
            // Determinar idPago (2 para tarjeta, 3 para yape)
            var idPago = metodoPagoSeleccionado === 'tarjeta' ? 2 : 3;
            
            // Enviar datos al servidor
            $.post('VentaControlador', {
                accion: 'generarCompra',
                metodoPago: idPago
            }, function(response) {
                // Mostrar formulario de dirección
                $('#addressModal').css('display', 'flex');
            }).fail(function() {
                swal("Error", "Ocurrió un error al procesar la compra", "error");
            });
        });
        
        // Enviar dirección
        $('#addressForm').submit(function(e) {
            e.preventDefault();
            
            // Validar campos requeridos
            if ($('#direccion').val().trim() === '' || 
                $('#distrito').val().trim() === '' || 
                $('#ciudad').val().trim() === '' || 
                $('#referencia').val().trim() === '') {
                swal("Error", "Por favor complete todos los campos requeridos", "error");
                return;
            }
            
            // Enviar formulario
            $.post('VentaControlador', $(this).serialize(), function(response) {
                window.location.href = 'confirmacionCompra.jsp';
            }).fail(function() {
                swal("Error", "Ocurrió un error al guardar la dirección", "error");
            });
        });
    });
</script>