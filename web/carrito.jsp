<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>SercoYT - Carrito</title>
        <link rel="stylesheet" href="css/styleonline.css">
        <link rel="stylesheet" href="css/carrito.css">
        <link rel="stylesheet" href="https://use.fontawesome.com/releases/v5.8.2/css/all.css">
        
    </head>
    <body>
        <!-- Header -->
        <header class="main-header">
            <%@include file="resources/commons/header.jsp" %>
        </header>    
        
        <!-- Sección del carrito -->
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
                                    <td>S/<fmt:formatNumber value="${car.getPrecioCompra()}" maxFractionDigits="2" minFractionDigits="2"/></td>
                                    <td>
                                        <input type="hidden" id="idpro" value="${car.getIdProducto()}">
                                        <input type="number" id="Cantidad" value="${car.getCantidad()}" 
                                               min="1" max="${car.getStock()}" class="quantity-input form-control text-center"
                                               title="La cantidad mínima permitida es 1">
                                    </td>
                                    <td>S/<fmt:formatNumber value="${car.getSubTotal()}" maxFractionDigits="2" minFractionDigits="2"/></td>
                                    <td>
                                        <input type="hidden" id="idp" value="${car.getIdProducto()}">
                                        <a class="btn-remove-item" href="#" id="btnDelete">Eliminar</a>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
                
                <div class="cart-summary">
                    <div class="summary-card">
                        <div class="summary-header">
                            <h3>Resumen de Compra</h3>
                        </div>
                        <div class="summary-body">
                            <div class="summary-row">
                                <label>Subtotal:</label>
                                <input type="text" value="S/<fmt:formatNumber value='${totalPagar}' maxFractionDigits='2' minFractionDigits='2'/>" readonly>
                            </div>
                            <div class="summary-row">
                                <label>IGV (18%):</label>
                                <input type="text" value="S/<fmt:formatNumber value='${totalPagar * 0.18}' maxFractionDigits='2' minFractionDigits='2'/>" readonly>
                            </div>
                            <div class="summary-row total">
                                <label>Total a Pagar:</label>
                                <input type="text" value="S/<fmt:formatNumber value='${totalPagar * 1.18}' maxFractionDigits='2' minFractionDigits='2'/>" readonly>
                            </div>
                        </div>
                        <div class="summary-footer">
                            <c:choose>
                                <c:when test="${empty sessionScope.usuario}">
                                    <a href="UsuarioControlador?accion=login&redirect=carrito" class="btn btn-primary">Iniciar Sesión para Pagar</a>
                                    <button type="button" class="btn btn-success" disabled>Generar Compra</button>
                                </c:when>
                                <c:otherwise>
                                    <button id="btnRealizarPago" class="btn btn-primary">Realizar Pago</button>
                                    <button id="btnGenerarCompra" class="btn btn-success" style="display:none;">Generar Compra</button>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        
        <!-- Modal de Pago -->
        <div id="paymentModal" class="modal-overlay">
            <div class="modal-content">
                <h3>Método de Pago</h3>
                <div class="payment-methods">
                    <div class="payment-method" data-method="tarjeta">
                        <h4>Tarjeta de Crédito/Débito</h4>
                        <p>Pago con Visa, Mastercard, etc.</p>
                    </div>
                    <div class="payment-method" data-method="yape">
                        <h4>Yape</h4>
                        <p>Pago con código QR</p>
                    </div>
                </div>
                
                <div id="tarjetaForm" class="payment-form" style="display:none;">
                    <form id="creditCardForm">
                        <div class="form-group">
                            <label for="cardNumber">Número de Tarjeta</label>
                            <input type="text" id="cardNumber" placeholder="1234 5678 9012 3456" required maxlength="19">
                            <div class="error-message" id="cardNumberError">Solo números y debe tener 16 dígitos</div>
                        </div>
                        <div class="form-group">
                            <label for="cardName">Nombre en la Tarjeta</label>
                            <input type="text" id="cardName" placeholder="JUAN PEREZ" required>
                            <div class="error-message" id="cardNameError">Ingrese el nombre como aparece en la tarjeta</div>
                        </div>
                        <div style="display: flex; gap: 15px;">
                            <div class="form-group" style="flex: 1;">
                                <label for="expiryDate">Fecha de Expiración</label>
                                <input type="text" id="expiryDate" placeholder="MM/AA" required maxlength="5">
                                <div class="error-message" id="expiryDateError">Formato MM/AA (ej. 12/25)</div>
                            </div>
                            <div class="form-group" style="flex: 1;">
                                <label for="cvv">CVV</label>
                                <input type="text" id="cvv" placeholder="123" required maxlength="3">
                                <div class="error-message" id="cvvError">3 dígitos numéricos</div>
                            </div>
                        </div>
                        <div class="form-actions">
                            <button type="button" class="btn btn-secondary" id="cancelPayment">Cancelar</button>
                            <button type="button" class="btn btn-primary" id="confirmPayment">Confirmar Pago</button>
                        </div>
                    </form>
                </div>
                
                <div id="yapeForm" class="payment-form" style="display:none;">
                    <div class="qr-code">
                        <img src="img/yape-qr.png" alt="Código QR de Yape">
                        <p>Escanea este código con la app de Yape para pagar</p>
                    </div>
                    <div class="form-actions">
                        <button type="button" class="btn btn-secondary" id="cancelYape">Cancelar</button>
                        <button type="button" class="btn btn-primary" id="confirmYape">Ya pagué</button>
                    </div>
                </div>
            </div>
        </div>
        
        <!-- Modal de Dirección -->
        <div id="addressModal" class="modal-overlay">
            <div class="modal-content">
                <h3>Dirección de Envío</h3>
                <form id="addressForm" class="address-form" action="VentaControlador" method="POST">
                    <input type="hidden" name="accion" value="guardarDireccion">
                    <input type="hidden" id="metodoPagoSelected" name="metodoPago" value="">
                    
                    <div class="form-group">
                        <label for="direccion">Dirección Principal*</label>
                        <input type="text" id="direccion" name="direccion" required 
                               value="${sessionScope.usuario.direccion}">
                        <div class="error-message" id="direccionError">Ingrese su dirección principal</div>
                    </div>
                    
                    <div class="form-group">
                        <label for="direccion2">Dirección Secundaria (Opcional)</label>
                        <input type="text" id="direccion2" name="direccion2">
                    </div>
                    
                    <div style="display: flex; gap: 15px;">
                        <div class="form-group" style="flex: 1;">
                            <label for="distrito">Distrito*</label>
                            <select id="distrito" name="distrito" required>
                                <option value="">Seleccione un distrito</option>
                                <option value="Chiclayo">Chiclayo</option>
                                <option value="Lambayeque">Lambayeque</option>
                                <option value="Ferreñafe">Ferreñafe</option>
                                <option value="Monsefú">Monsefú</option>
                                <option value="Santa Rosa">Santa Rosa</option>
                                <option value="Pimentel">Pimentel</option>
                                <option value="Eten">Eten</option>
                                <option value="José Leonardo Ortiz">José Leonardo Ortiz</option>
                                <option value="La Victoria">La Victoria</option>
                                <option value="Picsi">Picsi</option>
                                <option value="Pomalca">Pomalca</option>
                                <option value="Reque">Reque</option>
                                <option value="San José">San José</option>
                                <option value="Túcume">Túcume</option>
                            </select>
                            <div class="error-message" id="distritoError">Seleccione un distrito</div>
                        </div>
                        <div class="form-group" style="flex: 1;">
                            <label for="ciudad">Ciudad*</label>
                            <select id="ciudad" name="ciudad" required>
                                <option value="">Seleccione una ciudad</option>
                                <option value="Chiclayo">Chiclayo</option>
                                <option value="Lambayeque">Lambayeque</option>
                                <option value="Ferreñafe">Ferreñafe</option>
                            </select>
                            <div class="error-message" id="ciudadError">Seleccione una ciudad</div>
                        </div>
                    </div>
                    
                    <div class="form-group">
                        <label for="referencia">Referencia*</label>
                        <textarea id="referencia" name="referencia" rows="3" required></textarea>
                        <small>Ejemplo: Casa verde portón azul, a dos cuadras del parque</small>
                        <div class="error-message" id="referenciaError">Ingrese una referencia para la entrega</div>
                    </div>
                    
                    <div class="form-group">
                        <label for="tiempoEntrega">Tiempo estimado de entrega:</label>
                        <select id="tiempoEntrega" name="tiempoEntrega" class="form-control" disabled>
                            <option>3-5 días hábiles</option>
                        </select>
                    </div>
                    
                    <div class="form-actions">
                        <button type="button" class="btn btn-secondary" id="cancelAddress">Cancelar</button>
                        <button type="submit" class="btn btn-primary">Finalizar Compra</button>
                    </div>
                </form>
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
        <script src="js/carrito.js"></script>
       
    </body>
</html>