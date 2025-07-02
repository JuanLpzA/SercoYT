<%-- 
    Document   : entregas
    Created on : 25 jun. 2025, 15:43:06
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
        <title>Entregas - SERCOYT</title>
        <link rel="icon" type="image/png" href="${pageContext.request.contextPath}/img/logo.png">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/bootstrap.min.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/dashboard.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/entregas.css">
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
                        <h4>Gestión de Entregas</h4>
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
                        <h4>Lista de Entregas Pendientes</h4>
                        <div class="header-actions">
                            <button class="btn btn-secondary" id="btnMostrarTodas">
                                <i class="fas fa-list"></i> Mostrar Todas
                            </button>
                        </div>
                    </div>

                    <div class="section-content">
                        <div class="filter-card">
                            <div class="card-header">
                                <h5>Filtrar Entregas</h5>
                            </div>
                            <div class="card-body">
                                <form id="filtroForm" class="filter-form">
                                    <div class="row">
                                        <div class="col-md-4">
                                            <div class="filter-group">
                                                <label for="filtroCliente">Cliente</label>
                                                <input type="text" class="form-control" id="filtroCliente" name="cliente" 
                                                       value="${filtroCliente != null ? filtroCliente : ''}"
                                                       placeholder="Buscar por cliente...">
                                            </div>
                                        </div>
                                        <div class="col-md-4">
                                            <div class="filter-group">
                                                <label for="filtroEstado">Estado</label>
                                                <select class="form-control" id="filtroEstado" name="estado">
                                                    <option value="">Todos los estados</option>
                                                    <c:forEach var="estado" items="${estadosDespacho}">
                                                        <option value="${estado.idEstado}" ${filtroEstado eq estado.idEstado ? 'selected' : ''}>
                                                            ${estado.descripcion}
                                                        </option>
                                                    </c:forEach>
                                                </select>
                                            </div>
                                        </div>
                                        <div class="col-md-4">
                                            <div class="filter-group">
                                                <label for="filtroFecha">Fecha</label>
                                                <input type="date" class="form-control" id="filtroFecha" name="fecha" 
                                                       value="${filtroFecha != null ? filtroFecha : ''}">
                                            </div>
                                        </div>
                                    </div>
                                </form>
                                <div class="filter-actions">
                                    <button type="button" class="btn-filter secondary" id="btnResetFiltros">
                                        <i class="fas fa-eraser"></i> Limpiar
                                    </button>
                                    <button type="submit" form="filtroForm" class="btn-filter primary">
                                        <i class="fas fa-filter"></i> Filtrar
                                    </button>
                                </div>
                            </div>
                        </div>

                        <div class="table-container">
                            <div class="table-header">
                                <h5>Lista de Entregas</h5>
                                <div class="table-stats">
                                    <span>Total: <strong>${fn:length(entregas)}</strong> entregas</span>
                                </div>
                            </div>
                            <table class="deliveries-table">
                                <thead>
                                    <tr>
                                        <th>ID Venta</th>
                                        <th>Cliente</th>
                                        <th>Fecha</th>
                                        <th>Total</th>
                                        <th>Estado</th>
                                        <th>Dirección</th>
                                        <th>Acciones</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="entrega" items="${entregas}">
                                        <tr>
                                            <td><strong>#${entrega.venta.idVenta}</strong></td>
                                            <td>
                                                ${entrega.venta.clienteNombre}
                                                <c:if test="${not empty entrega.venta.clienteDni}">
                                                    <br><small>DNI: ${entrega.venta.clienteDni}</small>
                                                </c:if>
                                            </td>
                                            <td>
                                                <fmt:formatDate value="${entrega.venta.fecha}" pattern="dd/MM/yyyy HH:mm"/>
                                            </td>
                                            <td>
                                                S/ <fmt:formatNumber value="${entrega.venta.total}" maxFractionDigits="2"/>
                                            </td>
                                            <td>
                                                <span class="status-badge ${entrega.venta.estadoNombre.toLowerCase().replace(' ', '-')}">
                                                    ${entrega.venta.estadoNombre}
                                                </span>
                                            </td>
                                            <td>
                                                <button class="btn-address" data-toggle="modal" data-target="#direccionModal" 
                                                        data-direccion="${entrega.direccion}, ${entrega.provincia}" 
                                                        data-receptor="${entrega.nombreReceptor}" 
                                                        data-telefono="${entrega.telefono}" 
                                                        data-referencia="${entrega.referencia}" 
                                                        data-codigopostal="${entrega.codigoPostal}">
                                                    <i class="fas fa-map-marker-alt"></i> Ver dirección
                                                </button>
                                            </td>
                                            <td>
                                                <div class="action-buttons">
                                                    <div class="dropdown">
                                                        <button class="btn-action dropdown-toggle" data-toggle="dropdown" 
                                                                aria-haspopup="true" aria-expanded="false">
                                                            <i class="fas fa-cog"></i>
                                                        </button>
                                                        <div class="dropdown-menu dropdown-menu-right">
                                                            <c:forEach var="estado" items="${estadosDespacho}">
                                                                <c:if test="${entrega.venta.idEstado != estado.idEstado}">
                                                                    <a class="dropdown-item cambiar-estado" 
                                                                       href="#" 
                                                                       data-idventa="${entrega.venta.idVenta}" 
                                                                       data-idestado="${estado.idEstado}">
                                                                        <i class="fas fa-exchange-alt"></i> Cambiar a ${estado.descripcion}
                                                                    </a>
                                                                </c:if>
                                                            </c:forEach>
                                                            <div class="dropdown-divider"></div>
                                                            <a class="dropdown-item descargar-pdf" 
                                                               href="${pageContext.request.contextPath}/VentaControlador?accion=generarPdf&id=${entrega.venta.idVenta}" 
                                                               target="_blank">
                                                                <i class="fas fa-file-pdf"></i> Descargar Boleta
                                                            </a>
                                                        </div>
                                                    </div>
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

        <!-- Modal Dirección -->
        <div class="modal fade" id="direccionModal" tabindex="-1" role="dialog" aria-hidden="true">
            <div class="modal-dialog" role="document">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title">
                            <i class="fas fa-map-marked-alt"></i> Dirección de Entrega
                        </h5>
                    </div>
                    <div class="modal-body">
                        <div class="address-details">
                            <div class="detail-row">
                                <span class="detail-label">Receptor:</span>
                                <span class="detail-value" id="modalReceptor"></span>
                            </div>
                            <div class="detail-row">
                                <span class="detail-label">Teléfono:</span>
                                <span class="detail-value" id="modalTelefono"></span>
                            </div>
                            <div class="detail-row">
                                <span class="detail-label">Dirección:</span>
                                <span class="detail-value" id="modalDireccion"></span>
                            </div>
                            <div class="detail-row">
                                <span class="detail-label">Referencia:</span>
                                <span class="detail-value" id="modalReferencia"></span>
                            </div>
                            <div class="detail-row">
                                <span class="detail-label">Código Postal:</span>
                                <span class="detail-value" id="modalCodigoPostal"></span>
                            </div>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-dismiss="modal">
                            <i class="fas fa-times"></i> Cerrar
                        </button>
                    </div>
                </div>
            </div>
        </div>

        <!-- Modal Confirmación -->
        <div class="modal fade" id="confirmModal" tabindex="-1" role="dialog" aria-hidden="true">
            <div class="modal-dialog" role="document">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title" id="confirmModalTitle">Confirmar Cambio de Estado</h5>
                    </div>
                    <div class="modal-body" id="confirmModalBody">
                        ¿Está seguro que desea cambiar el estado de esta entrega?
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-dismiss="modal">Cancelar</button>
                        <a href="#" class="btn btn-primary" id="btn-confirmar">Confirmar</a>
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
                    estadoChanged: 'Estado de entrega actualizado correctamente',
                    estadoError: 'Error al actualizar el estado de entrega'
                },
                endpoints: {
                    entrega: {
                        list: '${pageContext.request.contextPath}/EntregaControlador?accion=listar',
                        listAll: '${pageContext.request.contextPath}/EntregaControlador?accion=listarTodas',
                        filter: '${pageContext.request.contextPath}/EntregaControlador?accion=filtrar',
                        changeEstado: '${pageContext.request.contextPath}/EntregaControlador?accion=cambiarEstado'
                    }
                }
            };
        </script>
        <script src="${pageContext.request.contextPath}/js/entregas.js"></script>
    </body>
</html>