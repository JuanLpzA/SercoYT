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
                                    <a href="UsuarioControlador?accion=login&redirect=carrito" class="btn btn-primary">Iniciar Sesión Para Pagar</a>
                                </c:when>
                                <c:otherwise>
                                    <c:choose>
                                        <c:when test="${not empty carrito and carrito.size() > 0}">
                                            <button id="btnGenerarCompra" class="btn btn-success">Continuar con Envío</button>
                                        </c:when>
                                        <c:otherwise>
                                            <button class="btn btn-success" disabled>Continuar con Envío</button>
                                        </c:otherwise>
                                    </c:choose>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Modal de Dirección (actualizado) -->
        <div id="addressModal" class="modal-overlay" style="display:none;">
            <div class="modal-content">
                <span class="close-modal" id="closeAddressModal">&times;</span>
                <h3>Dirección de Envío - Lambayeque</h3>
                <div class="address-form">
                    <div class="form-group">
                        <label for="nombreReceptor">Nombre del receptor*</label>
                        <input type="text" id="nombreReceptor" class="form-control" required>
                        <div class="error-message" id="nombreReceptorError"></div>
                    </div>

                    <div class="form-group">
                        <label for="telefonoContacto">Teléfono de contacto*</label>
                        <input type="tel" id="telefonoContacto" class="form-control" pattern="[0-9]{9}" maxlength="9" required>
                        <small class="text-muted">Ingrese un número de 9 dígitos (ej. 987654321)</small>
                        <div class="error-message" id="telefonoError"></div>
                    </div>

                    <div class="form-group">
                        <label for="provincia">Provincia*</label>
                        <select id="provincia" name="provincia" class="form-control" required>
                            <option value="">Seleccione una provincia</option>
                            <option value="Chiclayo">Chiclayo</option>
                            <option value="Ferreñafe">Ferreñafe</option>
                            <option value="Lambayeque">Lambayeque</option>
                        </select>
                        <div class="error-message" id="provinciaError"></div>
                    </div>

                    <div class="form-group">
                        <label for="autocomplete">Dirección exacta*</label>
                        <input type="text" id="autocomplete" class="form-control" placeholder="Escribe tu dirección">
                        <small class="text-muted">Comienza a escribir y selecciona una opción válida</small>
                        <div class="error-message" id="direccionError"></div>
                    </div>

                    <div class="form-group">
                        <label for="referencia">Referencia adicional (Opcional)</label>
                        <textarea id="referencia" name="referencia" class="form-control" rows="3"></textarea>
                        <small class="text-muted">Ejemplo: Frente al colegio tal o Timbre rojo</small>
                    </div>

                    <div class="form-group">
                        <label for="codigoPostal">Código postal (Opcional)</label>
                        <input type="text" id="codigoPostal" class="form-control" maxlength="5" pattern="[0-9]{5}">
                        <small class="text-muted">Ingrese un código postal válido del departamento de Lambayeque (14000-14099)</small>
                        <div class="error-message" id="codigoPostalError"></div>
                    </div>

                    <div class="form-actions">
                        <button type="button" class="btn btn-secondary" id="cancelAddress">Cancelar</button>
                        <button type="button" class="btn btn-primary" id="confirmAddress">Continuar con Pago</button>
                    </div>
                </div>
            </div>
        </div>                

        <!-- Modal de Pago -->
        <div id="paymentModal" class="modal-overlay" style="display:none;">
            <div class="modal-content">
                <span class="close-modal" id="closePaymentModal">&times;</span>
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
                    
                <div id="yapeForm" class="payment-form" >
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