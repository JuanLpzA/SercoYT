<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html lang="es">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Clientes - SERCOYT</title>
        <link rel="icon" type="image/png" href="${pageContext.request.contextPath}/img/logo.png">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/bootstrap.min.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/dashboard.css">
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
                        <h4>Clientes</h4>
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
                        <h4>Lista de Clientes</h4>
                        <div class="header-actions">
                            <button class="btn btn-primary" id="btnNuevoCliente">
                                <i class="fas fa-plus"></i> Nuevo Cliente
                            </button>
                        </div>
                    </div>

                    <div class="section-content">
                        <div class="filter-card">
                            <div class="card-header">
                                <h5>Filtrar Clientes</h5>
                            </div>
                            <div class="card-body">
                                <form id="filtroForm" class="filter-form">
                                    <div class="filter-group">
                                        <label for="filtroNombre">Nombre/Apellido</label>
                                        <input type="text" class="form-control" id="filtroNombre" name="nombre" 
                                               value="${filtroNombre != null ? filtroNombre : ''}"
                                               placeholder="Buscar por nombre o apellido...">
                                    </div>
                                    <div class="filter-group">
                                        <label for="filtroDni">DNI</label>
                                        <input type="text" class="form-control" id="filtroDni" name="dni" 
                                               value="${filtroDni != null ? filtroDni : ''}"
                                               placeholder="Buscar por Documento..." maxlength="8">
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
                                <h5>Lista de Clientes</h5>
                                <div class="table-stats">
                                    <span>Total: <strong>${fn:length(clientes)}</strong> clientes</span>
                                </div>
                            </div>
                            <table class="clients-table">
                                <thead>
                                    <tr>
                                        <th>ID</th>
                                        <th>Nombre</th>
                                        <th>Apellido</th>
                                        <th>DNI/RUC</th>
                                        <th>Teléfono</th>
                                        <th>Categoria</th>
                                        <th>Acciones</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="cliente" items="${clientes}">
                                        <tr>
                                            <td><strong>#${cliente.idCliente}</strong></td>
                                            <td>${cliente.nombre}</td>
                                            <td>${cliente.apellido}</td>
                                            <td>${cliente.documento}</td>
                                            <td>${cliente.telefono}</td>
                                            <td>${cliente.tipoCliente}</td>
                                            <td>
                                                <div class="action-buttons">
                                                    <button class="btn-action edit btn-editar" 
                                                            data-id="${cliente.idCliente}" title="Editar">
                                                        <i class="fas fa-edit"></i>
                                                    </button>
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

        <!-- Modal Nuevo Cliente -->
        <div class="modal fade" id="nuevoClienteModal" tabindex="-1" role="dialog" aria-hidden="true">
            <div class="modal-dialog" role="document">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title">
                            <i class="fas fa-user-plus"></i> Nuevo Cliente
                        </h5>

                    </div>
                    <form id="nuevoClienteForm" action="${pageContext.request.contextPath}/ClienteControlador?accion=guardar" method="POST">
                        <div class="modal-body">
                            <div class="form-group">
                                <label for="dni" class="required">DNI *</label>
                                <div class="input-group">
                                    <input type="text" class="form-control" id="dni" name="dni" required
                                           maxlength="8" pattern="[0-9]{8}" title="Ingrese 8 dígitos numéricos">
                                    <div class="input-group-append">
                                        <button class="btn btn-outline-secondary" type="button" id="btnConsultarDni">
                                            <i class="fas fa-search"></i> Buscar
                                        </button>
                                    </div>
                                </div>
                                <small class="form-text text-muted">Ingrese el DNI para buscar automáticamente</small>
                            </div>
                            <div class="form-group">
                                <label for="nombre" class="required">Nombre *</label>
                                <input type="text" class="form-control" id="nombre" name="nombre" required
                                       maxlength="50" pattern="[A-Za-záéíóúÁÉÍÓÚñÑ\s]+" 
                                       title="Solo letras y espacios">
                            </div>
                            <div class="form-group">
                                <label for="apellido" class="required">Apellido *</label>
                                <input type="text" class="form-control" id="apellido" name="apellido" required
                                       maxlength="50" pattern="[A-Za-záéíóúÁÉÍÓÚñÑ\s]+" 
                                       title="Solo letras y espacios">
                            </div>
                            <div class="form-group">
                                <label for="telefono">Teléfono</label>
                                <input type="text" class="form-control" id="telefono" name="telefono"
                                       maxlength="9" pattern="[0-9]{9}" title="Ingrese 9 dígitos numéricos">
                            </div>
                        </div>
                        <div class="modal-footer">
                            <button type="submit" class="btn btn-primary">
                                <i class="fas fa-save"></i> Guardar Cliente
                            </button>
                        </div>
                    </form>
                </div>
            </div>
        </div>

        <!-- Modal Editar Cliente -->
        <div class="modal fade" id="editarClienteModal" tabindex="-1" role="dialog" aria-hidden="true">
            <div class="modal-dialog" role="document">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title">
                            <i class="fas fa-user-edit"></i> Editar Cliente
                        </h5>

                    </div>
                    <form id="editarClienteForm" action="${pageContext.request.contextPath}/ClienteControlador?accion=actualizar" method="POST">
                        <input type="hidden" id="edit_id" name="id">
                        <div class="modal-body">
                            <div class="form-group">
                                <label for="edit_dni" class="required">DNI *</label>
                                <input type="text" class="form-control" id="edit_dni" name="dni" required
                                       maxlength="8" pattern="[0-9]{8}" title="Ingrese 8 dígitos numéricos">
                            </div>
                            <div class="form-group">
                                <label for="edit_nombre" class="required">Nombre *</label>
                                <input type="text" class="form-control" id="edit_nombre" name="nombre" required
                                       maxlength="50" pattern="[A-Za-záéíóúÁÉÍÓÚñÑ\s]+" 
                                       title="Solo letras y espacios">
                            </div>
                            <div class="form-group">
                                <label for="edit_apellido" class="required">Apellido *</label>
                                <input type="text" class="form-control" id="edit_apellido" name="apellido" required
                                       maxlength="50" pattern="[A-Za-záéíóúÁÉÍÓÚñÑ\s]+" 
                                       title="Solo letras y espacios">
                            </div>
                            <div class="form-group">
                                <label for="edit_telefono">Teléfono</label>
                                <input type="text" class="form-control" id="edit_telefono" name="telefono"
                                       maxlength="9" pattern="[0-9]{9}" title="Ingrese 9 dígitos numéricos">
                            </div>
                        </div>
                        <div class="modal-footer">

                            <button type="submit" class="btn btn-primary">
                                <i class="fas fa-save"></i> Actualizar Cliente
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
                        <h5 class="modal-title" id="confirmModalTitle">Confirmar Eliminación</h5>
                    </div>
                    <div class="modal-body" id="confirmModalBody">
                        ¿Está seguro que desea eliminar este cliente? Esta acción no se puede deshacer.
                    </div>
                    <div class="modal-footer">
                        <a href="#" class="btn btn-danger" id="btn-confirmar">Eliminar</a>
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
                    clienteCreated: 'Cliente creado correctamente',
                    clienteUpdated: 'Cliente actualizado correctamente',
                    clienteError: 'Error al procesar el cliente',
                    dniInvalid: 'El DNI debe tener 8 dígitos numéricos',
                    telefonoInvalid: 'El teléfono debe tener 9 dígitos numéricos'
                },
                endpoints: {
                    cliente: {
                        list: '${pageContext.request.contextPath}/ClienteControlador?accion=listar',
                        filter: '${pageContext.request.contextPath}/ClienteControlador?accion=filtrar',
                        edit: '${pageContext.request.contextPath}/ClienteControlador?accion=editar&id=',
                        save: '${pageContext.request.contextPath}/ClienteControlador?accion=guardar',
                        update: '${pageContext.request.contextPath}/ClienteControlador?accion=actualizar',
                        delete: '${pageContext.request.contextPath}/ClienteControlador?accion=eliminar&id=',
                        consultarDni: '${pageContext.request.contextPath}/ClienteControlador?accion=consultarDni&dni='
                    }
                }
            };
        </script>
        <script src="${pageContext.request.contextPath}/js/clientes.js"></script>
    </body>
</html>