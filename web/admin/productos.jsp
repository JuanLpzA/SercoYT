<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html lang="es">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Productos - SERCOYT</title>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/bootstrap.min.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/dashboard.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/productos.css">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
        <link href="https://cdn.jsdelivr.net/npm/select2@4.1.0-rc.0/dist/css/select2.min.css" rel="stylesheet" />
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
                        <h4>Lista de Productos</h4>
                        <div class="header-actions">
                            <button class="btn btn-primary" id="btnNuevoProducto">
                                <i class="fas fa-plus"></i> Nuevo Producto
                            </button>
                        </div>
                    </div>

                    <div class="section-content">
                        <div class="filter-card">
                            <div class="card-header">
                                <h5>Filtrar Productos</h5>
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
                                        <label for="filtroMarca">Marca</label>
                                        <select class="form-control select2" id="filtroMarca" name="marca">
                                            <option value="">Todas las marcas</option>
                                            <c:forEach var="marca" items="${marcas}">
                                                <option value="${marca.nombre}" 
                                                        ${filtroMarca != null && filtroMarca eq marca.nombre ? 'selected' : ''}>
                                                    ${marca.nombre}
                                                </option>
                                            </c:forEach>
                                        </select>
                                    </div>
                                    <div class="filter-group">
                                        <label for="filtroCategoria">Categoría</label>
                                        <select class="form-control select2" id="filtroCategoria" name="categoria">
                                            <option value="">Todas las categorías</option>
                                            <c:forEach var="categoria" items="${categorias}">
                                                <option value="${categoria.nombre}" 
                                                        ${filtroCategoria != null && filtroCategoria eq categoria.nombre ? 'selected' : ''}>
                                                    ${categoria.nombre}
                                                </option>
                                            </c:forEach>
                                        </select>
                                    </div>
                                    <div class="filter-group">
                                        <label for="filtroStockMin">Stock Mínimo</label>
                                        <input type="number" class="form-control" id="filtroStockMin" name="stockMin" 
                                               min="0" value="${filtroStockMin != null ? filtroStockMin : ''}"
                                               placeholder="Ej: 10">
                                    </div>
                                    <div class="filter-group">
                                        <label for="filtroStockMax">Stock Máximo</label>
                                        <input type="number" class="form-control" id="filtroStockMax" name="stockMax" 
                                               min="0" value="${filtroStockMax != null ? filtroStockMax : ''}"
                                               placeholder="Ej: 100">
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
                                <h5>Lista de Productos</h5>
                                <div class="table-stats">
                                    <span>Total: <strong>${fn:length(productos)}</strong> productos</span>
                                </div>
                            </div>
                            <table class="products-table">
                                <thead>
                                    <tr>
                                        <th>ID</th>
                                        <th>Imagen</th>
                                        <th>Nombre</th>
                                        <th>Precio</th>
                                        <th>Stock</th>
                                        <th>Marca</th>
                                        <th>Categoría</th>
                                        <th>Estado</th>
                                        <th>Acciones</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="producto" items="${productos}">
                                        <tr>
                                            <td><strong>#${producto.id}</strong></td>
                                            <td>
                                                <img src="${pageContext.request.contextPath}/ControladorIMG?id=${producto.id}" 
                                                     alt="${producto.nombres}" class="product-thumbnail">
                                            </td>
                                            <td>
                                                <strong>${producto.nombres}</strong>
                                                <c:if test="${not empty producto.descripcion}">
                                                    <div style="font-size: 0.8rem; color: #6c757d; margin-top: 2px;">
                                                        ${fn:substring(producto.descripcion, 0, 50)}...
                                                    </div>
                                                </c:if>
                                            </td>
                                            <td>
                                                <span class="product-price">S/. ${producto.precio}</span>
                                            </td>
                                            <td>
                                                <span class="product-stock ${producto.stock <= 10 ? 'low' : (producto.stock <= 50 ? 'medium' : 'high')}">
                                                    ${producto.stock}
                                                </span>
                                            </td>
                                            <td>${producto.nombreMarca}</td>
                                            <td>${producto.nombreCategoria}</td>
                                            <td>
                                                <span class="status-badge ${producto.estado eq 'activo' ? 'active' : 'inactive'}">
                                                    ${producto.estado eq 'activo' ? 'Activo' : 'Inactivo'}
                                                </span>
                                            </td>
                                            <td>
                                                <div class="action-buttons">
                                                    <button class="btn-action edit btn-editar" 
                                                            data-id="${producto.id}" title="Editar">
                                                        <i class="fas fa-edit"></i>
                                                    </button>
                                                    <c:choose>
                                                        <c:when test="${producto.estado eq 'activo'}">
                                                            <button class="btn-action deactivate btn-desactivar" 
                                                                    data-id="${producto.id}" title="Desactivar">
                                                                <i class="fas fa-times"></i>
                                                            </button>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <button class="btn-action activate btn-activar" 
                                                                    data-id="${producto.id}" title="Activar">
                                                                <i class="fas fa-check"></i>
                                                            </button>
                                                        </c:otherwise>
                                                    </c:choose>
                                                    <button class="btn-action stock btn-stock" 
                                                            data-id="${producto.id}" data-stock="${producto.stock}" title="Gestionar Stock">
                                                        <i class="fas fa-boxes"></i>
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

        <!-- Modal Nuevo Producto - VERSIÓN MEJORADA -->
        <div class="modal fade" id="nuevoProductoModal" tabindex="-1" role="dialog" aria-hidden="true">
            <div class="modal-dialog modal-lg" role="document">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title">
                            <i class="fas fa-plus-circle"></i> Nuevo Producto
                        </h5>
                        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                            <span aria-hidden="true">&times;</span>
                        </button>
                    </div>
                    <form id="nuevoProductoForm" action="${pageContext.request.contextPath}/ProductoControlador?accion=guardar" 
                          method="POST" enctype="multipart/form-data">
                        <div class="modal-body">
                            <!-- Información básica -->
                            <div class="form-section">
                                <div class="form-section-title">
                                    <i class="fas fa-info-circle"></i> Información Básica
                                </div>
                                <div class="form-grid cols-2">
                                    <div class="form-field">
                                        <label for="nombre" class="required">Nombre</label>
                                        <input type="text" class="form-control" id="nombre" name="nombre" required
                                               maxlength="100" pattern="[A-Za-z0-9áéíóúÁÉÍÓÚñÑ\s\-]+" 
                                               title="Solo letras, números y espacios">
                                    </div>
                                    <div class="form-field">
                                        <label for="precio" class="required">Precio (S/.)</label>
                                        <input type="number" class="form-control" id="precio" name="precio" 
                                               step="0.01" min="0" required>
                                    </div>
                                </div>
                                <div class="form-grid cols-1">
                                    <div class="form-field">
                                        <label for="descripcion">Descripción</label>
                                        <textarea class="form-control" id="descripcion" name="descripcion" rows="3"
                                                  maxlength="200" placeholder="Descripción del producto..."></textarea>
                                    </div>
                                </div>
                            </div>

                            <!-- Categorización -->
                            <div class="form-section">
                                <div class="form-section-title">
                                    <i class="fas fa-tags"></i> Categorización
                                </div>
                                <div class="form-grid cols-3">
                                    <div class="form-field">
                                        <label for="stock" class="required">Stock</label>
                                        <input type="number" class="form-control" id="stock" name="stock" 
                                               min="0" required>
                                    </div>
                                    <div class="form-field">
                                        <label for="marca" class="required">Marca</label>
                                        <select class="form-control select2" id="marca" name="marca" required>
                                            <option value="">Seleccionar marca</option>
                                            <c:forEach var="marca" items="${marcas}">
                                                <option value="${marca.nombre}">${marca.nombre}</option>
                                            </c:forEach>
                                        </select>
                                    </div>
                                    <div class="form-field">
                                        <label for="categoria" class="required">Categoría</label>
                                        <select class="form-control select2" id="categoria" name="categoria" required>
                                            <option value="">Seleccionar categoría</option>
                                            <c:forEach var="categoria" items="${categorias}">
                                                <option value="${categoria.nombre}">${categoria.nombre}</option>
                                            </c:forEach>    
                                        </select>
                                    </div>
                                </div>
                            </div>

                            <!-- Imagen -->
                            <div class="form-section">
                                <div class="form-section-title">
                                    <i class="fas fa-image"></i> Imagen del Producto
                                </div>
                                <div class="form-grid cols-1">
                                    <div class="form-field">
                                        <label for="imagen" class="required">Imagen</label>
                                        <div class="file-upload-area" onclick="document.getElementById('imagen').click()">
                                            <div class="file-upload-icon">
                                                <i class="fas fa-cloud-upload-alt"></i>
                                            </div>
                                            <div class="file-upload-text">
                                                Haz clic aquí o arrastra una imagen
                                            </div>
                                            <div class="file-upload-subtext">
                                                JPG, PNG, JPEG - Máximo 2MB
                                            </div>
                                        </div>
                                        <input type="file" class="form-control" id="imagen" name="imagen" 
                                               accept="image/*" required style="display: none;">
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="modal-footer">
                            <button type="button" class="btn btn-secondary" data-dismiss="modal">
                                <i class="fas fa-times"></i> Cancelar
                            </button>
                            <button type="submit" class="btn btn-primary">
                                <i class="fas fa-save"></i> Guardar Producto
                            </button>
                        </div>
                    </form>
                </div>
            </div>
        </div>

        <!-- Modal Editar Producto - VERSIÓN MEJORADA -->
        <div class="modal fade" id="editarProductoModal" tabindex="-1" role="dialog" aria-hidden="true">
            <div class="modal-dialog modal-lg" role="document">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title">
                            <i class="fas fa-edit"></i> Editar Producto
                        </h5>
                        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                            <span aria-hidden="true">&times;</span>
                        </button>
                    </div>
                    <form id="editarProductoForm" action="${pageContext.request.contextPath}/ProductoControlador?accion=actualizar" 
                          method="POST" enctype="multipart/form-data">
                        <input type="hidden" id="edit_id" name="id">
                        <div class="modal-body">
                            <!-- Información básica -->
                            <div class="form-section">
                                <div class="form-section-title">
                                    <i class="fas fa-info-circle"></i> Información Básica
                                </div>
                                <div class="form-grid cols-2">
                                    <div class="form-field">
                                        <label for="edit_nombre" class="required">Nombre</label>
                                        <input type="text" class="form-control" id="edit_nombre" name="nombre" required
                                               maxlength="100" pattern="[A-Za-z0-9áéíóúÁÉÍÓÚñÑ\s\-]+" 
                                               title="Solo letras, números y espacios">
                                    </div>
                                    <div class="form-field">
                                        <label for="edit_precio" class="required">Precio (S/.)</label>
                                        <input type="number" class="form-control" id="edit_precio" name="precio" 
                                               step="0.01" min="0" required>
                                    </div>
                                </div>
                                <div class="form-grid cols-1">
                                    <div class="form-field">
                                        <label for="edit_descripcion">Descripción</label>
                                        <textarea class="form-control" id="edit_descripcion" name="descripcion" rows="3"
                                                  maxlength="200" placeholder="Descripción del producto..."></textarea>
                                    </div>
                                </div>
                            </div>

                            <!-- Categorización -->
                            <div class="form-section">
                                <div class="form-section-title">
                                    <i class="fas fa-tags"></i> Categorización
                                </div>
                                <div class="form-grid cols-2">
                                    <div class="form-field">
                                        <label for="edit_marca" class="required">Marca</label>
                                        <select class="form-control select2" id="edit_marca" name="marca" required>
                                            <option value="">Seleccionar marca</option>
                                            <c:forEach var="marca" items="${marcas}">
                                                <option value="${marca.nombre}">${marca.nombre}</option>
                                            </c:forEach>
                                        </select>
                                    </div>
                                    <div class="form-field">
                                        <label for="edit_categoria" class="required">Categoría</label>
                                        <select class="form-control select2" id="edit_categoria" name="categoria" required>
                                            <option value="">Seleccionar categoría</option>
                                            <c:forEach var="categoria" items="${categorias}">
                                                <option value="${categoria.nombre}">${categoria.nombre}</option>
                                            </c:forEach>
                                        </select>
                                    </div>
                                </div>
                            </div>

                            <!-- Imagen -->
                            <div class="form-section">
                                <div class="form-section-title">
                                    <i class="fas fa-image"></i> Imagen del Producto
                                </div>
                                <div class="form-grid cols-1">
                                    <div class="form-field">
                                        <label for="edit_imagen">Nueva Imagen</label>
                                        <div class="file-upload-area" onclick="document.getElementById('edit_imagen').click()">
                                            <div class="file-upload-icon">
                                                <i class="fas fa-cloud-upload-alt"></i>
                                            </div>
                                            <div class="file-upload-text">
                                                Haz clic aquí o arrastra una imagen
                                            </div>
                                            <div class="file-upload-subtext">
                                                Dejar vacío para mantener la imagen actual
                                            </div>
                                        </div>
                                        <input type="file" class="form-control" id="edit_imagen" name="imagen" 
                                               accept="image/*" style="display: none;">

                                        <div class="current-image-preview" id="imagen-actual-container" style="display: none;">
                                            <img id="imagen-actual" src="" alt="Imagen actual">
                                            <div class="current-image-info">
                                                <strong>Imagen actual</strong>
                                                <small>Esta imagen se mantendrá si no seleccionas una nueva</small>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="modal-footer">
                            <button type="button" class="btn btn-secondary" data-dismiss="modal">
                                <i class="fas fa-times"></i> Cancelar
                            </button>
                            <button type="submit" class="btn btn-primary">
                                <i class="fas fa-save"></i> Actualizar Producto
                            </button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
        <!-- Modal Stock -->
        <div class="modal fade" id="stockModal" tabindex="-1" role="dialog" aria-hidden="true">
            <div class="modal-dialog" role="document">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title">Actualizar Stock</h5>
                        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                            <span aria-hidden="true">&times;</span>
                        </button>
                    </div>
                    <form id="stockForm" action="${pageContext.request.contextPath}/ProductoControlador?accion=actualizarStock" method="POST">
                        <input type="hidden" id="stock_id" name="id">
                        <div class="modal-body">
                            <div class="form-group">
                                <label for="stock_actual">Stock Actual</label>
                                <input type="number" class="form-control" id="stock_actual" readonly>
                            </div>
                            <div class="form-group">
                                <label for="cantidad">Cantidad a agregar *</label>
                                <input type="number" class="form-control" id="cantidad" name="cantidad" 
                                       min="1" required>
                            </div>
                            <div class="form-group">
                                <label for="stock_nuevo">Nuevo Stock</label>
                                <input type="number" class="form-control" id="stock_nuevo" readonly>
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

        <!-- Modal Confirmación -->
        <div class="modal fade" id="confirmModal" tabindex="-1" role="dialog" aria-hidden="true">
            <div class="modal-dialog" role="document">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title" id="confirmModalTitle">Confirmar Acción</h5>
                        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                            <span aria-hidden="true">&times;</span>
                        </button>
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

        <!-- Modal Nueva Marca -->
        <div class="modal fade" id="nuevaMarcaModal" tabindex="-1" role="dialog" aria-hidden="true">
            <div class="modal-dialog" role="document">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title">Crear Nueva Marca</h5>
                        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                            <span aria-hidden="true">&times;</span>
                        </button>
                    </div>
                    <form id="nuevaMarcaForm">
                        <div class="modal-body">
                            <div class="form-group">
                                <label for="nuevaMarcaNombre">Nombre de la Marca *</label>
                                <input type="text" class="form-control" id="nuevaMarcaNombre" required
                                       maxlength="50" pattern="[A-Za-z0-9áéíóúÁÉÍÓÚñÑ\s\-]+" 
                                       title="Solo letras, números y espacios">
                            </div>
                        </div>
                        <div class="modal-footer">
                            <button type="button" class="btn btn-secondary" data-dismiss="modal">Cancelar</button>
                            <button type="submit" class="btn btn-primary">Crear Marca</button>
                        </div>
                    </form>
                </div>
            </div>
        </div>

        <script src="${pageContext.request.contextPath}/js/jquery-3.7.1.min.js"></script>
        <script src="${pageContext.request.contextPath}/js/bootstrap.min.js"></script>
        <script src="${pageContext.request.contextPath}/js/dashboard.js"></script>
        <script src="https://cdn.jsdelivr.net/npm/select2@4.1.0-rc.0/dist/js/select2.min.js"></script>
        <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
        <script>
