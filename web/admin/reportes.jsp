<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html lang="es">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Reportes de Ventas - SERCOYT</title>
        <link rel="icon" type="image/png" href="${pageContext.request.contextPath}/img/logo.png">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/bootstrap.min.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/dashboard.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/reportes.css">
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
                        <h4>Reportes de Ventas</h4>
                    </div>
                    <div class="topbar-right">
                        <div class="user-dropdown">
                            <button class="user-btn">
                                <i class="fas fa-user-circle"></i>
                                <span>${sessionScope.usuario.nombre} ${sessionScope.usuario.apellido}</span>
                                <i class="fas fa-caret-down"></i>
                            </button>
                            <div class="dropdown-content">
                                <a href="${pageContext.request.contextPath}/index.jsp">
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
                    <!-- Mostrar alertas -->
                    <c:if test="${not empty exito}">
                        <div class="alert alert-success alert-dismissible fade show" role="alert">
                            ${exito}
                            <button type="button" class="close" data-dismiss="alert" aria-label="Close">
                                <span aria-hidden="true">&times;</span>
                            </button>
                        </div>
                    </c:if>
                    <c:if test="${not empty error}">
                        <div class="alert alert-danger alert-dismissible fade show" role="alert">
                            ${error}
                            <button type="button" class="close" data-dismiss="alert" aria-label="Close">
                                <span aria-hidden="true">&times;</span>
                            </button>
                        </div>
                    </c:if>

                    <div class="section-header">
                        <h4>Reportes de Ventas</h4>
                        <div class="header-actions">
                            <div class="btn-group" role="group">
                                <a href="${pageContext.request.contextPath}/ReporteControlador?accion=listarOnline" 
                                   class="btn ${filtroActivo eq 'online' ? 'btn-primary' : 'btn-outline-primary'}">
                                    <i class="fas fa-globe"></i> Ventas Online
                                </a>
                                <a href="${pageContext.request.contextPath}/ReporteControlador?accion=listarPresencial" 
                                   class="btn ${filtroActivo eq 'presencial' ? 'btn-primary' : 'btn-outline-primary'}">
                                    <i class="fas fa-store"></i> Ventas Presenciales
                                </a>
                                <a href="${pageContext.request.contextPath}/ReporteControlador" 
                                   class="btn ${filtroActivo eq 'todas' ? 'btn-primary' : 'btn-outline-primary'}">
                                    <i class="fas fa-list"></i> Todas las Ventas
                                </a>
                            </div>
                        </div>
                    </div>

                    <div class="filter-card">
                        <div class="card-header">
                            <h5>Filtrar Ventas</h5>
                        </div>
                        <div class="card-body">
                            <form id="filtroForm" class="filter-form">
                                <div class="row">
                                    <div class="col-md-3">
                                        <div class="form-group">
                                            <label for="filtroId">ID Venta</label>
                                            <input type="text" class="form-control" id="filtroId" name="id" 
                                                   placeholder="Buscar por ID...">
                                        </div>
                                    </div>
                                    <div class="col-md-3">
                                        <div class="form-group">
                                            <label for="filtroCliente">Cliente</label>
                                            <input type="text" class="form-control" id="filtroCliente" name="cliente" 
                                                   placeholder="Buscar por cliente...">
                                        </div>
                                    </div>
                                    <div class="col-md-3">
                                        <div class="form-group">
                                            <label for="filtroEstado">Estado</label>
                                            <select class="form-control" id="filtroEstado" name="estado">
                                                <option value="">Todos los estados</option>
                                                <option value="1">En espera</option>
                                                <option value="2">En reparto</option>
                                                <option value="3">Entregado</option>
                                                <option value="4">Cancelado</option>
                                            </select>
                                        </div>
                                    </div>
                                    <div class="col-md-3">
                                        <div class="form-group">
                                            <label for="filtroFecha">Fecha</label>
                                            <input type="date" class="form-control" id="filtroFecha" name="fecha">
                                        </div>
                                    </div>
                                </div>
                            </form>
                            <div class="filter-actions">
                                <button type="button" class="btn btn-secondary" id="btnResetFiltros">
                                    <i class="fas fa-eraser"></i> Limpiar Filtros
                                </button>
                                <button type="submit" form="filtroForm" class="btn btn-primary">
                                    <i class="fas fa-filter"></i> Aplicar Filtros
                                </button>
                            </div>
                        </div>
                    </div>



                    <div class="section-content">
                        <div class="table-container">
                            <div class="table-header">
                                <h5>Lista de Ventas</h5>
                                <div class="table-stats">
                                    <span>Total: <strong>${fn:length(ventas)}</strong> ventas</span>
                                </div>
                            </div>
                            <table class="products-table">
                                <thead>
                                    <tr>
                                        <th>ID</th>
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
                                            <td><strong>#${venta.idVenta}</strong></td>
                                            <td><fmt:formatDate value="${venta.fecha}" pattern="dd/MM/yyyy HH:mm"/></td>
                                            <td>${venta.clienteNombre}</td>
                                            <td>${venta.clienteDni}</td>
                                            <td>${venta.tipoVentaNombre}</td>
                                            <td>
                                                <span class="status-badge status-${fn:toLowerCase(fn:replace(venta.estadoNombre, ' ', '-'))}">
                                                    ${venta.estadoNombre}
                                                </span>
                                            </td>
                                            <td>${venta.metodoPagoNombre}</td>
                                            <td class="text-success font-weight-bold">S/<fmt:formatNumber value="${venta.total}" maxFractionDigits="2" minFractionDigits="2"/></td>
                                            <td>
    <div class="action-buttons">
        <!-- Botón Descargar Boleta -->
        <a href="${pageContext.request.contextPath}/VentaControlador?accion=generarBoleta&id=${venta.idVenta}" 
           class="btn-action download" 
           title="Descargar Boleta PDF" 
           target="_blank"
           data-toggle="tooltip">
            <i class="fas fa-file-pdf"></i>
        </a>
        
        <!-- Botón Ver Detalles -->
        <button class="btn-action view" 
                data-id="${venta.idVenta}"
                title="Ver detalles completos"
                data-toggle="tooltip">
            <i class="fas fa-eye"></i>
        </button>
        
        <!-- Botón Cambiar Estado (solo si no está entregado o cancelado) -->
        <c:if test="${venta.idEstado != 3 && venta.idEstado != 4}">
            <button class="btn-action change-status" 
                    data-id="${venta.idVenta}" 
                    data-current="${venta.idEstado}"
                    title="Cambiar estado de envío"
                    data-toggle="tooltip">
                <i class="fas fa-truck"></i>
            </button>
        </c:if>
    </div>
