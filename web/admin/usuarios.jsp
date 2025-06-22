<%-- 
    Document   : cuentas
    Created on : 22 jun. 2025, 04:57:13
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
        <title>Usuarios - SERCOYT</title>
        <link rel="icon" type="image/png" href="${pageContext.request.contextPath}/img/logo.png">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/bootstrap.min.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/dashboard.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/usuarios.css">
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
                        <h4>Usuarios</h4>
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
                        <h4>Lista de Usuarios</h4>
                        <div class="header-actions">
                            <button class="btn btn-primary" id="btnNuevoUsuario">
                                <i class="fas fa-plus"></i> Nuevo Usuario
                            </button>
                        </div>
                    </div>

                    <div class="section-content">
                        <div class="filter-card">
                            <div class="card-header">
                                <h5>Filtrar Usuarios</h5>
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
                                        <label for="filtroCorreo">Correo</label>
                                        <input type="text" class="form-control" id="filtroCorreo" name="correo" 
                                               value="${filtroCorreo != null ? filtroCorreo : ''}"
                                               placeholder="Buscar por correo...">
                                    </div>
                                    <div class="filter-group">
                                        <label for="filtroDni">DNI</label>
                                        <input type="text" class="form-control" id="filtroDni" name="dni" 
                                               value="${filtroDni != null ? filtroDni : ''}"
                                               placeholder="Buscar por DNI..." maxlength="8">
                                    </div>
                                    <div class="filter-group">
                                        <label for="filtroTelefono">Teléfono</label>
                                        <input type="text" class="form-control" id="filtroTelefono" name="telefono" 
                                               value="${filtroTelefono != null ? filtroTelefono : ''}"
                                               placeholder="Buscar por teléfono..." maxlength="9">
                                    </div>
                                    <div class="filter-group">
                                        <label for="filtroTipoUsuario">Tipo de Usuario</label>
                                        <select class="form-control" id="filtroTipoUsuario" name="tipoUsuario">
                                            <option value="">Todos los tipos</option>
                                            <c:forEach var="tipo" items="${tiposUsuario}">
                                                <option value="${tipo.idTipoUsuario}" ${filtroTipoUsuario eq tipo.idTipoUsuario ? 'selected' : ''}>${tipo.nombre}</option>
                                            </c:forEach>
                                        </select>
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
                                <h5>Lista de Usuarios</h5>
                                <div class="table-stats">
                                    <span>Total: <strong>${fn:length(usuarios)}</strong> usuarios</span>
                                </div>
                            </div>
                            <table class="products-table">
                                <thead>
                                    <tr>
                                        <th>ID</th>
                                        <th>Nombre</th>
                                        <th>Apellido</th>
                                        <th>DNI</th>
                                        <th>Contraseña</th>
                                        <th>Correo</th>
                                        <th>Teléfono</th>
                                        <th>Dirección</th>
                                        <th>Tipo</th>
                                        <th>Estado</th>
                                        <th>Acciones</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="usuario" items="${usuarios}">
                                        <tr>
                                            <td><strong>#${usuario.idUsuario}</strong></td>
                                            <td>${usuario.nombre}</td>
                                            <td>${usuario.apellido}</td>
                                            <td>${usuario.dni}</td>
                                            <td>*******</td>
                                            <td>${usuario.correo}</td>
                                            <td>${usuario.telefono}</td>
                                            <td>${usuario.direccion}</td>
                                            <td>${usuario.tipoUsuario}</td>
                                            <td>
                                                <span class="status-badge ${usuario.estado eq 'activo' ? 'active' : 'inactive'}">
                                                    ${usuario.estado eq 'activo' ? 'Activo' : 'Inactivo'}
                                                </span>
                                            </td>
                                            <td>
                                                <div class="action-buttons">
                                                    <button class="btn-action edit btn-editar" 
                                                            data-id="${usuario.idUsuario}" title="Editar">
                                                        <i class="fas fa-edit"></i>
                                                    </button>
                                                    <button class="btn-action promote btn-ascender" 
                                                            data-id="${usuario.idUsuario}" title="Cambiar Rol">
                                                        <i class="fas fa-user-tag"></i>
                                                    </button>
                                                    <button class="btn-action password btn-contrasena" 
                                                            data-id="${usuario.idUsuario}" title="Cambiar Contraseña">
                                                        <i class="fas fa-key"></i>
                                                    </button>
                                                    <c:choose>
                                                        <c:when test="${usuario.estado eq 'activo'}">
                                                            <button class="btn-action deactivate btn-desactivar" 
                                                                    data-id="${usuario.idUsuario}" title="Desactivar">
                                                                <i class="fas fa-times"></i>
                                                            </button>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <button class="btn-action activate btn-activar" 
                                                                    data-id="${usuario.idUsuario}" title="Activar">
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

        <!-- Modal Seleccionar Tipo de Usuario -->
        <div class="modal fade" id="seleccionarTipoModal" tabindex="-1" role="dialog" aria-hidden="true">
            <div class="modal-dialog" role="document">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title">
                            <i class="fas fa-user-plus"></i> Seleccionar Tipo de Usuario
                        </h5>
                    </div>
                    <div class="modal-body">
                        <div class="tipo-usuario-options">
                            <div class="tipo-option" data-tipo="1">
                                <i class="fas fa-user-shield"></i>
                                <h5>Administrador</h5>
                                <p>Acceso completo al sistema</p>
                            </div>
                            <div class="tipo-option" data-tipo="2">
                                <i class="fas fa-user-tie"></i>
                                <h5>Vendedor</h5>
                                <p>Acceso a ventas y productos</p>
                            </div>
                            <div class="tipo-option" data-tipo="3">
                                <i class="fas fa-user"></i>
                                <h5>Cliente</h5>
                                <p>Acceso solo a compras</p>
                            </div>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-dismiss="modal">Cancelar</button>
                    </div>
                </div>
            </div>
        </div>

        <!-- Modal Nuevo Usuario -->
        <div class="modal fade" id="nuevoUsuarioModal" tabindex="-1" role="dialog" aria-hidden="true">
            <div class="modal-dialog" role="document">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title">
                            <i class="fas fa-user-plus"></i> Nuevo Usuario
                        </h5>
                    </div>
                    <form id="nuevoUsuarioForm" action="${pageContext.request.contextPath}/UsuarioControlador?accion=guardarAdmin" method="POST">
                        <input type="hidden" id="tipoUsuario" name="tipoUsuario">
                        <div class="modal-body">
                            <div class="form-row">
                                <div class="form-group col-md-6">
                                    <label for="dni" class="required">DNI *</label>
                                    <div class="input-group">
                                        <input type="text" class="form-control" id="dni" name="dni" required
                                               maxlength="8" pattern="[0-9]{8}" title="Debe tener 8 dígitos numéricos">
                                        <div class="input-group-append">
                                            <button class="btn btn-outline-secondary" type="button" id="btnConsultarDni">
                                                <i class="fas fa-search"></i> Consultar
                                            </button>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="form-row">
                                <div class="form-group col-md-6">
                                    <label for="nombre" class="required">Nombre *</label>
                                    <input type="text" class="form-control" id="nombre" name="nombre" required
                                           maxlength="50" pattern="[A-Za-záéíóúÁÉÍÓÚñÑ\s]+" title="Solo letras y espacios">
                                </div>
                                <div class="form-group col-md-6">
                                    <label for="apellido" class="required">Apellido *</label>
                                    <input type="text" class="form-control" id="apellido" name="apellido" required
                                           maxlength="50" pattern="[A-Za-záéíóúÁÉÍÓÚñÑ\s]+" title="Solo letras y espacios">
                                </div>
                            </div>
                            <div class="form-group">
                                <label for="correo">Correo Electrónico</label>
                                <input type="email" class="form-control" id="correo" name="correo"
                                       maxlength="100" title="Ingrese un correo válido">
                            </div>
                            <div class="form-row">
                                <div class="form-group col-md-6">
                                    <label for="telefono">Teléfono</label>
                                    <input type="text" class="form-control" id="telefono" name="telefono"
                                           maxlength="9" pattern="[0-9]{7,9}" title="Debe tener entre 7 y 9 dígitos">
                                </div>
                                <div class="form-group col-md-6">
                                    <label for="direccion">Dirección</label>
                                    <input type="text" class="form-control" id="direccion" name="direccion" maxlength="30">
                                </div>
                            </div>
                            <div class="form-group">
                                <label for="contrasena" class="required">Contraseña *</label>
                                <input type="password" class="form-control" id="contrasena" name="contrasena" required
                                       minlength="8" title="Mínimo 8 caracteres con números y letras">
                                <small class="form-text text-muted">La contraseña debe tener al menos 8 caracteres, incluyendo números y letras</small>
                            </div>
                            <div class="form-group">
                                <label for="confirmarContrasena" class="required">Confirmar Contraseña *</label>
                                <input type="password" class="form-control" id="confirmarContrasena" name="confirmarContrasena" required>
                            </div>
                        </div>
                        <div class="modal-footer">
                            <button type="submit" class="btn btn-primary">
                                <i class="fas fa-save"></i> Guardar Usuario
                            </button>
                        </div>
                    </form>
                </div>
            </div>
        </div>

        <!-- Modal Editar Usuario -->
        <div class="modal fade" id="editarUsuarioModal" tabindex="-1" role="dialog" aria-hidden="true">
            <div class="modal-dialog" role="document">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title">
                            <i class="fas fa-edit"></i> Editar Usuario
                        </h5>
                    </div>
                    <form id="editarUsuarioForm" action="${pageContext.request.contextPath}/UsuarioControlador?accion=actualizarAdmin" method="POST">
                        <input type="hidden" id="edit_id" name="idUsuario">
                        <div class="modal-body">
                            <div class="form-row">
                                <div class="form-group col-md-6">
                                    <label for="edit_dni" class="required">DNI *</label>
                                    <input type="text" class="form-control" id="edit_dni" name="dni" required
                                           maxlength="8" pattern="[0-9]{8}" title="Debe tener 8 dígitos numéricos">
                                </div>
                            </div>
                            <div class="form-row">
                                <div class="form-group col-md-6">
                                    <label for="edit_nombre" class="required">Nombre *</label>
                                    <input type="text" class="form-control" id="edit_nombre" name="nombre" required
                                           maxlength="50" pattern="[A-Za-záéíóúÁÉÍÓÚñÑ\s]+" title="Solo letras y espacios">
                                </div>
                                <div class="form-group col-md-6">
                                    <label for="edit_apellido" class="required">Apellido *</label>
                                    <input type="text" class="form-control" id="edit_apellido" name="apellido" required
                                           maxlength="50" pattern="[A-Za-záéíóúÁÉÍÓÚñÑ\s]+" title="Solo letras y espacios">
                                </div>
                            </div>
                            <div class="form-group">
                                <label for="edit_correo">Correo Electrónico</label>
                                <input type="email" class="form-control" id="edit_correo" name="correo"
                                       maxlength="100" title="Ingrese un correo válido">
                            </div>
                            <div class="form-row">
                                <div class="form-group col-md-6">
                                    <label for="edit_telefono">Teléfono</label>
                                    <input type="text" class="form-control" id="edit_telefono" name="telefono"
                                           maxlength="9" pattern="[0-9]{7,9}" title="Debe tener entre 7 y 9 dígitos">
                                </div>
                                <div class="form-group col-md-6">
                                    <label for="edit_direccion">Dirección</label>
                                    <input type="text" class="form-control" id="edit_direccion" name="direccion" maxlength="30">
                                </div>
                            </div>
                            <div class="form-group">
                                <label>Contraseña</label>
                                <input type="text" class="form-control" value="********" readonly>
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
                                <i class="fas fa-save"></i> Actualizar Usuario
                            </button>
                        </div>
                    </form>
                </div>
            </div>
        </div>

        <!-- Modal Cambiar Rol -->
        <div class="modal fade" id="cambiarRolModal" tabindex="-1" role="dialog" aria-hidden="true">
            <div class="modal-dialog" role="document">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title">
                            <i class="fas fa-user-tag"></i> Cambiar Rol de Usuario
                        </h5>
                    </div>
                    <form id="cambiarRolForm" action="${pageContext.request.contextPath}/UsuarioControlador?accion=cambiarRol" method="POST">
                        <input type="hidden" id="rol_id" name="idUsuario">
                        <div class="modal-body">
                            <div class="form-group">
                                <label for="rol_actual">Rol Actual</label>
                                <input type="text" class="form-control" id="rol_actual" readonly>
                            </div>
                            <div class="form-group">
                                <label for="nuevo_rol" class="required">Nuevo Rol *</label>
                                <select class="form-control" id="nuevo_rol" name="nuevoRol" required>
                                    <c:forEach var="tipo" items="${tiposUsuario}">
                                        <option value="${tipo.idTipoUsuario}">${tipo.nombre}</option>
                                    </c:forEach>
                                </select>
                            </div>
                        </div>
                        <div class="modal-footer">
                            <button type="submit" class="btn btn-primary">
                                <i class="fas fa-save"></i> Cambiar Rol
                            </button>
                        </div>
                    </form>
                </div>
            </div>
        </div>

        <!-- Modal Cambiar Contraseña -->
        <div class="modal fade" id="cambiarContrasenaModal" tabindex="-1" role="dialog" aria-hidden="true">
            <div class="modal-dialog" role="document">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title">
                            <i class="fas fa-key"></i> Cambiar Contraseña
                        </h5>
                    </div>
                    <form id="cambiarContrasenaForm" action="${pageContext.request.contextPath}/UsuarioControlador?accion=cambiarContrasenaAdmin" method="POST">
                        <input type="hidden" id="contrasena_id" name="idUsuario">
                        <div class="modal-body">
                            <div class="form-group">
                                <label for="nueva_contrasena" class="required">Nueva Contraseña *</label>
                                <input type="password" class="form-control" id="nueva_contrasena" name="nuevaContrasena" required
                                       minlength="8" title="Mínimo 8 caracteres con números y letras">
                                <small class="form-text text-muted">La contraseña debe tener al menos 8 caracteres, incluyendo números y letras</small>
                            </div>
                            <div class="form-group">
                                <label for="confirmar_nueva_contrasena" class="required">Confirmar Nueva Contraseña *</label>
                                <input type="password" class="form-control" id="confirmar_nueva_contrasena" name="confirmarNuevaContrasena" required>
                            </div>
                        </div>
                        <div class="modal-footer">
                            <button type="submit" class="btn btn-primary">
                                <i class="fas fa-save"></i> Cambiar Contraseña
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
                    usuarioCreated: 'Usuario creado correctamente',
                    usuarioUpdated: 'Usuario actualizado correctamente',
                    usuarioError: 'Error al procesar el usuario',
                    contrasenaNoCoincide: 'Las contraseñas no coinciden',
                    contrasenaInvalida: 'La contraseña debe tener al menos 8 caracteres, incluyendo números y letras',
                    dniInvalido: 'El DNI debe tener 8 dígitos numéricos',
                    dniExistente: 'Ya existe un usuario con este DNI',
                    correoExistente: 'Ya existe un usuario con este correo electrónico'
                },
                endpoints: {
                    usuario: {
                        list: '${pageContext.request.contextPath}/UsuarioControlador?accion=listarAdmin',
                        filter: '${pageContext.request.contextPath}/UsuarioControlador?accion=filtrarAdmin',
                        edit: '${pageContext.request.contextPath}/UsuarioControlador?accion=editarAdmin&id=',
                        save: '${pageContext.request.contextPath}/UsuarioControlador?accion=guardarAdmin',
                        update: '${pageContext.request.contextPath}/UsuarioControlador?accion=actualizarAdmin',
                        cambiarRol: '${pageContext.request.contextPath}/UsuarioControlador?accion=cambiarRol',
                        cambiarContrasena: '${pageContext.request.contextPath}/UsuarioControlador?accion=cambiarContrasenaAdmin',
                        activate: '${pageContext.request.contextPath}/UsuarioControlador?accion=activarAdmin&id=',
                        deactivate: '${pageContext.request.contextPath}/UsuarioControlador?accion=desactivarAdmin&id=',
                        consultarDni: '${pageContext.request.contextPath}/UsuarioControlador?accion=consultarDni&dni='
                    }
                }
            };
        </script>
        <script src="${pageContext.request.contextPath}/js/usuarios.js"></script>
    </body>
</html>