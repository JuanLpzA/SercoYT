<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>SercoYT - Iniciar Sesión</title>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/styleonline.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/iniciosesion.css">
        <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@300;400;500;700&display=swap" rel="stylesheet">
        <link rel="stylesheet" href="https://use.fontawesome.com/releases/v5.8.2/css/all.css">
    </head>
    <body>
        <!-- Header -->
        <header class="main-header">
            <%@include file="resources/commons/header.jsp" %>
        </header>    
        <!-- Contenido Principal -->
        <main class="registro-container">
            <div class="registro-card">
                <div class="registro-header">
                    <h2><i class="fas fa-sign-in-alt"></i> Iniciar Sesión</h2>
                    <p>Ingresa a tu cuenta de SercoYT</p>
                </div>
                <!-- Mostrar errores si existen -->
                <c:if test="${not empty error}">
                    <div class="alert alert-danger">
                        ${error}
                    </div>
                </c:if>
                <form action="${pageContext.request.contextPath}/UsuarioControlador" method="POST" class="registro-form">
                    <input type="hidden" name="accion" value="login">
                    <div class="form-group">
                        <label for="dni">DNI <span class="required">*</span></label>
                        <input type="text" id="dni" name="dni" required 
                               placeholder="Ingrese su DNI" pattern="[0-9]{8}" 
                               maxlength="8"
                               class="form-control">
                        <i class="fas fa-id-card input-icon"></i>
                    </div>
                    <div class="form-group">
                        <label for="contrasena">Contraseña <span class="required">*</span></label>
                        <input type="password" id="contrasena" name="contrasena" required 
                               placeholder="Ingrese su contraseña" class="form-control">
                        <i class="fas fa-lock input-icon"></i>
                    </div>
                    <div class="form-footer">
                        <button type="submit" class="btn-registro">
                            <i class="fas fa-sign-in-alt"></i> Iniciar Sesión
                        </button>
                        <div class="login-links">
                            <a href="${pageContext.request.contextPath}/UsuarioControlador?accion=nuevo">¿No tienes cuenta? Regístrate aquí</a>
                            <a href="${pageContext.request.contextPath}/UsuarioControlador?accion=recuperar">¿Olvidaste tu contraseña?</a>
                        </div>
                    </div>
                </form>
            </div>
        </main>
        <!-- Footer -->
        <footer class="main-footer">
            <%@include file="resources/commons/footer.jsp" %>
        </footer>    
        <!-- Scripts -->
        <script src="${pageContext.request.contextPath}/js/jquery-3.7.1.min.js"></script>
        <script src="${pageContext.request.contextPath}/js/bootstrap.min.js"></script>    
        <script src="https://unpkg.com/sweetalert/dist/sweetalert.min.js"></script>
        
        <!-- Script para validación de DNI -->
        <script>
            document.addEventListener('DOMContentLoaded', function() {
                const dniInput = document.getElementById('dni');
                
                // Función para permitir solo números
                dniInput.addEventListener('input', function(e) {
                    // Eliminar cualquier carácter que no sea número
                    let value = e.target.value.replace(/[^0-9]/g, '');
                    
                    // Limitar a 8 dígitos
                    if (value.length > 8) {
                        value = value.substring(0, 8);
                    }
                    
                    // Actualizar el valor del input
                    e.target.value = value;
                });
                
                // Prevenir pegar contenido no válido
                dniInput.addEventListener('paste', function(e) {
                    e.preventDefault();
                    let paste = (e.clipboardData || window.clipboardData).getData('text');
                    // Filtrar solo números y limitar a 8 dígitos
                    let filteredPaste = paste.replace(/[^0-9]/g, '').substring(0, 8);
                    this.value = filteredPaste;
                });
                
                // Prevenir teclas no numéricas (excepto las de control)
                dniInput.addEventListener('keydown', function(e) {
                    // Permitir teclas de control: backspace, delete, tab, escape, enter
                    if ([8, 9, 27, 13, 46].indexOf(e.keyCode) !== -1 ||
                        // Permitir Ctrl+A, Ctrl+C, Ctrl+V, Ctrl+X
                        (e.keyCode === 65 && e.ctrlKey === true) ||
                        (e.keyCode === 67 && e.ctrlKey === true) ||
                        (e.keyCode === 86 && e.ctrlKey === true) ||
                        (e.keyCode === 88 && e.ctrlKey === true) ||
                        // Permitir home, end, left, right
                        (e.keyCode >= 35 && e.keyCode <= 39)) {
                        return;
                    }
                    // Asegurar que sea un número del 0-9
                    if ((e.shiftKey || (e.keyCode < 48 || e.keyCode > 57)) && 
                        (e.keyCode < 96 || e.keyCode > 105)) {
                        e.preventDefault();
                    }
                    // No permitir más de 8 dígitos SOLO si no hay texto seleccionado
                    const hasSelection = e.target.selectionStart !== e.target.selectionEnd;
                    if (e.target.value.length >= 8 && !hasSelection &&
                        [8, 9, 27, 13, 46].indexOf(e.keyCode) === -1 &&
                        !(e.keyCode >= 35 && e.keyCode <= 39)) {
                        e.preventDefault();
                    }
                });
            });
        </script>
    </body>
</html>