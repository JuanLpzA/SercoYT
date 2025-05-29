<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Proceso de Pago - SERCOYT</title>
        <link href="css/bootstrap.min.css" rel="stylesheet">
        <link href="css/styleonline.css" rel="stylesheet">
    </head>
    <body>
        <%@include file="resources/commons/header.jsp" %>
        
        <div class="container mt-5">
            <div class="row justify-content-center">
                <div class="col-md-8">
                    <div class="card">
                        <div class="card-header bg-primary text-white">
                            <h4 class="mb-0">Proceso de Pago</h4>
                        </div>
                        <div class="card-body">
                            <c:if test="${not empty error}">
                                <div class="alert alert-danger">${error}</div>
                            </c:if>
                            
                            <form action="Controlador" method="POST">
                                <input type="hidden" name="accion" value="procesarPago">
                                
                                <div class="form-group">
                                    <label>Método de Pago:</label>
                                    <div class="form-check">
                                        <input class="form-check-input" type="radio" name="metodoPago" id="tarjeta" value="tarjeta" checked>
                                        <label class="form-check-label" for="tarjeta">
                                            Tarjeta de Crédito/Débito
                                        </label>
                                    </div>
                                    <div class="form-check">
                                        <input class="form-check-input" type="radio" name="metodoPago" id="yape" value="yape">
                                        <label class="form-check-label" for="yape">
                                            Yape
                                        </label>
                                    </div>
                                </div>
                                
                                <div id="tarjetaForm">
                                    <div class="form-group">
                                        <label for="numeroTarjeta">Número de Tarjeta:</label>
                                        <input type="text" class="form-control" id="numeroTarjeta" name="numeroTarjeta" 
                                               placeholder="1234 5678 9012 3456" maxlength="16" required>
                                    </div>
                                    <div class="form-group">
                                        <label for="nombreTitular">Nombre del Titular:</label>
                                        <input type="text" class="form-control" id="nombreTitular" name="nombreTitular" 
                                               placeholder="Como aparece en la tarjeta" required>
                                    </div>
                                    <div class="row">
                                        <div class="col-md-6">
                                            <div class="form-group">
                                                <label for="fechaExpiracion">Fecha de Expiración:</label>
                                                <input type="text" class="form-control" id="fechaExpiracion" name="fechaExpiracion" 
                                                       placeholder="MM/AA" maxlength="5" required>
                                            </div>
                                        </div>
                                        <div class="col-md-6">
                                            <div class="form-group">
                                                <label for="cvv">CVV:</label>
                                                <input type="text" class="form-control" id="cvv" name="cvv" 
                                                       placeholder="123" maxlength="3" required>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                
                                <div id="yapeForm" style="display: none;">
                                    <div class="text-center">
                                        <img src="img/yape_qr.png" alt="Código QR Yape" class="img-fluid mb-3" style="max-width: 200px;">
                                        <p>Escanea el código QR con la app de Yape para realizar el pago</p>
                                        <p>O envía el monto a nuestro número: <strong>999 888 777</strong></p>
                                        <div class="form-group">
                                            <button type="button" class="btn btn-success" id="btnPagoRealizado">
                                                Ya realicé el pago
                                            </button>
                                        </div>
                                    </div>
                                </div>
                                
                                <div class="border-top my-3"></div>
                                
                                <div class="row">
                                    <div class="col-md-6">
                                        <h5>Resumen de Compra</h5>
                                        <table class="table table-sm">
                                            <tr>
                                                <td>Subtotal:</td>
                                                <td class="text-right">S/ ${subtotal}</td>
                                            </tr>
                                            <tr>
                                                <td>IGV (18%):</td>
                                                <td class="text-right">S/ ${igv}</td>
                                            </tr>
                                            <tr class="table-active">
                                                <td><strong>Total:</strong></td>
                                                <td class="text-right"><strong>S/ ${total}</strong></td>
                                            </tr>
                                        </table>
                                    </div>
                                    <div class="col-md-6 text-right">
                                        <a href="Controlador?accion=Carrito" class="btn btn-secondary">Volver al Carrito</a>
                                        <button type="submit" class="btn btn-primary">Continuar con el Pago</button>
                                    </div>
                                </div>
                            </form>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        
        <%@include file="resources/commons/footer.jsp" %>
        
        <script src="js/jquery-3.7.1.min.js"></script>
        <script src="js/bootstrap.min.js"></script>
        <script>
            $(document).ready(function() {
                $('input[name="metodoPago"]').change(function() {
                    if ($(this).val() === 'tarjeta') {
                        $('#tarjetaForm').show();
                        $('#yapeForm').hide();
                    } else {
                        $('#tarjetaForm').hide();
                        $('#yapeForm').show();
                    }
                });
                
                $('#btnPagoRealizado').click(function() {
                    $('form').submit();
                });
                
                // Formatear número de tarjeta
                $('#numeroTarjeta').on('input', function() {
                    this.value = this.value.replace(/[^0-9]/g, '');
                });
                
                // Formatear fecha de expiración
                $('#fechaExpiracion').on('input', function() {
                    this.value = this.value.replace(/[^0-9\/]/g, '');
                    if (this.value.length === 2 && !this.value.includes('/')) {
                        this.value += '/';
                    }
                });
                
                // Formatear CVV
                $('#cvv').on('input', function() {
                    this.value = this.value.replace(/[^0-9]/g, '');
                });
            });
        </script>
    </body>
</html>