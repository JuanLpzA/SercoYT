<%-- 
    Document   : cajas
    Created on : 21 jul. 2025, 13:52:53
    Author     : Arrunategui
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="es">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Cajas - SERCOYT</title>
        <link rel="icon" type="image/png" href="${pageContext.request.contextPath}/img/logo.png">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/bootstrap.min.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/dashboard.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/cajas.css?v1">
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
                        <h4>Cajas</h4>
                    </div>
                    <div class="topbar-right">
                        <div class="user-dropdown">
                            <button class="user-btn">
                                <i class="fas fa-user-circle"></i>
                                <span>${sessionScope.usuario.nombre} ${sessionScope.usuario.apellido}</span>
                                <i class="fas fa-caret-down"></i>
                            </button>
                            <div class="dropdown-content">
                                <a href="${pageContext.request.contextPath}/Controlador">
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
                    <div class="section-header">
                        <h4>Gestión de Cajas</h4>
                    </div>

                    <div class="section-content">
                        <div class="filter-card">
                            <div class="card-header">
                                <h5>Filtrar Cajas</h5>
                            </div>
                            <div class="card-body">
                                <form id="filtroForm" method="GET" action="${pageContext.request.contextPath}/CajaControlador" class="filter-form">
                                    <input type="hidden" name="accion" value="filtrar">
                                    <div class="filter-row">
                                        <div class="filter-group">
                                            <label for="filtroNombre">Usuario</label>
                                            <input type="text" class="form-control" id="filtroNombre" name="nombreUsuario" 
                                                   value="${filtroNombre != null ? filtroNombre : ''}"
                                                   placeholder="Buscar por usuario...">
                                        </div>
                                        <div class="filter-group">
                                            <label for="filtroEstado">Estado</label>
                                            <select class="form-control" id="filtroEstado" name="estado">
                                                <option value="">Todos los estados</option>
                                                <option value="abierta" ${filtroEstado eq 'abierta' ? 'selected' : ''}>Abierta</option>
                                                <option value="cerrada" ${filtroEstado eq 'cerrada' ? 'selected' : ''}>Cerrada</option>
                                            </select>
                                        </div>
                                    </div>
                                    <div class="filter-row">
                                        <div class="filter-group">
                                            <label for="filtroFechaInicio">Fecha Inicio</label>
                                            <input type="date" class="form-control" id="filtroFechaInicio" name="fechaInicio"
                                                   value="${filtroFechaInicio != null ? filtroFechaInicio : ''}">
                                        </div>
                                        <div class="filter-group">
                                            <label for="filtroFechaFin">Fecha Fin</label>
                                            <input type="date" class="form-control" id="filtroFechaFin" name="fechaFin"
                                                   value="${filtroFechaFin != null ? filtroFechaFin : ''}">
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
                                    <button type="button" class="btn-filter info" id="btnResumen">
                                        <i class="fas fa-chart-pie"></i> Ver Resumen
                                    </button>
                                </div>
                            </div>
                        </div>

                        <div class="table-container">
                            <div class="table-header">
                                <h5>Lista de Cajas</h5>
                                <div class="table-stats">
                                    <span>Total: <strong>${cajas != null ? cajas.size() : 0}</strong> cajas</span>
                                </div>
                            </div>
                            <div class="table-responsive">
                                <table class="products-table">
                                    <thead>
                                        <tr>
                                            <th>ID</th>
                                            <th>Usuario</th>
                                            <th>Fecha Apertura</th>
                                            <th>Fecha Cierre</th>
                                            <th>Monto Inicial</th>
                                            <th>Monto Final</th>
                                            <th>Monto Recaudado</th>
                                            <th>Diferencia</th>
                                            <th>Estado</th>
                                          <!--  <th>Acciones</th>  -->
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:choose>
                                            <c:when test="${cajas != null && !cajas.isEmpty()}">
                                                <c:forEach var="caja" items="${cajas}">
                                                    <tr>
                                                        <td><strong>#${caja.idCaja}</strong></td>
                                                        <td>${caja.nombreUsuario}</td>
                                                        <td><fmt:formatDate value="${caja.fechaApertura}" pattern="dd/MM/yyyy HH:mm" /></td>
                                                        <td>
                                                            <c:choose>
                                                                <c:when test="${caja.fechaCierre != null}">
                                                                    <fmt:formatDate value="${caja.fechaCierre}" pattern="dd/MM/yyyy HH:mm" />
                                                                </c:when>
                                                                <c:otherwise>
                                                                    <span class="text-muted">No Cerrado</span>
                                                                </c:otherwise>
                                                            </c:choose>
                                                        </td>
                                                        <td>S/ <fmt:formatNumber value="${caja.montoInicial}" pattern="#,##0.00" /></td>
                                                        <td>
                                                            <c:choose>
                                                                <c:when test="${caja.montoFinal != 0}">
                                                                    S/ <fmt:formatNumber value="${caja.montoFinal}" pattern="#,##0.00" />
                                                                </c:when>
                                                                <c:otherwise>
                                                                    <span class="text-muted">S/D</span>
                                                                </c:otherwise>
                                                            </c:choose>
                                                        </td>
                                                        <td>
                                                            <c:choose>
                                                                <c:when test="${caja.montoRecaudado != 0}">
                                                                    S/ <fmt:formatNumber value="${caja.montoRecaudado}" pattern="#,##0.00" />
                                                                </c:when>
                                                                <c:otherwise>
                                                                    <span class="text-muted">S/D</span>
                                                                </c:otherwise>
                                                            </c:choose>
                                                        </td>
                                                        <td>
                                                            <c:if test="${caja.estado eq 'cerrada'}">
                                                                <c:set var="diferencia" value="${caja.montoFinal - caja.montoRecaudado}" />
                                                                <span class="diferencia ${diferencia > 0 ? 'negativo' : 'positivo'}">
                                                                    S/ <fmt:formatNumber value="${diferencia}" pattern="#,##0.00" />
                                                                </span>
                                                            </c:if>
                                                            <c:if test="${caja.estado eq 'abierta'}">
                                                                <span class="text-muted">S/D</span>
                                                            </c:if>
                                                        </td>
                                                        <td>
                                                            <span class="status-badge ${caja.estado eq 'abierta' ? 'active' : 'inactive'}">
                                                                ${caja.estado eq 'abierta' ? 'Abierta' : 'Cerrada'}
                                                            </span>
                                                        </td>
                                                     <!--   <td>
                                                            <div class="action-buttons">
                                                                <button class="btn-action details btn-detalles" 
                                                                        data-id="${caja.idCaja}" title="Ver Detalles">
                                                                    <i class="fas fa-eye"></i>
                                                                </button>
                                                            </div>
                                                        </td> -->
                                                    </tr>
                                                </c:forEach>
                                            </c:when>
                                            <c:otherwise>
                                                <tr>
                                                    <td colspan="10" class="text-center text-muted">
                                                        <i class="fas fa-inbox fa-2x mb-3"></i>
                                                        <br>No se encontraron cajas con los filtros aplicados
                                                    </td>
                                                </tr>
                                            </c:otherwise>
                                        </c:choose>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Modal Resumen -->
        <div class="modal fade" id="resumenModal" tabindex="-1" role="dialog" aria-labelledby="resumenModalLabel" aria-hidden="true">
            <div class="modal-dialog modal-lg" role="document">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title" id="resumenModalLabel">
                            <i class="fas fa-chart-pie"></i> Resumen de Cajas
                        </h5>
                       
                    </div>
                    <div class="modal-body">
                        <form id="resumenForm">
                            <div class="form-row">
                                <div class="form-group col-md-6">
                                    <label for="resumenFechaInicio">Fecha Inicio <span class="text-danger">*</span></label>
                                    <input type="date" class="form-control" id="resumenFechaInicio" name="fechaInicio" required>
                                </div>
                                <div class="form-group col-md-6">
                                    <label for="resumenFechaFin">Fecha Fin <span class="text-danger">*</span></label>
                                    <input type="date" class="form-control" id="resumenFechaFin" name="fechaFin" required>
                                </div>
                            </div>
                            <div class="form-group">
                                <label for="resumenUsuario">Usuario (Opcional)</label>
                                <select class="form-control" id="resumenUsuario" name="idUsuario">
                                    <option value="">Todos los usuarios</option>
                                    <!-- Los usuarios se cargarán dinámicamente -->
                                </select>
                            </div>
                        </form>
                        <div class="resumen-resultados mt-4" id="resumenResultados" style="display: none;">
                            <h6>Resultados del Resumen:</h6>
                            <div class="row">
                                <div class="col-md-6 col-lg-4 mb-3">
                                    <div class="resumen-card">
                                        <div class="resumen-icon bg-primary">
                                            <i class="fas fa-cash-register"></i>
                                        </div>
                                        <div class="resumen-info">
                                            <h6>Total Cajas</h6>
                                            <p id="resumenTotalCajas" class="mb-0">0</p>
                                        </div>
                                    </div>
                                </div>
                                <div class="col-md-6 col-lg-4 mb-3">
                                    <div class="resumen-card">
                                        <div class="resumen-icon bg-success">
                                            <i class="fas fa-coins"></i>
                                        </div>
                                        <div class="resumen-info">
                                            <h6>Monto Inicial Total</h6>
                                            <p id="resumenTotalInicial" class="mb-0">S/ 0.00</p>
                                        </div>
                                    </div>
                                </div>
                                <div class="col-md-6 col-lg-4 mb-3">
                                    <div class="resumen-card">
                                        <div class="resumen-icon bg-info">
                                            <i class="fas fa-money-bill-wave"></i>
                                        </div>
                                        <div class="resumen-info">
                                            <h6>Monto Final Total</h6>
                                            <p id="resumenTotalFinal" class="mb-0">S/ 0.00</p>
                                        </div>
                                    </div>
                                </div>
                                <div class="col-md-6 col-lg-4 mb-3">
                                    <div class="resumen-card">
                                        <div class="resumen-icon bg-warning">
                                            <i class="fas fa-hand-holding-usd"></i>
                                        </div>
                                        <div class="resumen-info">
                                            <h6>Monto Recaudado</h6>
                                            <p id="resumenTotalRecaudado" class="mb-0">S/ 0.00</p>
                                        </div>
                                    </div>
                                </div>
                                <div class="col-md-6 col-lg-4 mb-3">
                                    <div class="resumen-card">
                                        <div class="resumen-icon bg-danger">
                                            <i class="fas fa-exclamation-triangle"></i>
                                        </div>
                                        <div class="resumen-info">
                                            <h6>Diferencia Total</h6>
                                            <p id="resumenDiferencia" class="mb-0">S/ 0.00</p>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div id="resumenLoading" style="display: none;" class="text-center py-4">
                            <div class="spinner-border text-primary" role="status">
                                <span class="sr-only">Cargando...</span>
                            </div>
                            <p class="mt-2">Generando resumen...</p>
                        </div>
                    </div>
                    <div class="modal-footer">
                        
                        <button type="button" class="btn btn-primary" id="btnGenerarResumen">
                            <i class="fas fa-chart-line"></i> Generar Resumen
                        </button>
                    </div>
                </div>
            </div>
        </div>

        <!-- Modal Detalles -->
        <div class="modal fade" id="detallesModal" tabindex="-1" role="dialog" aria-labelledby="detallesModalLabel" aria-hidden="true">
            <div class="modal-dialog modal-xl" role="document">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title" id="detallesModalLabel">
                            <i class="fas fa-info-circle"></i> Detalles de Caja
                        </h5>
                      
                    </div>
                    <div class="modal-body" id="detallesCajaBody">
                        <div class="text-center py-4">
                            <div class="spinner-border text-primary" role="status">
                                <span class="sr-only">Cargando...</span>
                            </div>
                            <p class="mt-2">Cargando detalles...</p>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-dismiss="modal">Cerrar</button>
                    </div>
                </div>
            </div>
        </div>

        <!-- Scripts -->
        <script src="${pageContext.request.contextPath}/js/jquery-3.7.1.min.js"></script>
        <script src="${pageContext.request.contextPath}/js/bootstrap.min.js"></script>
        <script src="${pageContext.request.contextPath}/js/dashboard.js"></script>
        <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
        
        <script>
            // Contexto de la aplicación para JS
            const AppContext = {
                path: '${pageContext.request.contextPath}',
                endpoints: {
                    caja: {
                        list: '${pageContext.request.contextPath}/CajaControlador?accion=listar',
                        filter: '${pageContext.request.contextPath}/CajaControlador?accion=filtrar',
                        resumen: '${pageContext.request.contextPath}/CajaControlador?accion=resumen',
                        detalles: '${pageContext.request.contextPath}/CajaControlador?accion=detalles&id='
                    },
                    usuario: {
                        list: '${pageContext.request.contextPath}/UsuarioControlador?accion=listarActivosCajasActivas'
                    }
                }
            };
        </script>
        <script src="${pageContext.request.contextPath}/js/cajas.js"></script>
    </body>
</html>