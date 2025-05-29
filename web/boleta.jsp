<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Boleta de Compra - SercoYT</title>
        <link rel="stylesheet" href="css/styleonline.css">
    </head>
    <body>
        <header class="main-header">
            <%@include file="resources/commons/header.jsp" %>
        </header>    

        <div class="container">
            <h2>¡Compra realizada con éxito!</h2>
            
            <div class="boleta-info">
                <h3>N° Boleta: B001-${venta.idVenta}</h3>
                <p>Fecha: ${venta.fecha}</p>
                <p>Total: S/${venta.total}0</p>
                
                <div class="actions">
                    <a href="resources/pdf/${nombreArchivoPDF}" class="btn btn-primary" target="_blank">
                        Ver Boleta Completa (PDF)
                    </a>
                    <a href="Controlador?accion=laptops" class="btn btn-secondary">
                        Seguir Comprando
                    </a>
                    <a href="VentaControlador?accion=misPedidos" class="btn btn-success">
                        Ver Mis Pedidos
                    </a>
                </div>
            </div>
        </div>

        <footer class="main-footer">
            <%@include file="resources/commons/footer.jsp" %>
        </footer>
    </body>
</html>