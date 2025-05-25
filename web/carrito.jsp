<%-- 
    Document   : carrito
    Created on : 9 may. 2025, 19:29:31
    Author     : Arrunategui
--%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>SercoYT - Tecnología y Computación</title>
        <link rel="stylesheet" href="css/styleonline.css">
        <link rel="stylesheet" href="https://use.fontawesome.com/releases/v5.8.2/css/all.css">
    </head>

    <body>
        <!-- Header -->
        <header class="main-header">
            <%@include file="resources/commons/header.jsp" %>
        </header>    

        <!-- Sección del carrito con estilos personalizados -->
        <div class="cart-container-section">
            <h2 class="section-title">Mi Carrito de Compras</h2>
            
            <div class="cart-content">
                <div class="cart-items">
                    <table class="cart-table">
                        <thead>
                            <tr>
                                <th>ITEM</th>
                                <th>NOMBRE</th>
                                <th>DESCRIPCION</th>
                                <th>PRECIO</th>
                                <th>CANT</th>
                                <th>SUBTOTAL</th>
                                <th>ACCIÓN</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="car" items="${carrito}">
                                <tr>
                                <td>${car.getItem()}</td>
                                <td>${car.getNombres()}</td>
                                <td>
                                    ${car.getDescripcion()}<br/>
                                    <img src="ControladorIMG?id=${car.getIdProducto()}" width="100" height="100"/>
                                </td>
                                <td>${car.getPrecioCompra()}0</td>
                                <td>
                                    <input type="hidden" id="idpro" value="${car.getIdProducto()}">
                                    <input type="number" id="Cantidad" value="${car.getCantidad()}" 
                                           min="1" class="quantity-input form-control text-center"
                                           title="La cantidad mínima permitida es 1">
                                </td>
                                <td>${car.getSubTotal()}0</td>
                                <td>
                                    <input type="hidden" id="idp" value="${car.getIdProducto()}">
                                    <a class="btn-remove-item" href="#" id="btnDelete" >Eliminar</a>
                                </td>
                            </tr>
                                
                            </c:forEach>
                            
                            <!-- Más filas de productos -->
                        </tbody>
                    </table>
                </div>
                
                <div class=".cart-summary">
                    <div class="summary-card">
                        <div class="summary-header">
                            <h3>Resumen de Compra</h3>
                        </div>
                        <div class="summary-body">
                            <div class="summary-row">
                                <label>Subtotal:</label>
                                <input type="text" value="S/${totalPagar}0" readonly>
                            </div>
                            <div class="summary-row">
                                <label>Descuento:</label>
                                <input type="text" value="S/0" readonly>
                            </div>
                            <div class="summary-row total">
                                <label>Total a Pagar:</label>
                                <input type="text" value="S/${totalPagar}0" readonly>
                            </div>
                        </div>
                        <div class="summary-footer">
                            <button class="btn-payment">Realizar Pago</button>
                            <button class="btn-generate-order">Generar Compra</button>
                        </div>
                    </div>
                </div>
            </div>
        </div>
                            

        <!-- Footer -->
        <footer class="main-footer">
            <%@include file="resources/commons/footer.jsp" %>
        </footer>    
        
        <script src="${pageContext.request.contextPath}/js/jquery-3.7.1.min.js"></script>
        <script src="${pageContext.request.contextPath}/js/bootstrap.min.js"></script>    
        
        <script src="https://unpkg.com/sweetalert/dist/sweetalert.min.js"></script>
        <script src="js/funciones.js" type="text/javascript"></script>
    </body>
</html>