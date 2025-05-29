<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Mis Pedidos - SercoYT</title>
        <link rel="stylesheet" href="css/styleonline.css">
        <style>
            .pedidos-table {
                width: 100%;
                border-collapse: collapse;
                margin: 20px 0;
            }
            
            .pedidos-table th, .pedidos-table td {
                border: 1px solid #ddd;
                padding: 8px;
                text-align: left;
            }
            
            .pedidos-table th {
                background-color: #f2f2f2;
            }
            
            .pedidos-table tr:nth-child(even) {
                background-color: #f9f9f9;
            }
            
            .pedidos-table tr:hover {
                background-color: #f1f1f1;
            }
            
            .status-pending {
                color: #e67e22;
                font-weight: bold;
            }
            
            .status-shipping {
                color: #3498db;
                font-weight: bold;
            }
            
            .status-delivered {
                color: #2ecc71;
                font-weight: bold;
            }
            
            .status-cancelled {
                color: #e74c3c;
                font-weight: bold;
            }
        </style>
    </head>
    <body>
        <header class="main-header">
            <%@include file="resources/commons/header.jsp" %>
        </header>    

        <div class="container">
            <h2>Mis Pedidos</h2>
            
            <c:choose>
                <c:when test="${not empty ventas}">
                    <table class="pedidos-table">
                        <thead>
                            <tr>
                                <th>N° Pedido</th>
                                <th>Fecha</th>
                                <th>Total</th>
                                <th>Estado</th>
                                <th>Método de Pago</th>
                                <th>Acciones</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="venta" items="${ventas}">
                                <tr>
                                    <td>B001-${venta.idVenta}</td>
                                    <td>${venta.fecha}</td>
                                    <td>S/${venta.total}0</td>
                                    <td class="status-${venta.estadoDespacho.toLowerCase().replace(' ', '-')}">
                                        ${venta.estadoDespacho}
                                    </td>
                                    <td>${venta.formaPago}</td>
                                    <td>
                                        <a href="VentaControlador?accion=verBoleta&id=${venta.idVenta}" 
                                           class="btn btn-sm btn-primary">
                                            Ver Boleta
                                        </a>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </c:when>
                <c:otherwise>
                    <div class="alert alert-info">
                        No tienes pedidos registrados.
                    </div>
                    <a href="Controlador?accion=laptops" class="btn btn-primary">
                        Comenzar a Comprar
                    </a>
                </c:otherwise>
            </c:choose>
        </div>

        <footer class="main-footer">
            <%@include file="resources/commons/footer.jsp" %>
        </footer>
    </body>
</html>