$(document).ready(function () {
   // Función para destruir Select2 antes de reinicializar
   function destroySelect2InModal(modalId) {
       $(modalId + ' .select2').each(function() {
           if ($(this).hasClass('select2-hidden-accessible')) {
               $(this).select2('destroy');
           }
       });
   }

   // Función para inicializar Select2 específicamente para modales
   function initSelect2InModal(modalId) {
    $(modalId + ' .select2').select2({
        placeholder: "Seleccione una opción",
        allowClear: true,
        dropdownParent: $(modalId), // Puntero directo al modal
        width: '100%'
    });
}

   // Inicializar Select2 para filtros (fuera de modales)
   $('.filter-card .select2').select2({
       placeholder: "Seleccione una opción",
       allowClear: true,
       width: '100%'
   });

   // Mostrar nombre de archivo en input file
   $('.custom-file-input').on('change', function () {
       let fileName = $(this).val().split('\\').pop();
       $(this).next('.custom-file-label').addClass("selected").html(fileName);

       // Agregar clase visual cuando hay archivo
       $(this).closest('.file-upload-area').addClass('has-file');
   });

   // Mejorar el área de upload de archivos
   function setupFileUpload(inputId, areaId) {
       const $input = $(inputId);
       const $area = $(areaId);

       $area.on('click', function () {
           $input.click();
       });

       $area.on('dragover', function (e) {
           e.preventDefault();
           $(this).addClass('dragover');
       });

       $area.on('dragleave', function (e) {
           e.preventDefault();
           $(this).removeClass('dragover');
       });

       $area.on('drop', function (e) {
           e.preventDefault();
           $(this).removeClass('dragover');

           const files = e.originalEvent.dataTransfer.files;
           if (files.length > 0) {
               $input[0].files = files;
               $input.trigger('change');
           }
       });
   }

   // Manejar el botón de nuevo producto
   $('#btnNuevoProducto').click(function () {
       $('#nuevoProductoForm')[0].reset();
       $('#nuevoProductoModal').modal('show');
   });

   // Evento cuando se muestra el modal de nuevo producto
   $('#nuevoProductoModal').on('shown.bs.modal', function () {
       // Esperar un poco más para que el modal se renderice completamente
       setTimeout(function() {
           initSelect2InModal('#nuevoProductoModal');
       }, 500);
       $(this).find('input[name="nombre"]').focus();
   });

   // Evento cuando se oculta el modal de nuevo producto
   $('#nuevoProductoModal').on('hidden.bs.modal', function () {
       destroySelect2InModal('#nuevoProductoModal');
   });

   // Evento cuando se muestra el modal de editar producto
   $('#editarProductoModal').on('shown.bs.modal', function () {
       setTimeout(function() {
           initSelect2InModal('#editarProductoModal');
       }, 500);
   });

   // Evento cuando se oculta el modal de editar producto
   $('#editarProductoModal').on('hidden.bs.modal', function () {
       destroySelect2InModal('#editarProductoModal');
   });

   // Manejar marcas nuevas con mejor control
   $(document).on('select2:select', '#marca, #edit_marca', function (e) {
       const marcaSeleccionada = e.params.data.id;
       const $select = $(this);
       const marcasExistentes = [];
       
       $select.find('option').each(function() {
           if ($(this).val() !== '') {
               marcasExistentes.push($(this).val());
           }
       });

       if (marcaSeleccionada && !marcasExistentes.includes(marcaSeleccionada)) {
           $('#nuevaMarcaNombre').val(marcaSeleccionada);
           $('#nuevaMarcaModal').modal('show');

           // Prevenir que se seleccione hasta que se confirme
           $select.val(null).trigger('change');
       }
   });

   // Crear nueva marca
   $('#nuevaMarcaForm').submit(function (e) {
       e.preventDefault();
       const nombreMarca = $('#nuevaMarcaNombre').val().trim();

       if (nombreMarca) {
           const $btn = $(this).find('[type="submit"]');
           $btn.addClass('btn-loading').prop('disabled', true);

           $.post('${pageContext.request.contextPath}/MarcaControlador?accion=guardar', {
               nombre: nombreMarca,
               estado: 'activo'
           }, function (response) {
               if (response.exito) {
                   // Agregar la nueva marca a todos los selects de marca
                   const newOption = new Option(nombreMarca, nombreMarca, true, true);
                   $('#marca, #edit_marca').each(function () {
                       $(this).append(newOption.cloneNode(true));
                   });

                   // Seleccionar la nueva marca en el select activo
                   $('#marca').val(nombreMarca).trigger('change');

                   $('#nuevaMarcaModal').modal('hide');
                   Swal.fire('Éxito', 'Marca creada correctamente', 'success');
               } else {
                   Swal.fire('Error', 'No se pudo crear la marca', 'error');
               }
           }).fail(function () {
               Swal.fire('Error', 'Error al comunicarse con el servidor', 'error');
           }).always(function () {
               $btn.removeClass('btn-loading').prop('disabled', false);
           });
       }
   });

   // Editar producto
   $('.btn-editar').click(function () {
       const id = $(this).data('id');
       const $btn = $(this);

       $btn.prop('disabled', true);

       $.get('${pageContext.request.contextPath}/ProductoControlador?accion=editar&id=' + id, function (data) {
           $('#edit_id').val(data.id);
           $('#edit_nombre').val(data.nombres);
           $('#edit_descripcion').val(data.descripcion);
           $('#edit_precio').val(data.precio);

           // Mostrar imagen actual
           if (data.id) {
               const imgSrc = '${pageContext.request.contextPath}/ControladorIMG?id=' + data.id;
               $('#imagen-actual').attr('src', imgSrc);
               $('#imagen-actual-container').show();
           } else {
               $('#imagen-actual-container').hide();
           }

           // Mostrar el modal
           $('#editarProductoModal').modal('show');

           // Establecer valores de select después de que el modal se muestre y Select2 esté inicializado
           $('#editarProductoModal').one('shown.bs.modal', function () {
               setTimeout(function() {
                   initSelect2InModal('#editarProductoModal');
                   
                   // Esperar otro poco para establecer los valores
                   setTimeout(function() {
                       $('#edit_marca').val(data.nombreMarca).trigger('change');
                       $('#edit_categoria').val(data.nombreCategoria).trigger('change');
                   }, 200);
               }, 500);
           });

       }).fail(function () {
           Swal.fire('Error', 'No se pudo cargar la información del producto', 'error');
       }).always(function () {
           $btn.prop('disabled', false);
       });
   });

   // Desactivar producto
   $('.btn-desactivar').click(function () {
       const id = $(this).data('id');
       $('#confirmModalTitle').html('<i class="fas fa-times-circle" style="color: #dc3545"></i> Confirmar Desactivación');
       $('#confirmModalBody').text('¿Está seguro que desea desactivar este producto?');
       $('#btn-confirmar').removeClass('btn-success').addClass('btn-danger')
               .attr('href', '${pageContext.request.contextPath}/ProductoControlador?accion=eliminar&id=' + id);
       $('#confirmModal').modal('show');
   });

   // Activar producto
   $('.btn-activar').click(function () {
       const id = $(this).data('id');
       $('#confirmModalTitle').html('<i class="fas fa-check-circle" style="color: #28a745"></i> Confirmar Activación');
       $('#confirmModalBody').text('¿Está seguro que desea activar este producto?');
       $('#btn-confirmar').removeClass('btn-danger').addClass('btn-success')
               .attr('href', '${pageContext.request.contextPath}/ProductoControlador?accion=activar&id=' + id);
       $('#confirmModal').modal('show');
   });

   // Actualizar stock con mejor UX
   $('.btn-stock').click(function () {
       const id = $(this).data('id');
       const stockActual = parseInt($(this).data('stock'));

       $('#stock_id').val(id);
       $('#stock_actual').val(stockActual);
       $('#cantidad').val('');
       $('#stock_nuevo').val(stockActual);

       // Actualizar display visual del stock
       updateStockDisplay(stockActual, 0);

       // Calcular nuevo stock cuando cambia la cantidad
       $('#cantidad').off('input').on('input', function () {
           const cantidad = parseInt($(this).val()) || 0;
           const nuevoStock = stockActual + cantidad;
           $('#stock_nuevo').val(nuevoStock);
           updateStockDisplay(stockActual, cantidad);
       });

       $('#stockModal').modal('show');
   });

   function updateStockDisplay(stockActual, cantidad) {
       const nuevoStock = stockActual + cantidad;

       $('.stock-item.current .stock-item-value').text(stockActual);
       $('.stock-item.add .stock-item-value').text('+' + cantidad);
       $('.stock-item.new .stock-item-value').text(nuevoStock);
   }

   // Validación mejorada del formulario de nuevo producto
   $('#nuevoProductoForm').submit(function (e) {
       let isValid = true;
       const $form = $(this);

       // Limpiar validaciones anteriores
       $form.find('.is-invalid').removeClass('is-invalid');
       $form.find('.invalid-feedback').remove();

       // Validar campos requeridos
       $form.find('[required]').each(function () {
           if (!$(this).val().trim()) {
               $(this).addClass('is-invalid');
               $(this).after('<div class="invalid-feedback">Este campo es obligatorio</div>');
               isValid = false;
           }
       });

       // Validar imagen
       const imagen = $('#imagen')[0].files[0];
       if (!imagen) {
           $('#imagen').addClass('is-invalid');
           $('#imagen').after('<div class="invalid-feedback">Debe seleccionar una imagen</div>');
           isValid = false;
       } else if (imagen.size > 2 * 1024 * 1024) {
           $('#imagen').addClass('is-invalid');
           $('#imagen').after('<div class="invalid-feedback">La imagen no debe superar los 2MB</div>');
           isValid = false;
       }

       // Validar precio
       const precio = parseFloat($('#precio').val());
       if (precio <= 0) {
           $('#precio').addClass('is-invalid');
           $('#precio').after('<div class="invalid-feedback">El precio debe ser mayor a 0</div>');
           isValid = false;
       }

       if (!isValid) {
           e.preventDefault();
           // Hacer scroll al primer error
           const firstError = $form.find('.is-invalid').first();
           if (firstError.length) {
               firstError[0].scrollIntoView({behavior: 'smooth', block: 'center'});
               firstError.focus();
           }
           return false;
       }

       // Mostrar loading en el botón
       const $submitBtn = $form.find('[type="submit"]');
       $submitBtn.addClass('btn-loading').prop('disabled', true);

       return true;
   });

   // Validación del formulario de edición
   $('#editarProductoForm').submit(function (e) {
       let isValid = true;
       const $form = $(this);

       // Limpiar validaciones anteriores
       $form.find('.is-invalid').removeClass('is-invalid');
       $form.find('.invalid-feedback').remove();

       // Validar precio
       const precio = parseFloat($('#edit_precio').val());
       if (precio <= 0) {
           $('#edit_precio').addClass('is-invalid');
           $('#edit_precio').after('<div class="invalid-feedback">El precio debe ser mayor a 0</div>');
           isValid = false;
       }

       const imagen = $('#edit_imagen')[0].files[0];
       if (imagen && imagen.size > 2 * 1024 * 1024) {
           $('#edit_imagen').addClass('is-invalid');
           $('#edit_imagen').after('<div class="invalid-feedback">La imagen no debe superar los 2MB</div>');
           isValid = false;
       }

       if (!isValid) {
           e.preventDefault();
           return false;
       }

       // Mostrar loading en el botón
       const $submitBtn = $form.find('[type="submit"]');
       $submitBtn.addClass('btn-loading').prop('disabled', true);

       return true;
   });

   // Filtrar productos
   $('#filtroForm').submit(function (e) {
       e.preventDefault();

       const nombre = $('#filtroNombre').val();
       const marca = $('#filtroMarca').val();
       const categoria = $('#filtroCategoria').val();
       const stockMin = $('#filtroStockMin').val();
       const stockMax = $('#filtroStockMax').val();

       // Mostrar loading
       showLoading();

       // Redirigir con los parámetros de filtro
       window.location.href = '${pageContext.request.contextPath}/ProductoControlador?accion=filtrar&nombre=' +
               encodeURIComponent(nombre) + '&marca=' + encodeURIComponent(marca) +
               '&categoria=' + encodeURIComponent(categoria) + '&stockMin=' + stockMin +
               '&stockMax=' + stockMax;
   });

   // Resetear filtros
   $('#btnResetFiltros').click(function () {
       $('#filtroForm')[0].reset();
       $('.filter-card .select2').val(null).trigger('change');
       showLoading();
       window.location.href = '${pageContext.request.contextPath}/ProductoControlador';
   });

   // Funciones de utilidad
   function showLoading() {
       if ($('.loading-overlay').length === 0) {
           $('body').append(`
               <div class="loading-overlay" style="
                   position: fixed;
                   top: 0;
                   left: 0;
                   width: 100%;
                   height: 100%;
                   background: rgba(255, 255, 255, 0.9);
                   z-index: 9999;
                   display: flex;
                   justify-content: center;
                   align-items: center;
               ">
                   <div class="loading-spinner" style="
                       width: 40px;
                       height: 40px;
                       border: 4px solid #f3f3f3;
                       border-top: 4px solid #007bff;
                       border-radius: 50%;
                       animation: spin 1s linear infinite;
                   "></div>
               </div>
           `);
       }
   }

   function hideLoading() {
       $('.loading-overlay').remove();
   }

   // Agregar estilos de animación si no existen
   if (!document.querySelector('style[data-loading-animation]')) {
       const style = document.createElement('style');
       style.setAttribute('data-loading-animation', 'true');
       style.textContent = `
           @keyframes spin {
               0% { transform: rotate(0deg); }
               100% { transform: rotate(360deg); }
           }
       `;
       document.head.appendChild(style);
   }

   // Mejorar tooltips
   $('[data-toggle="tooltip"], .btn-action').tooltip({
       placement: 'top',
       trigger: 'hover'
   });

   // Mejorar visualización de stock bajo
   $('.product-stock.low').each(function () {
       $(this).attr('title', 'Stock bajo - Considerar reabastecer');
   });

   // Auto-dismiss alerts después de 5 segundos
   setTimeout(function () {
       $('.alert').fadeOut();
   }, 5000);

   // Limpiar loading overlay cuando la página se carga completamente
   $(window).on('load', function () {
       hideLoading();
   });

   // Setup file upload areas
   setupFileUpload('#imagen', '.file-upload-area');
   setupFileUpload('#edit_imagen', '.file-upload-area');

   // Prevenir que los dropdowns de Select2 se abran fuera del viewport del modal
   $(document).on('select2:open', function(e) {
       const $modal = $(e.target).closest('.modal');
       if ($modal.length > 0) {
           const $dropdown = $('.select2-dropdown');
           $dropdown.css({
               'z-index': '1072',
               'position': 'absolute'
           });
       }
   });

   // Asegurar que Select2 se cierre cuando se cierra el modal
   $('.modal').on('hidden.bs.modal', function() {
       $('.select2-dropdown').remove();
       $('.select2-container--open').removeClass('select2-container--open');
   });
});

        </script>
    </body>
</html>