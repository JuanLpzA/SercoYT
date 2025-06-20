<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html lang="es">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Productos - SERCOYT</title>
        <link rel="icon" type="image/png" href="${pageContext.request.contextPath}/img/logo.png">
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
                                        <select class="form-control select2" id="marca" name="marca" required data-tags="true">
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
                                        <div class="file-upload-area" id="nuevoProductoUploadArea">
                                            <div class="file-upload-icon">
                                                <i class="fas fa-cloud-upload-alt"></i>
                                            </div>
                                            <div class="file-upload-text">
                                                Haz clic aquí o arrastra una imagen
                                            </div>
                                            <div class="file-upload-subtext">
                                                JPG, PNG, JPEG - Máximo 2MB
                                            </div>
                                            <div class="image-preview-container" id="nuevoProductoPreview" style="display: none;">
                                                <img id="nuevoProductoPreviewImage" src="" alt="Vista previa">
                                            </div>
                                        </div>
                                        <input type="file" class="form-control" id="imagen" name="imagen" 
                                               accept="image/*" required style="display: none;">
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="modal-footer">
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
       
                                        <select class="form-control select2" id="edit_marca" name="marca" required data-tags="true">
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
                                        <div class="file-upload-area" onclick="if (document.getElementById('edit_imagen').offsetParent !== null) document.getElementById('edit_imagen').onclick()">
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
                    </div>
                    <div class="modal-body" id="confirmModalBody">
                        ¿Está seguro que desea realizar esta acción?
                    </div>
                    <div class="modal-footer">
                        <a href="#" class="btn btn-danger" id="btn-confirmar">Confirmar</a>
                    </div>
                </div>
            </div>
        </div>

        <!-- Modal Nueva Marca - Versión mejorada -->
<div class="modal fade" id="nuevaMarcaModal" tabindex="-1" role="dialog" aria-hidden="true">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title">
                    <i class="fas fa-tag"></i> Crear Nueva Marca
                </h5>
            </div>
            <form id="nuevaMarcaForm">
                <div class="modal-body">
                    <div class="form-group">
                        <label for="nuevaMarcaNombre">Nombre de la Marca *</label>
                        <input type="text" class="form-control" id="nuevaMarcaNombre" required
                               maxlength="50" pattern="[A-Za-z0-9áéíóúÁÉÍÓÚñÑ\s\-]+" 
                               title="Solo letras, números y espacios">
                        <input type="hidden" id="origenMarca" value="">
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

<script src="${pageContext.request.contextPath}/js/jquery-3.7.1.min.js"></script>
<script src="${pageContext.request.contextPath}/js/bootstrap.min.js"></script>
<script src="${pageContext.request.contextPath}/js/dashboard.js"></script>
<script src="https://cdn.jsdelivr.net/npm/select2@4.1.0-rc.0/dist/js/select2.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
<script>
    // Contexto de la aplicación para JS
    const AppContext = {
        path: '${pageContext.request.contextPath}',
        messages: {
            imageSizeError: 'La imagen no debe superar los 2MB',
            imageTypeError: 'El archivo debe ser una imagen',
            requiredField: 'Este campo es obligatorio',
            invalidPrice: 'El precio debe ser mayor a 0',
            brandCreated: 'Marca creada correctamente',
            brandError: 'No se pudo crear la marca'
        },
        endpoints: {
            product: {
                edit: '${pageContext.request.contextPath}/ProductoControlador?accion=editar&id=',
                update: '${pageContext.request.contextPath}/ProductoControlador?accion=actualizar',
                save: '${pageContext.request.contextPath}/ProductoControlador?accion=guardar',
                filter: '${pageContext.request.contextPath}/ProductoControlador?accion=filtrar',
                activate: '${pageContext.request.contextPath}/ProductoControlador?accion=activar&id=',
                deactivate: '${pageContext.request.contextPath}/ProductoControlador?accion=eliminar&id=',
                stock: '${pageContext.request.contextPath}/ProductoControlador?accion=actualizarStock'
            },
            brand: {
                save: '${pageContext.request.contextPath}/MarcaControlador?accion=guardar'
            },
            image: {
                get: '${pageContext.request.contextPath}/ControladorIMG?id='
            }
        }
    };
</script>
<script src="${pageContext.request.contextPath}/js/productos.js"></script>
    </body>
</html>