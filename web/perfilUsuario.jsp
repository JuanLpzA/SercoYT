<%-- 
    Document   : perfilUsuario
    Created on : 3 jun. 2025, 22:01:46
    Author     : Arrunategui
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>SercoYT - Mi Perfil</title>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/styleonline.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/perfil.css">
        <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@300;400;500;700&display=swap" rel="stylesheet">
        <link rel="stylesheet" href="https://use.fontawesome.com/releases/v5.8.2/css/all.css">
    </head>
    <body>
        <!-- Header -->
        <header class="main-header">
            <%@include file="resources/commons/header.jsp" %>
        </header>    

        <!-- Contenido Principal -->
        <main class="perfil-container">
            <div class="perfil-card">
                <div class="perfil-header">
                    <h2><i class="fas fa-user"></i> Mi Perfil</h2>
                    <p>Actualiza tu información personal</p>
                </div>

                <!-- Mostrar errores si existen -->
                <c:if test="${not empty error}">
                    <div class="alert alert-danger">
                        ${error}
                    </div>
                </c:if>
                
                <c:if test="${not empty success}">
                    <div class="alert alert-success">
                        ${success}
                    </div>
                </c:if>

                <form action="${pageContext.request.contextPath}/UsuarioControlador" method="POST" class="perfil-form" id="formPerfil">
                    <input type="hidden" name="accion" value="actualizarPerfil">
                    <input type="hidden" name="idUsuario" value="${usuario.idUsuario}">

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
                        <label for="dni">DNI</label>
                        <input type="text" id="dni" name="dni" readonly
                               class="form-control" value="${usuario.dni}">
                        <i class="fas fa-id-card input-icon"></i>
                        <small class="form-text">No se puede modificar el DNI</small>
                    </div>

                    <div class="form-group">
                        <label for="correo">Correo Electrónico</label>
                        <input type="email" id="correo" name="correo" readonly
                               class="form-control" value="${usuario.correo}">
                        <i class="fas fa-envelope input-icon"></i>
                        <small class="form-text">No se puede modificar el correo</small>
                    </div>

                    <div class="form-group">
                        <label for="telefono">Teléfono</label>
                        <input type="tel" id="telefono" name="telefono" 
                               placeholder="Ingrese su teléfono" 
                               pattern="[0-9]{9}" title="El teléfono debe tener 9 dígitos" 
                               class="form-control" value="${usuario.telefono}">
                        <i class="fas fa-phone input-icon"></i>
                    </div>

                    <div class="form-group">
                        <label for="direccion">Dirección <span class="required">*</span></label>
                        <input type="text" id="direccion" name="direccion" required 
                               placeholder="Ingrese su dirección" class="form-control"
                               value="${usuario.direccion}">
                        <i class="fas fa-map-marker-alt input-icon"></i>
                    </div>

                    <div class="form-group">
                        <label for="contrasenaActual">Contraseña Actual (para cambios)</label>
                        <input type="password" id="contrasenaActual" name="contrasenaActual" 
                               placeholder="Ingrese su contraseña actual" class="form-control">
                        <i class="fas fa-lock input-icon"></i>
                    </div>

                    <div class="form-row">
                        <div class="form-group">
                            <label for="nuevaContrasena">Nueva Contraseña</label>
                            <input type="password" id="nuevaContrasena" name="nuevaContrasena" 
                                   placeholder="Nueva contraseña (opcional)" class="form-control">
                            <i class="fas fa-lock input-icon"></i>
                            <small class="form-text">Mínimo 8 caracteres con números y letras</small>
                        </div>

                        <div class="form-group">
                            <label for="confirmarContrasena">Confirmar Contraseña</label>
                            <input type="password" id="confirmarContrasena" name="confirmarContrasena" 
                                   placeholder="Confirmar nueva contraseña" class="form-control">
                            <i class="fas fa-lock input-icon"></i>
                        </div>
                    </div>

                    <div class="form-footer">
                        <button type="submit" class="btn-perfil">
                            <i class="fas fa-save"></i> Guardar Cambios
                        </button>
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
        <script src="https://unpkg.com/sweetalert/dist/sweetalert.min.js"></script>
        <script src="${pageContext.request.contextPath}/js/validacionPerfil.js"></script>
    </body>
</html>
