<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>SercoYT - Recuperar Contraseña</title>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/styleonline.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/registro.css">
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
                    <h2><i class="fas fa-key"></i> Recuperar Contraseña</h2>
                    <p>Ingresa tu correo electrónico para recuperar tu cuenta</p>
                </div>

                <!-- Mostrar errores si existen -->
                <c:if test="${not empty error}">
                    <div class="alert alert-danger">
                        ${error}
                    </div>
                </c:if>

                <!-- Mostrar éxito si existe -->
                <c:if test="${not empty exito}">
                    <div class="alert alert-success">
                        ${exito}
                    </div>
                </c:if>

                <!-- Paso 1: Ingresar correo -->
                <c:if test="${empty mostrarIngresoCorreo or mostrarIngresoCorreo}">
                    <form action="${pageContext.request.contextPath}/UsuarioControlador" method="POST" class="registro-form">
                        <input type="hidden" name="accion" value="enviarCodigo">

                        <div class="form-group">
                            <label for="correo">Correo Electrónico <span class="required">*</span></label>
                            <input type="email" id="correo" name="correo" required 
                                   placeholder="Ingrese su correo electrónico" class="form-control">
                            <i class="fas fa-envelope input-icon"></i>
                        </div>

                        <div class="form-footer">
                            <button type="submit" class="btn-registro">
                                <i class="fas fa-paper-plane"></i> Enviar Código
                            </button>
                            <div class="login-link">
                                <a href="${pageContext.request.contextPath}/UsuarioControlador?accion=login">Volver a Iniciar Sesión</a>
                            </div>
                        </div>
                    </form>
                </c:if>

                <!-- Paso 2: Ingresar código -->
                <c:if test="${mostrarIngresoCodigo}">
                    <form action="${pageContext.request.contextPath}/UsuarioControlador" method="POST" class="registro-form">
                        <input type="hidden" name="accion" value="cambiarContrasena">
                        <input type="hidden" name="correo" value="${correo}">

                        <div class="form-group">
                            <label for="codigo">Código de Verificación <span class="required">*</span></label>
                            <input type="text" id="codigo" name="codigo" required 
                                   placeholder="Ingrese el código enviado a su correo" class="form-control">
                            <i class="fas fa-key input-icon"></i>
                        </div>

                        <div class="form-group">
                            <label for="nuevaContrasena">Nueva Contraseña <span class="required">*</span></label>
                            <input type="password" id="nuevaContrasena" name="nuevaContrasena" required 
                                   placeholder="Ingrese su nueva contraseña" class="form-control">
                            <i class="fas fa-lock input-icon"></i>
                            <small class="form-text">Mínimo 8 caracteres con números y letras</small>
                        </div>

                        <div class="form-group">
                            <label for="confirmarContrasena">Confirmar Contraseña <span class="required">*</span></label>
                            <input type="password" id="confirmarContrasena" name="confirmarContrasena" required 
                                   placeholder="Repita la nueva contraseña" class="form-control">
                            <i class="fas fa-lock input-icon"></i>
                        </div>

                        <div class="form-footer">
                            <button type="submit" class="btn-registro">
                                <i class="fas fa-sync-alt"></i> Cambiar Contraseña
                            </button>
                        </div>
                    </form>
                </c:if>
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
    </body>
</html>