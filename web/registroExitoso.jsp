<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Registro Exitoso - SercoYT</title>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/registro.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/styleonline.css">
        <link rel="stylesheet" href="https://use.fontawesome.com/releases/v5.8.2/css/all.css">
    </head>
    <body>
        <header class="main-header">
            <%@include file="resources/commons/header.jsp" %>
        </header>
        
        <main class="registro-container">
            <div class="registro-card">
                <div class="registro-header" style="background: #4CAF50;">
                    <h2><i class="fas fa-check-circle"></i> ¡Registro Exitoso!</h2>
                </div>
                
                <div class="confirmacion-body">
                    <p>Tu cuenta ha sido registrada correctamente.</p>
                    <p>Ahora puedes iniciar sesión con tu DNI y contraseña.</p>
                    
                    <div class="form-footer">
                        <a href="${pageContext.request.contextPath}/UsuarioControlador?accion=login" class="btn-registro">
                            <i class="fas fa-sign-in-alt"></i> Iniciar Sesión
                        </a>
                    </div>
                </div>
            </div>
        </main>
        
        <footer class="main-footer">
            <%@include file="resources/commons/footer.jsp" %>
        </footer>
    </body>
</html>