</td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Modal Cambiar Estado -->
        <div class="modal fade" id="cambiarEstadoModal" tabindex="-1" role="dialog" aria-hidden="true">
            <div class="modal-dialog" role="document">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title">
                            <i class="fas fa-truck"></i> Cambiar Estado de Envío
                        </h5>
                    </div>
                    <form id="cambiarEstadoForm">
                        <input type="hidden" id="idVenta" name="idVenta">
                        <div class="modal-body">
                            <div class="form-group">
                                <label for="nuevoEstado">Nuevo Estado *</label>
                                <select class="form-control" id="nuevoEstado" name="nuevoEstado" required>
                                    <option value="1">En espera</option>
                                    <option value="2">En reparto</option>
                                    <option value="3">Entregado</option>
                                    <option value="4">Cancelado</option>
                                </select>
                            </div>
                            <div class="alert alert-warning mt-3">
                                <i class="fas fa-exclamation-triangle"></i> 
                                <span id="warningMessage">Cambiar el estado a "Entregado" o "Cancelado" es irreversible.</span>
                            </div>
                        </div>
                        <div class="modal-footer">
                            <button type="button" class="btn btn-secondary" data-dismiss="modal">Cancelar</button>
                            <button type="submit" class="btn btn-primary">
                                <i class="fas fa-save"></i> Guardar Cambios
                            </button>
                        </div>
                    </form>
                </div>
            </div>
        </div>

        <!-- Modal Detalles Venta -->
        <div class="modal fade" id="detallesVentaModal" tabindex="-1" role="dialog" aria-hidden="true">
            <div class="modal-dialog modal-lg" role="document">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title">
                            <i class="fas fa-file-invoice"></i> Detalles de Venta #<span id="detalleIdVenta"></span>
                        </h5>
                    </div>
                    <div class="modal-body">
                        <div class="row">
                            <div class="col-md-6">
                                <h6><i class="fas fa-info-circle"></i> Información de la Venta</h6>
                                <div id="infoVenta"></div>
                            </div>
                            <div class="col-md-6">
                                <h6><i class="fas fa-truck"></i> Dirección de Entrega</h6>
                                <div id="infoDireccion"></div>
                            </div>
                        </div>

                        <hr>

                        <h6><i class="fas fa-boxes"></i> Productos</h6>
                        <table class="table table-bordered table-sm">
                            <thead class="thead-light">
                                <tr>
                                    <th>Producto</th>
                                    <th>Precio Unitario</th>
                                    <th>Cantidad</th>
                                    <th>Subtotal</th>
                                </tr>
                            </thead>
                            <tbody id="tablaProductos">
                            </tbody>
                            <tfoot>
                                <tr>
                                    <th colspan="3" class="text-right">Subtotal:</th>
                                    <th id="subtotalDetalle"></th>
                                </tr>
                                <tr>
                                    <th colspan="3" class="text-right">IGV (18%):</th>
                                    <th id="igvDetalle"></th>
                                </tr>
                                <tr class="table-active">
                                    <th colspan="3" class="text-right">Total:</th>
                                    <th id="totalDetalle"></th>
                                </tr>
                            </tfoot>
                        </table>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-dismiss="modal">Cerrar</button>
                    </div>
                </div>
            </div>
        </div>

        <script src="${pageContext.request.contextPath}/js/jquery-3.7.1.min.js"></script>
        <script src="${pageContext.request.contextPath}/js/bootstrap.min.js"></script>
        <script src="${pageContext.request.contextPath}/js/dashboard.js"></script>
        <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
        <script>
            // Contexto de la aplicación para JS
            const AppContext = {
                path: '${pageContext.request.contextPath}',
                messages: {
                    requiredField: 'Este campo es obligatorio',
                    estadoChanged: 'Estado de venta actualizado correctamente',
                    estadoError: 'Error al cambiar el estado de la venta'
                },
                endpoints: {
                    reporte: {
                    cambiarEstado: '${pageContext.request.contextPath}/ReporteControlador?accion=cambiarEstado',
                    obtenerDetalles: '${pageContext.request.contextPath}/ReporteControlador?accion=obtenerDetalles&idVenta=' }
                }
            };
        </script>
        <script src="${pageContext.request.contextPath}/js/reportes.js"></script>
    </body>
</html>