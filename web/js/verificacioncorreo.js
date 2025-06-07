document.addEventListener('DOMContentLoaded', function() {
    const form = document.getElementById('verificacionForm');
    
    if (form) {
        form.addEventListener('submit', function(e) {
            const codigo = document.getElementById('codigo').value;
            
            // Validación básica
            if (codigo.length !== 6 || !/^\d{6}$/.test(codigo)) {
                e.preventDefault();
                Swal.fire({
                    icon: 'error',
                    title: 'Error',
                    text: 'El código debe tener exactamente 6 dígitos',
                    confirmButtonColor: '#4CAF50'
                });
                return;
            }
            
            // Mostrar loading antes de enviar el formulario
            e.preventDefault();
            
            Swal.fire({
                title: 'Verificando...',
                text: 'Por favor espera mientras verificamos tu código',
                allowOutsideClick: false,
                showConfirmButton: false,
                willOpen: () => {
                    Swal.showLoading();
                }
            });
            
            // Pequeño delay para que se vea el loading y luego enviar el formulario normalmente
            setTimeout(() => {
                form.submit();
            }, 500);
        });
    }
});