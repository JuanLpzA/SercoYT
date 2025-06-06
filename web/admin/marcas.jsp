<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Marcas - SERCOYT</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/bootstrap.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/dashboard.css">
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
                <div class="section-header">
                    <h4>Lista de Marcas</h4>
                    <div class="header-actions">
                        <button class="btn btn-primary" data-toggle="modal" data-target="#nuevaMarcaModal">
                            <i class="fas fa-plus"></i> Nueva Marca
                        </button>
                    </div>
                </div>

                <div class="section-content">
                    <div class="table-responsive">
                        <table class="table table-striped">
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
                                        <td>${marca.id}</td>
                                        <td>${marca.nombre}</td>
                                        <td>
                                            <span class="badge ${marca.estado == 'activo' ? 'badge-success' : 'badge-danger'}">
                                                ${marca.estado}
                                            </span>
                                        </td>
                                        <td>
                                            <button class="btn btn-sm btn-warning btn-editar-marca" 
                                                    data-id="${marca.id}">
                                                <i class="fas fa-edit"></i>
                                            </button>
                                            <button class="btn btn-sm btn-danger btn-eliminar-marca" 
                                                    data-id="${marca.id}">
                                                <i class="fas fa-trash"></i>
                                            </button>
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
                    <h5 class="modal-title">Nueva Marca</h5>
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>
                </div>
                <form action="${pageContext.request.contextPath}/MarcaControlador?accion=guardar" method="POST">
                    <div class="modal-body">
                        <div class="form-group">
                            <label for="nombre">Nombre</label>
                            <input type="text" class="form-control" id="nombre" name="nombre" required>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-dismiss="modal">Cancelar</button>
                        <button type="submit" class="btn btn-primary">Guardar</button>
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
                    <h5 class="modal-title">Editar Marca</h5>
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>
                </div>
                <form action="${pageContext.request.contextPath}/MarcaControlador?accion=actualizar" method="POST">
                    <input type="hidden" id="edit_marca_id" name="id">
                    <div class="modal-body">
                        <div class="form-group">
                            <label for="edit_marca_nombre">Nombre</label>
                            <input type="text" class="form-control" id="edit_marca_nombre" name="nombre" required>
                        </div>
                        <div class="form-group">
                            <label for="edit_marca_estado">Estado</label>
                            <select class="form-control" id="edit_marca_estado" name="estado" required>
                                <option value="activo">Activo</option>
                                <option value="inactivo">Inactivo</option>
                            </select>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-dismiss="modal">Cancelar</button>
                        <button type="submit" class="btn btn-primary">Actualizar</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <!-- Modal Confirmación Eliminar -->
    <div class="modal fade" id="confirmarEliminarMarcaModal" tabindex="-1" role="dialog" aria-hidden="true">
        <div class="modal-dialog" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">Confirmar Eliminación</h5>
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>
                </div>
                <div class="modal-body">
                    ¿Está seguro que desea desactivar esta marca?
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-dismiss="modal">Cancelar</button>
                    <a href="#" class="btn btn-danger" id="btn-confirmar-eliminar-marca">Eliminar</a>
                </div>
            </div>
        </div>
    </div>

    <script src="${pageContext.request.contextPath}/js/jquery-3.7.1.min.js"></script>
    <script src="${pageContext.request.contextPath}/js/bootstrap.min.js"></script>
    <script src="${pageContext.request.contextPath}/js/dashboard.js"></script>
    <script>
        $(document).ready(function() {
            // Editar marca
            $('.btn-editar-marca').click(function() {
                const id = $(this).data('id');
                $.get('${pageContext.request.contextPath}/MarcaControlador?accion=editar&id=' + id, function(data) {
                    $('#edit_marca_id').val(data.id);
                    $('#edit_marca_nombre').val(data.nombre);
                    $('#edit_marca_estado').val(data.estado);
                    
                    $('#editarMarcaModal').modal('show');
                });
            });

            // Eliminar marca
            $('.btn-eliminar-marca').click(function() {
                const id = $(this).data('id');
                $('#btn-confirmar-eliminar-marca').attr('href', 
                    '${pageContext.request.contextPath}/MarcaControlador?accion=eliminar&id=' + id);
                $('#confirmarEliminarMarcaModal').modal('show');
            });
        });
    </script>
</body>
</html>