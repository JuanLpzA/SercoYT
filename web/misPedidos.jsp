<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Mis Pedidos - SercoYT</title>
        <link rel="stylesheet" href="css/styleonline.css">
        <link rel="stylesheet" href="https://use.fontawesome.com/releases/v5.8.2/css/all.css">
        <style>
            .main-container {
                max-width: 1200px;
                margin: 20px auto;
                padding: 20px;
                background-color: #fff;
                border-radius: 8px;
                box-shadow: 0 0 10px rgba(0,0,0,0.1);
            }
            
            .orders-header {
                display: flex;
                justify-content: space-between;
                align-items: center;
                margin-bottom: 20px;
                padding-bottom: 10px;
                border-bottom: 1px solid #eee;
            }
            
            .orders-title {
                font-size: 24px;
                color: #333;
            }
            
            .orders-table {
                width: 100%;
                border-collapse: collapse;
                margin-top: 20px;
            }
            
            .orders-table th {
                background-color: #f8f9fa;
                padding: 12px 15px;
                text-align: left;
                font-weight: 600;
                color: #495057;
                border-bottom: 2px solid #dee2e6;
            }
            
            .orders-table td {
                padding: 12px 15px;
                border-bottom: 1px solid #dee2e6;
                vertical-align: middle;
            }
            
            .orders-table tr:hover {
                background-color: #f8f9fa;
            }
            
            .order-id {
                font-weight: 600;
                color: #007bff;
            }
            
            .order-date {
                white-space: nowrap;
            }
            
            .order-total {
                font-weight: 600;
                color: #28a745;
            }
            
            .status-badge {
                padding: 5px 10px;
                border-radius: 20px;
                font-size: 12px;
                font-weight: 600;
                text-transform: capitalize;
            }
            
            .status-en-espera {
                background-color: #fff3cd;
                color: #856404;
            }
            
            .status-en-reparto {
                background-color: #cce5ff;
                color: #004085;
            }
            
            .status-entregado {
                background-color: #d4edda;
                color: #155724;
            }
            
            .status-cancelado {
                background-color: #f8d7da;
                color: #721c24;
            }
            
            .btn-action {
                padding: 6px 12px;
                border-radius: 4px;
                font-size: 14px;
                cursor: pointer;
                text-decoration: none;
                display: inline-flex;
                align-items: center;
                justify-content: center;
            }
            
            .btn-view {
                background-color: #17a2b8;
                color: white;
                border: none;
            }
            
            .btn-view:hover {
                background-color: #138496;
            }
            
            .btn-download {
                background-color: #28a745;
                color: white;
                border: none;
                margin-left: 5px;
            }
            
            .btn-download:hover {
                background-color: #218838;
            }
            
            .no-orders {
                text-align: center;
                padding: 40px;
                background-color: #f8f9fa;
                border-radius: 8px;
                margin-top: 20px;
            }
            
            .no-orders-icon {
                font-size: 50px;
                color: #6c757d;
                margin-bottom: 15px;
            }
            
            .no-orders-text {
                font-size: 18px;
                color: #6c757d;
                margin-bottom: 20px;
            }
            
            .btn-start-shopping {
                padding: 10px 20px;
                background-color: #007bff;
                color: white;
                border: none;
                border-radius: 4px;
                text-decoration: none;
                font-weight: 500;
            }
            
            .btn-start-shopping:hover {
                background-color: #0069d9;
            }
        </style>
    </head>
    <body>
        <header class="main-header">
            <%@include file="resources/commons/header.jsp" %>
        </header>    

        <div class="main-container">
            <div class="orders-header">
                <h1 class="orders-title">Mis Pedidos</h1>
            </div>
            
            <c:choose>
                <c:when test="${not empty ventas}">
                    <table class="orders-table">
                        <thead>
                            <tr>
                                <th>N° Pedido</th>
                                <th>Fecha</th>
                                <th>Cliente</th>
                                <th>DNI</th>
                                <th>Tipo</th>
                                <th>Estado</th>
                                <th>Método Pago</th>
                                <th>Total</th>
                                <th>Acciones</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="venta" items="${ventas}">
                                <tr>
                                    <td class="order-id">B001-${venta.idVenta}</td>
                                    <td class="order-date"><fmt:formatDate value="${venta.fecha}" pattern="dd/MM/yyyy HH:mm"/></td>
                                    <td>${venta.clienteNombre}</td>
                                    <td>${venta.clienteDni}</td>
                                    <td>${venta.tipoVentaNombre}</td>
                                    <td>
                                        <span class="status-badge status-${fn:toLowerCase(fn:replace(venta.estadoNombre, ' ', '-'))}">
                                            ${venta.estadoNombre}
                                        </span>
                                    </td>
                                    <td>${venta.metodoPagoNombre}</td>
                                    <td class="order-total">S/<fmt:formatNumber value="${venta.total}" maxFractionDigits="2" minFractionDigits="2"/></td>
                                    <td>
                                        <a href="VentaControlador?accion=verDetalle&id=${venta.idVenta}" 
                                           class="btn-action btn-view" title="Ver Detalle">
                                            <i class="fas fa-eye"></i>
                                        </a>
                                        <a href="VentaControlador?accion=generarBoleta&id=${venta.idVenta}" 
                                           class="btn-action btn-download" title="Descargar Boleta" target="_blank">
                                            <i class="fas fa-file-pdf"></i>
                                        </a>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </c:when>
                <c:otherwise>
                    <div class="no-orders">
                        <div class="no-orders-icon">
                            <i class="fas fa-box-open"></i>
                        </div>
                        <h3 class="no-orders-text">No tienes pedidos registrados</h3>
                        <a href="Controlador?accion=laptops" class="btn-start-shopping">
                            <i class="fas fa-shopping-cart"></i> Comenzar a Comprar
                        </a>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>

        <footer class="main-footer">
            <%@include file="resources/commons/footer.jsp" %>
        </footer>
        
        <script src="${pageContext.request.contextPath}/js/jquery-3.7.1.min.js"></script>
        <script src="https://unpkg.com/sweetalert/dist/sweetalert.min.js"></script>
        <script src="js/funciones.js" type="text/javascript"></script>
    </body>
</html>