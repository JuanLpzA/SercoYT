<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>SercoYT - Registrate</title>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/registro.css">
        <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@300;400;500;700&display=swap" rel="stylesheet">        
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/styleonline.css">
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
                    <h2><i class="fas fa-user-plus"></i> Crear Cuenta</h2>
                    <p>Únete a SercoYT y disfruta de nuestros servicios</p>
                </div>

                <!-- Mostrar errores si existen -->
                <c:if test="${not empty error}">
                    <div class="alert alert-danger">
                        ${error}
                    </div>
                </c:if>

                <form action="${pageContext.request.contextPath}/UsuarioControlador" method="POST" class="registro-form" id="formRegistro">
                    <input type="hidden" name="accion" value="guardar">

                    <!-- Campos del formulario (se mantienen igual) -->
                    <div class="form-row">
                        <div class="form-group">
                            <label for="nombre">Nombre <span class="required">*</span></label>
                            <input type="text" id="nombre" name="nombre" required 
                                   placeholder="Ingrese su nombre" class="form-control"
                                   value="${usuario.nombre}">
                            <i class="fas fa-user input-icon"></i>
                        </div>

                        <div class="form-group">
                            <label for="apellido">Apellido <span class="required">*</span></label>
                            <input type="text" id="apellido" name="apellido" required 
                                   placeholder="Ingrese su apellido" class="form-control"
                                   value="${usuario.apellido}">
                            <i class="fas fa-user input-icon"></i>
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="dni">DNI <span class="required">*</span></label>
                        <input type="text" id="dni" name="dni" required 
                               placeholder="Ingrese su DNI (8 dígitos)" pattern="[0-9]{8}" 
                               title="El DNI debe tener 8 dígitos" class="form-control"
                               value="${usuario.dni}">
                        <i class="fas fa-id-card input-icon"></i>
                    </div>
                    
                    <div class="form-row">
                        <div class="form-group">
                            <label for="contrasena">Contraseña <span class="required">*</span></label>
                            <input type="password" id="contrasena" name="contrasena" required 
                                   placeholder="Cree una contraseña" class="form-control">
                            <i class="fas fa-lock input-icon"></i>
                            <small class="form-text">Mínimo 8 caracteres con números y letras</small>
                        </div>

                        <div class="form-group">
                            <label for="confirmarContrasena">Confirmar Contraseña <span class="required">*</span></label>
                            <input type="password" id="confirmarContrasena" name="confirmarContrasena" required 
                                   placeholder="Repita la contraseña" class="form-control">
                            <i class="fas fa-lock input-icon"></i>
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="correo">Correo Electrónico <span class="required">*</span></label>
                        <input type="email" id="correo" name="correo" required 
                               placeholder="ejemplo@dominio.com" class="form-control"
                               value="${usuario.correo}">
                        <i class="fas fa-envelope input-icon"></i>
                    </div>

                    <div class="form-group">
                        <label for="direccion">Dirección <span class="required">*</span></label>
                        <input type="text" id="direccion" name="direccion" required 
                               placeholder="Ingrese su dirección" class="form-control"
                               value="${usuario.direccion}">
                        <i class="fas fa-map-marker-alt input-icon"></i>
                    </div>

                    <div class="form-group">
                        <label for="telefono">Teléfono</label>
                        <input type="tel" id="telefono" name="telefono" 
                               placeholder="Ingrese su teléfono (opcional)" 
                               pattern="[0-9]{9}" title="El teléfono debe tener 9 dígitos" 
                               class="form-control" value="${usuario.telefono}">
                        <i class="fas fa-phone input-icon"></i>
                    </div>

                    <div class="form-footer">
                        <button type="submit" class="btn-registro">
                            <i class="fas fa-user-plus"></i> Registrarse
                        </button>

                        <div class="login-link">
                            ¿Ya tienes una cuenta? <a href="${pageContext.request.contextPath}/UsuarioControlador?accion=login">Inicia sesión aquí</a>
                        </div>

                        <div class="login-info">
                            <i class="fas fa-info-circle"></i> Para iniciar sesión posteriormente, utilizarás tu DNI y contraseña.
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
        
        <!-- Script de validación -->
        <script src="${pageContext.request.contextPath}/js/validacionRegistro.js"></script>
    </body>
</html>