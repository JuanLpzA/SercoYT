<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Verificación de Correo - SercoYT</title>
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
                    <h2><i class="fas fa-envelope"></i> Verifica tu correo</h2>
                </div>
                
                <form action="${pageContext.request.contextPath}/UsuarioControlador" method="POST" class="registro-form">
                    <input type="hidden" name="accion" value="verificar">
                    
                    <div class="form-group">
                        <p>Hemos enviado un código de verificación a <strong>${correo}</strong>.</p>
                        <p>Por favor ingresa el código de 6 dígitos que recibiste:</p>
                    </div>
                    
                    <div class="form-group">
                        <label for="codigo">Código de Verificación <span class="required">*</span></label>
                        <input type="text" id="codigo" name="codigo" required 
                               placeholder="Ingresa el código de 6 dígitos" 
                               pattern="[0-9]{6}" title="El código debe tener 6 dígitos"
                               class="form-control">
                        <i class="fas fa-key input-icon"></i>
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
    </body>
</html>