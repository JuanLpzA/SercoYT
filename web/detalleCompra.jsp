<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>SercoYT - Detalle de Compra</title>
        <link rel="stylesheet" href="css/styleonline.css">
        <link rel="stylesheet" href="css/detalleCompra.css">
        <link rel="stylesheet" href="https://use.fontawesome.com/releases/v5.8.2/css/all.css">
    </head>
    <body>
        <!-- Header -->
        <header class="main-header">
            <%@include file="resources/commons/header.jsp" %>
        </header>    

        <!-- Contenido principal -->
        <div class="main-container">
            <div class="order-detail-header">
                <h2>Detalle de Pedido #${venta.idVenta}</h2>
                <a href="VentaControlador?accion=listarCompras" class="btn-back">
                    <i class="fas fa-arrow-left"></i> Volver a mis pedidos
                </a>
            </div>
            
            <div class="order-detail-card">
                <div class="order-info-section">
                    <div class="info-block">
                        <h3>Información del Pedido</h3>
                        <div class="info-row">
                            <span>Fecha:</span>
                            <span><fmt:formatDate value="${venta.fecha}" pattern="dd/MM/yyyy HH:mm"/></span>
                        </div>
                        <div class="info-row">
                            <span>Cliente:</span>
                            <span>${venta.clienteNombre} (DNI: ${venta.clienteDni})</span>
                        </div>
                        <div class="info-row">
                            <span>Tipo de venta:</span>
                            <span>${venta.tipoVentaNombre}</span>
                        </div>
                        <div class="info-row">
                            <span>Estado:</span>
                            <span class="status-badge ${fn:toLowerCase(fn:replace(venta.estadoNombre, ' ', '-'))}">
                                ${venta.estadoNombre}
                            </span>
                        </div>
                    </div>
                    
                    <div class="info-block">
                        <h3>Información de Pago</h3>
                        <div class="info-row">
                            <span>Método de pago:</span>
                            <span>${venta.metodoPagoNombre}</span>
                        </div>
                        <div class="info-row">
                            <span>Subtotal:</span>
                            <span>S/<fmt:formatNumber value="${venta.subtotal}" maxFractionDigits="2" minFractionDigits="2"/></span>
                        </div>
                        <div class="info-row">
                            <span>IGV (18%):</span>
                            <span>S/<fmt:formatNumber value="${venta.igv}" maxFractionDigits="2" minFractionDigits="2"/></span>
                        </div>
                        <div class="info-row total">
                            <span>Total:</span>
                            <span>S/<fmt:formatNumber value="${venta.total}" maxFractionDigits="2" minFractionDigits="2"/></span>
                        </div>
                    </div>
                </div>
                
                <c:if test="${not empty direccion}">
                    <div class="shipping-section">
                        <h3>Dirección de Envío</h3>
                        <div class="shipping-address">
                            <p><strong>Receptor:</strong> ${direccion.nombreReceptor}</p>
                            <p><strong>Teléfono:</strong> ${direccion.telefono}</p>
                            <p><strong>Provincia:</strong> ${direccion.provincia}</p>
                            <p><strong>Dirección:</strong> ${direccion.direccion}</p>
                        </div>
                    </div>
                </c:if>
                
                <div class="products-section">
                    <h3>Productos</h3>
                    <table class="products-table">
                        <thead>
                            <tr>
                                <th>Producto</th>
                                <th>Precio Unitario</th>
                                <th>Cantidad</th>
                                <th>Subtotal</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="detalle" items="${detalles}">
                                <tr>
                                    <td>
                                        <div class="product-info">
                                            <img src="ControladorIMG?id=${detalle.idProducto}" width="60" height="60" alt="Producto">
                                            <span>${detalle.nombreProducto}</span>
                                        </div>
                                    </td>
                                    <td>S/<fmt:formatNumber value="${detalle.precioUnitario}" maxFractionDigits="2" minFractionDigits="2"/></td>
                                    <td>${detalle.cantidad}</td>
                                    <td>S/<fmt:formatNumber value="${detalle.subtotal}" maxFractionDigits="2" minFractionDigits="2"/></td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
                
                <div class="order-actions">
                    <a href="VentaControlador?accion=generarBoleta&id=${venta.idVenta}" 
                       class="btn-invoice" target="_blank">
                        <i class="fas fa-file-pdf"></i> Descargar Boleta
                    </a>
                </div>
            </div>
        </div>

        <!-- Footer -->
        <footer class="main-footer">
            <%@include file="resources/commons/footer.jsp" %>
        </footer>    
        
        <script src="${pageContext.request.contextPath}/js/jquery-3.7.1.min.js"></script>
        <script src="https://unpkg.com/sweetalert/dist/sweetalert.min.js"></script>
        <script src="js/funciones.js" type="text/javascript"></script>
    </body>
</html>