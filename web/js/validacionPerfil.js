
$(document).ready(function() {
    $('#formPerfil').submit(function(e) {
        let isValid = true;
        const nuevaContrasena = $('#nuevaContrasena').val();
        const confirmarContrasena = $('#confirmarContrasena').val();
        
        // Validar que si se ingresa nueva contraseña, también esté la actual
        if (nuevaContrasena || confirmarContrasena) {
            const contrasenaActual = $('#contrasenaActual').val();
            if (!contrasenaActual) {
                swal("Error", "Debes ingresar tu contraseña actual para cambiarla", "error");
                isValid = false;
            }
            
            // Validar que las contraseñas coincidan
            if (nuevaContrasena !== confirmarContrasena) {
                swal("Error", "Las contraseñas nuevas no coinciden", "error");
                isValid = false;
            }
            
            // Validar formato de contraseña
            if (nuevaContrasena && nuevaContrasena.length < 8) {
                swal("Error", "La contraseña debe tener al menos 8 caracteres", "error");
                isValid = false;
            }
        }
        
        if (!isValid) {
            e.preventDefault();
        }
    });
    
    // Validar teléfono en tiempo real
    $('#telefono').on('input', function() {
        const telefono = $(this).val();
        if (telefono.length > 9) {
            $(this).val(telefono.substring(0, 9));
        }
    });
});