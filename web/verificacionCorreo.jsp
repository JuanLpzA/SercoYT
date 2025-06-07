<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Verificación de Correo - SercoYT</title>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/verificacioncorreo.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/styleonline.css">
        <link rel="stylesheet" href="https://use.fontawesome.com/releases/v5.8.2/css/all.css">
        <!-- SweetAlert2 -->
        <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    </head>
    <body>
        <header class="main-header">
            <%@include file="resources/commons/header.jsp" %>
        </header>
        <main class="registro-container">
            <div class="registro-card">
                <div class="registro-header" style="background: #4CAF50;">
                    <h2><i class="fas fa-envelope"></i> Verifica tu correo</h2>
                </div>
                <form id="verificacionForm" action="${pageContext.request.contextPath}/UsuarioControlador" method="POST" class="registro-form">
                    <input type="hidden" name="accion" value="verificar">
                    <div class="form-group">
                        <p>Hemos enviado un código de verificación a <strong>${correo}</strong>.</p>
                        <p>Por favor ingresa el código de 6 dígitos que recibiste:</p>
                    </div>
                        <div class="form-group">
                            <label for="codigo">Código de Verificación <span class="required">*</span></label>
                            <input type="text" id="codigo" name="codigo" required
                                   placeholder="Ingresa el código"
                                   pattern="\d{6}" maxlength="6" minlength="6"
                                   title="El código debe tener exactamente 6 dígitos"
                                   class="form-control">
                        </div>
                    <div class="form-footer">
                        <button type="submit" class="btn-registro">
                            <i class="fas fa-check-circle"></i> Verificar
                        </button>
                        <div class="info-adicional">
                            <i class="fas fa-info-circle"></i> Si no recibiste el código, revisa tu carpeta de spam.
                        </div>
                    </div>
                </form>
            </div>
        </main>
        <footer class="main-footer">
            <%@include file="resources/commons/footer.jsp" %>
        </footer>

        <!-- JavaScript -->
        <script src="${pageContext.request.contextPath}/js/verificacioncorreo.js"></script>
        
        <!-- Verificar si la verificación fue exitosa -->
        <% if (request.getAttribute("verificacionExitosa") != null && (Boolean)request.getAttribute("verificacionExitosa")) { %>
        <script>
            document.addEventListener('DOMContentLoaded', function() {
                Swal.fire({
                    icon: 'success',
                    title: '¡Registro Exitoso!',
                    html: 'Tu cuenta ha sido registrada correctamente.<br>Ahora puedes iniciar sesión con tu DNI y contraseña.',
                    confirmButtonText: '<i class="fas fa-sign-in-alt"></i> Iniciar Sesión',
                    confirmButtonColor: '#4CAF50',
                    allowOutsideClick: false
                }).then((result) => {
                    if (result.isConfirmed) {
                        window.location.href = '${pageContext.request.contextPath}/UsuarioControlador?accion=login';
                    }
                });
            });
        </script>
        <% } %>
    </body>
</html>