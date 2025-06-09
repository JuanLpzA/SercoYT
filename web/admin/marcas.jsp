<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html lang="es">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Marcas - SERCOYT</title>
        <link rel="icon" type="image/png" href="${pageContext.request.contextPath}/img/logo.png">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/bootstrap.min.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/dashboard.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/marcas.css">
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
                        <h4>Marcas</h4>
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
                        <h4>Lista de Marcas</h4>
                        <div class="header-actions">
                            <button class="btn btn-primary" id="btnNuevaMarca">
                                <i class="fas fa-plus"></i> Nueva Marca
                            </button>
                        </div>
                    </div>

                    <div class="section-content">
                        <div class="filter-card">
                            <div class="card-header">
                                <h5>Filtrar Marcas</h5>
                            </div>
                            <div class="card-body">
                                <form id="filtroForm" class="filter-form">
                                    <div class="filter-group">
                                        <label for="filtroNombre">Nombre</label>
                                        <input type="text" class="form-control" id="filtroNombre" name="nombre" 
                                               value="${filtroNombre != null ? filtroNombre : ''}"
                                               placeholder="Buscar por nombre...">
                                    </div>
                                    <div class="filter-group">
                                        <label for="filtroEstado">Estado</label>
                                        <select class="form-control" id="filtroEstado" name="estado">
                                            <option value="">Todos los estados</option>
                                            <option value="activo" ${filtroEstado eq 'activo' ? 'selected' : ''}>Activo</option>
                                            <option value="inactivo" ${filtroEstado eq 'inactivo' ? 'selected' : ''}>Inactivo</option>
                                        </select>
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
                                <h5>Lista de Marcas</h5>
                                <div class="table-stats">
                                    <span>Total: <strong>${fn:length(marcas)}</strong> marcas</span>
                                </div>
                            </div>
                            <table class="products-table">
                                <thead>
                                    <tr>
                                        <th>ID</th>
                                        <th>Nombre</th>
                                        <th>Estado</th>
                                        <th>Acciones</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="marca" items="${marcas}">
                                        <tr>
                                            <td><strong>#${marca.id}</strong></td>
                                            <td>${marca.nombre}</td>
                                            <td>
                                                <span class="status-badge ${marca.estado eq 'activo' ? 'active' : 'inactive'}">
                                                    ${marca.estado eq 'activo' ? 'Activo' : 'Inactivo'}
                                                </span>
                                            </td>
                                            <td>
                                                <div class="action-buttons">
                                                    <button class="btn-action edit btn-editar" 
                                                            data-id="${marca.id}" title="Editar">
                                                        <i class="fas fa-edit"></i>
                                                    </button>
                                                    <c:choose>
                                                        <c:when test="${marca.estado eq 'activo'}">
                                                            <button class="btn-action deactivate btn-desactivar" 
                                                                    data-id="${marca.id}" title="Desactivar">
                                                                <i class="fas fa-times"></i>
                                                            </button>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <button class="btn-action activate btn-activar" 
                                                                    data-id="${marca.id}" title="Activar">
                                                                <i class="fas fa-check"></i>
                                                            </button>
                                                        </c:otherwise>
                                                    </c:choose>
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

        <!-- Modal Nueva Marca -->
        <div class="modal fade" id="nuevaMarcaModal" tabindex="-1" role="dialog" aria-hidden="true">
            <div class="modal-dialog" role="document">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title">
                            <i class="fas fa-tag"></i> Nueva Marca
                        </h5>
                    </div>
                    <form id="nuevaMarcaForm" action="${pageContext.request.contextPath}/MarcaControlador?accion=guardar" method="POST">
                        <div class="modal-body">
                            <div class="form-group">
                                <label for="nombre" class="required">Nombre *</label>
                                <input type="text" class="form-control" id="nombre" name="nombre" required
                                       maxlength="50" pattern="[A-Za-z0-9áéíóúÁÉÍÓÚñÑ\s\-]+" 
                                       title="Solo letras, números y espacios">
                            </div>
                        </div>
                        <div class="modal-footer">
                            <button type="submit" class="btn btn-primary">
                                <i class="fas fa-save"></i> Guardar Marca
                            </button>
                        </div>
                    </form>
                </div>
            </div>
        </div>

        <!-- Modal Editar Marca -->
        <div class="modal fade" id="editarMarcaModal" tabindex="-1" role="dialog" aria-hidden="true">
            <div class="modal-dialog" role="document">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title">
                            <i class="fas fa-edit"></i> Editar Marca
                        </h5>
                    </div>
                    <form id="editarMarcaForm" action="${pageContext.request.contextPath}/MarcaControlador?accion=actualizar" method="POST">
                        <input type="hidden" id="edit_id" name="id">
                        <div class="modal-body">
                            <div class="form-group">
                                <label for="edit_nombre" class="required">Nombre *</label>
                                <input type="text" class="form-control" id="edit_nombre" name="nombre" required
                                       maxlength="50" pattern="[A-Za-z0-9áéíóúÁÉÍÓÚñÑ\s\-]+" 
                                       title="Solo letras, números y espacios">
                            </div>
                            <div class="form-group">
                                <label for="edit_estado" class="required">Estado *</label>
                                <select class="form-control" id="edit_estado" name="estado" required>
                                    <option value="activo">Activo</option>
                                    <option value="inactivo">Inactivo</option>
                                </select>
                            </div>
                        </div>
                        <div class="modal-footer">
                            <button type="submit" class="btn btn-primary">
                                <i class="fas fa-save"></i> Actualizar Marca
                            </button>
                        </div>
                    </form>
                </div>
            </div>
        </div>

        <!-- Modal Confirmación -->
        <div class="modal fade" id="confirmModal" tabindex="-1" role="dialog" aria-hidden="true">
            <div class="modal-dialog" role="document">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title" id="confirmModalTitle">Confirmar Acción</h5>
                    </div>
                    <div class="modal-body" id="confirmModalBody">
                        ¿Está seguro que desea realizar esta acción?
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-dismiss="modal">Cancelar</button>
                        <a href="#" class="btn btn-danger" id="btn-confirmar">Confirmar</a>
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
                    marcaCreated: 'Marca creada correctamente',
                    marcaUpdated: 'Marca actualizada correctamente',
                    marcaError: 'Error al procesar la marca'
                },
                endpoints: {
                    marca: {
                        list: '${pageContext.request.contextPath}/MarcaControlador?accion=listatodas',
                        filter: '${pageContext.request.contextPath}/MarcaControlador?accion=filtrar',
                        edit: '${pageContext.request.contextPath}/MarcaControlador?accion=editar&id=',
                        save: '${pageContext.request.contextPath}/MarcaControlador?accion=guardar',
                        update: '${pageContext.request.contextPath}/MarcaControlador?accion=actualizar',
                        activate: '${pageContext.request.contextPath}/MarcaControlador?accion=activar&id=',
                        deactivate: '${pageContext.request.contextPath}/MarcaControlador?accion=eliminar&id='
                    }
                }
            };
        </script>
        <script src="${pageContext.request.contextPath}/js/marcas.js"></script>
    </body>
</html>