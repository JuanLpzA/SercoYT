document.addEventListener('DOMContentLoaded', function () {
    const form = document.getElementById('formRegistro');

    // Validación en tiempo real para DNI
    document.getElementById('dni').addEventListener('input', function (e) {
        this.value = this.value.replace(/[^0-9]/g, '');
        if (this.value.length > 8) {
            this.value = this.value.slice(0, 8);
        }
    });

    // Validación en tiempo real para teléfono
    document.getElementById('telefono').addEventListener('input', function (e) {
        this.value = this.value.replace(/[^0-9]/g, '');
        if (this.value.length > 9) {
            this.value = this.value.slice(0, 9);
        }
    });

    form.addEventListener('submit', function (e) {
        // Validar contraseñas
        const contrasena = document.getElementById('contrasena').value;
        const confirmarContrasena = document.getElementById('confirmarContrasena').value;

        if (contrasena !== confirmarContrasena) {
            e.preventDefault();
            swal("Error", "Las contraseñas no coinciden", "error");
            return;
        }

        // Validar fortaleza de contraseña
        if (!/(?=.*[0-9])(?=.*[a-zA-Z]).{8,}/.test(contrasena)) {
            e.preventDefault();
            swal("Error", "La contraseña debe tener al menos 8 caracteres, incluyendo números y letras", "error");
            return;
        }

        // Validar DNI
        const dni = document.getElementById('dni').value;
        if (!/^[0-9]{8}$/.test(dni)) {
            e.preventDefault();
            swal("Error", "El DNI debe tener exactamente 8 dígitos", "error");
            return;
        }
    });
});