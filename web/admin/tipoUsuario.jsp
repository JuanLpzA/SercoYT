<%-- 
    Document   : TipoUsuario
    Created on : 25 jun. 2025, 14:52:30
    Author     : Arrunategui
--%>
<%@ page contentType="text/html" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
    <head>
        <title>Gestión de Roles</title>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/bootstrap.min.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/dashboard.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/tipoUsuario.css">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
        <script src="${pageContext.request.contextPath}/js/jquery-3.7.1.min.js"></script>
        <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
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
                        <h4>Productos</h4>
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


                <div class="container my-4">    
                    <h2>Gestión de Roles (Tipo de Usuario)</h2>
                    <button class="btn btn-primary mb-3" id="btnNuevoRol">Nuevo Rol</button>
                    <table class="table table-bordered">
                        <thead>
                            <tr>
                                <th>ID</th>
                                <th>Nombre</th>
                                <th>Estado</th>
                                <th>Acciones</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="tipo" items="${tiposUsuario}">
                                <tr>
                                    <td>${tipo.idTipoUsuario}</td>
                                    <td>${tipo.nombre}</td>
                                    <td>${tipo.estadoTipo}</td>
                                    <td>
                                        <button class="btn btn-secondary btn-sm btnEditar" 
                                                data-id="${tipo.idTipoUsuario}" 
                                                data-nombre="${tipo.nombre}" 
                                                data-estado="${tipo.estadoTipo}">Editar</button>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>

                <!-- Modal Nuevo Rol -->
                <div class="modal fade" id="modalNuevoRol" tabindex="-1" role="dialog" aria-hidden="true">
                    <div class="modal-dialog" role="document">
                        <form id="formNuevoRol" class="modal-content">
                            <div class="modal-header">
                                <h5 class="modal-title">Nuevo Rol</h5>
                            </div>
                            <div class="modal-body">
                                <div class="form-group">
                                    <label>Nombre</label>
                                    <input type="text" class="form-control" name="nombre" required maxlength="50">
                                </div>
                                <div class="form-group">
                                    <label>Estado</label>
                                    <select class="form-control" name="estadoTipo" required>
                                        <option value="activo">Activo</option>
                                        <option value="inactivo">Inactivo</option>
                                    </select>
                                </div>
                            </div>
                            <div class="modal-footer">
                                <button type="submit" class="btn btn-primary">Guardar</button>
                                <button type="button" class="btn btn-secondary" data-dismiss="modal">Cancelar</button>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>


<!-- Modal Editar Rol -->
<div class="modal fade" id="modalEditarRol" tabindex="-1" role="dialog" aria-hidden="true">
    <div class="modal-dialog" role="document">
        <form id="formEditarRol" class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title">Editar Rol</h5>
            </div>
            <div class="modal-body">
                <input type="hidden" name="idTipoUsuario" id="edit_idTipoUsuario">
                <div class="form-group">
                    <label>Nombre</label>
                    <input type="text" class="form-control" name="nombre" id="edit_nombre" required maxlength="50">
                </div>
                <div class="form-group">
                    <label>Estado</label>
                    <select class="form-control" name="estadoTipo" id="edit_estadoTipo" required>
                        <option value="activo">Activo</option>
                        <option value="inactivo">Inactivo</option>
                    </select>
                </div>
                <div class="alert alert-warning" id="editAdvertencia" style="display: none">
                    Si desactivas el rol, todos los usuarios asociados también serán desactivados.
                </div>
            </div>
            <div class="modal-footer">
                <button type="submit" class="btn btn-primary">Actualizar</button>
                <button type="button" class="btn btn-secondary" data-dismiss="modal">Cancelar</button>
            </div>
        </form>
    </div>
</div>

<script src="${pageContext.request.contextPath}/js/bootstrap.min.js"></script>
<script src="${pageContext.request.contextPath}/js/tipoUsuario.js"></script>
</body>
</html>