<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Editar Producto</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/bootstrap.min.css">
</head>
<body>
    <div class="container mt-4">
        <h2>Editar Producto</h2>
        <form action="${pageContext.request.contextPath}/ProductoControlador?accion=actualizar" 
              method="POST" enctype="multipart/form-data">
            <input type="hidden" name="id" value="${producto.id}">
            
            <div class="form-group">
                <label>Nombre</label>
                <input type="text" name="nombre" class="form-control" value="${producto.nombres}" required>
            </div>
            
            <!-- Agrega los demás campos del formulario -->
            
            <button type="submit" class="btn btn-primary">Actualizar</button>
        </form>
    </div>
</body>
</html>