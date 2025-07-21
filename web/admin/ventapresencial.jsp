<%-- 
    Document   : ventapresencial
    Created on : 3 jul. 2025, 16:32:51
    Author     : Arrunategui
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html lang="es">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Venta Presencial - SERCOYT</title>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/bootstrap.min.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/dashboard.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/ventapresencial.css?v2">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/clientes.css">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    </head>
    <body>
        <div class="dashboard-container">
            <%@include file="/WEB-INF/views/includes/menuDashboard.jsp" %>

            <div class="dashboard-content">
                <div class="dashboard-topbar">
                    <div class="topbar-left">
                        <button class="sidebar-toggle">
                            <i class="fas fa-bars"></i>
                        </button>
                        <h4>Venta Presencial</h4>
                    </div>
                    <div class="topbar-right">
                        <div class="user-dropdown">
                            <button class="user-btn">
                                <i class="fas fa-user-circle"></i>
                                <span>${sessionScope.usuario.nombre} ${sessionScope.usuario.apellido}</span>
                                <i class="fas fa-caret-down"></i>
                            </button>
                            <div class="dropdown-content">
                                <a href="${pageContext.request.contextPath}/Controlador?accion=laptops">
                                    <i class="fas fa-store"></i> Ir a la tienda
                                </a>
                                <a href="${pageContext.request.contextPath}/UsuarioControlador?accion=logout">
                                    <i class="fas fa-sign-out-alt"></i> Cerrar sesión
                                </a>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="dashboard-main">
                    <div class="venta-presencial-container">
                        <!-- Sección de cliente -->
                        <div class="cliente-section">
                            <h5><i class="fas fa-user"></i> Datos del Cliente</h5>
                            <div class="form-group">
                                <label>Tipo de Documento</label>
                                <select id="tipoDocumento" class="form-control">
                                    <option value="1">DNI</option>
                                    <option value="2">RUC</option>
                                    <option value="3">Carnet Extranjería</option>
                                </select>
                            </div>
                            <div class="form-group">
                                <label>Número de Documento</label>
                                <div class="input-group">
                                    <input type="text" id="documento" class="form-control" maxlength="8" placeholder="Ingrese documento">
                                    <div class="input-group-append">
                                        <button class="btn btn-primary" id="btnBuscarCliente">
                                            <i class="fas fa-search"></i> Buscar
                                        </button>
                                    </div>
                                </div>
                            </div>
                            <div class="form-group">
                                <label>Nombre Completo</label>
                                <input type="text" id="nombreCompleto" class="form-control" placeholder="Nombre del cliente" readonly>
                                <input type="hidden" id="idCliente">
                            </div>

                        </div>

                        <!-- Sección de productos -->
                        <div class="productos-section">
                            <h5><i class="fas fa-boxes"></i> Productos</h5>
                            <div class="form-group">
                                <div class="input-group">
                                    <input type="text" id="filtroProducto" class="form-control" placeholder="Buscar producto...">
                                    <div class="input-group-append">
                                        <button class="btn btn-primary" id="btnBuscarProducto">
                                            <i class="fas fa-search"></i> Buscar
                                        </button>
                                    </div>
                                </div>
                            </div>
                            <div class="productos-list" id="productosList">
                                <!-- Productos se cargarán aquí -->
                            </div>
                        </div>

                        <!-- Sección de carrito -->
                        <div class="carrito-section">
                            <h5><i class="fas fa-shopping-cart"></i> Carrito de Venta</h5>
                            <div class="carrito-items" id="carritoItems">
                                <!-- Items del carrito se mostrarán aquí -->
                                <div class="empty-cart">No hay productos en el carrito</div>
                            </div>
                            <div class="carrito-totales">
                                <div class="total-line">
                                    <span>Subtotal:</span>
                                    <span id="subtotal">S/. 0.00</span>
                                </div>
                                <div class="total-line">
                                    <span>IGV (18%):</span>
                                    <span id="igv">S/. 0.00</span>
                                </div>
                                <div class="total-line grand-total">
                                    <span>Total:</span>
                                    <span id="total">S/. 0.00</span>
                                </div>
                            </div>
                            <div class="metodo-pago">
                                <label>Método de Pago</label>
                                <select id="metodoPago" class="form-control">
                                    <option value="1">Efectivo</option>
                                    <option value="2">Tarjeta</option>
                                    <option value="3">Yape</option>
                                </select>
                            </div>
                            <button class="btn btn-success btn-block mt-3" id="btnFinalizarVenta" disabled>
                                <i class="fas fa-check-circle"></i> Finalizar Venta
                            </button>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Modal Nuevo Cliente -->
        <div class="modal fade" id="nuevoClienteModal" tabindex="-1" role="dialog" aria-hidden="true">
            <div class="modal-dialog" role="document">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title">
                            <i class="fas fa-user-plus"></i> Nuevo Cliente
                        </h5>
                        
                    </div>
                    <div class="modal-body">
                        <div class="form-group">
                            <label class="required">Tipo de Documento</label>
                            <div class="radio-group">
                                <div class="form-check form-check-inline">
                                    <input class="form-check-input" type="radio" name="tipoDocumentoModal" id="tipoDniModal" value="1" checked>
                                    <label class="form-check-label" for="tipoDniModal">
                                        <i class="fas fa-user"></i> DNI
                                    </label>
                                </div>
                                <div class="form-check form-check-inline">
                                    <input class="form-check-input" type="radio" name="tipoDocumentoModal" id="tipoRucModal" value="2">
                                    <label class="form-check-label" for="tipoRucModal">
                                        <i class="fas fa-building"></i> RUC
                                    </label>
                                </div>
                                <div class="form-check form-check-inline">
                                    <input class="form-check-input" type="radio" name="tipoDocumentoModal" id="tipoCarnetModal" value="3">
                                    <label class="form-check-label" for="tipoCarnetModal">
                                        <i class="fas fa-passport"></i> Carnet Extranjería
                                    </label>
                                </div>
                            </div>
                        </div>
                        <div class="form-group">
                            <label id="labelDocumentoModal">DNI</label>
                            <input type="text" class="form-control" id="documentoModal" required
                                   maxlength="8" pattern="[0-9]{8}" title="Ingrese 8 dígitos numéricos">
                        </div>
                        <div class="form-group">
                            <label id="labelNombreModal">Nombre</label>
                            <input type="text" class="form-control" id="nombreModal" required>
                        </div>
                        <div class="form-group" id="grupoApellidoModal">
                            <label id="labelApellidoModal">Apellido</label>
                            <input type="text" class="form-control" id="apellidoModal" required>
                        </div>
                        <div class="form-group">
                            <label>Teléfono</label>
                            <input type="text" class="form-control" id="telefonoModal"
                                   maxlength="9" pattern="[0-9]{9}" title="Ingrese 9 dígitos numéricos">
                        </div>
                    </div>
                    <div class="modal-footer">
                        
                        <button type="button" class="btn btn-primary" id="btnGuardarClienteModal">
                            <i class="fas fa-save"></i> Guardar Cliente
                        </button>
                    </div>
                </div>
            </div>
        </div>

        <!-- Modal Boleta -->
        <div class="modal fade" id="boletaModal" tabindex="-1" role="dialog" aria-hidden="true">
            <div class="modal-dialog modal-lg" role="document">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title">Boleta de Venta</h5>
                        
                    </div>
                    <div class="modal-body">
                        <iframe id="boletaIframe" style="width:100%; height:500px; border:none;"></iframe>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-dismiss="modal">Cerrar</button>
                        <button type="button" class="btn btn-primary" id="btnImprimirBoleta">
                            <i class="fas fa-print"></i> Imprimir
                        </button>
                    </div>
                </div>
            </div>
        </div>

        <script src="${pageContext.request.contextPath}/js/jquery-3.7.1.min.js"></script>
        <script src="${pageContext.request.contextPath}/js/bootstrap.min.js"></script>
        <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

        <script src="${pageContext.request.contextPath}/js/dashboard.js"></script>
        <script>
            const AppContext = {
                path: '${pageContext.request.contextPath}',
                idCaja: '${sessionScope.idCaja}', 
                endpoints: {
                    ventaPresencial: {
                        buscarCliente: '${pageContext.request.contextPath}/VentaPresencialControlador?accion=buscarCliente',
                        registrarCliente: '${pageContext.request.contextPath}/VentaPresencialControlador?accion=registrarCliente',
                        buscarProducto: '${pageContext.request.contextPath}/VentaPresencialControlador?accion=buscarProducto',
                        finalizarVenta: '${pageContext.request.contextPath}/VentaPresencialControlador?accion=finalizarVenta',
                        generarBoleta: '${pageContext.request.contextPath}/VentaPresencialControlador?accion=generarBoleta',
                        ventaInicio: '${pageContext.request.contextPath}/VentaPresencialControlador?accion=inicio'
                    },
                    cliente: {
                        consultarDni: '${pageContext.request.contextPath}/ClienteControlador?accion=consultarDni&dni=',
                        consultarRuc: '${pageContext.request.contextPath}/ClienteControlador?accion=consultarRuc&ruc='
                    }
                }
            };
        </script>
        <script src="${pageContext.request.contextPath}/js/ventapresencial.js?v=8"></script>
    </body>
</html>