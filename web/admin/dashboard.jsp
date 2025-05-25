<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>SercoYT - Dashboard Administrativo</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/dashboard.css">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://use.fontawesome.com/releases/v5.15.4/css/all.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/animate.css/4.1.1/animate.min.css">
</head>
<body>
    <!-- Verificar sesión -->
    <c:if test="${empty sessionScope.usuario}">
        <c:redirect url="${pageContext.request.contextPath}/UsuarioControlador?accion=login"/>
    </c:if>

    <!-- Sidebar Navigation -->
    <nav class="sidebar" id="sidebar">
        <div class="sidebar-header">
            <div class="logo-container">
                <img src="${pageContext.request.contextPath}/img/logo.png" alt="SercoYT" class="logo">
                <span class="brand-name">SercoYT Admin</span>
            </div>
            <button class="sidebar-toggle" id="sidebarToggle">
                <i class="fas fa-bars"></i>
            </button>
        </div>

        <div class="sidebar-menu">
            <!-- Sección Principal -->
            <div class="menu-section">
                <h4 class="menu-title">Principal</h4>
                <ul class="menu-list">
                    <li class="menu-item active" data-section="dashboard">
                        <a href="#" class="menu-link">
                            <i class="fas fa-tachometer-alt"></i>
                            <span>Dashboard</span>
                        </a>
                    </li>
                </ul>
            </div>

            <!-- Sección Vendedor -->
            <div class="menu-section">
                <h4 class="menu-title">Operaciones</h4>
                <ul class="menu-list">
                    <li class="menu-item" data-section="vender">
                        <a href="#" class="menu-link">
                            <i class="fas fa-cash-register"></i>
                            <span>Vender</span>
                        </a>
                    </li>
                    <li class="menu-item" data-section="productos">
                        <a href="#" class="menu-link">
                            <i class="fas fa-box"></i>
                            <span>Productos</span>
                        </a>
                    </li>
                    <li class="menu-item" data-section="clientes">
                        <a href="#" class="menu-link">
                            <i class="fas fa-users"></i>
                            <span>Clientes</span>
                        </a>
                    </li>
                </ul>
            </div>

            <!-- Sección Administrador -->
            <c:if test="${sessionScope.usuario.tipoUsuario == 'administrador'}">
                <div class="menu-section admin-section">
                    <h4 class="menu-title">Administración</h4>
                    <ul class="menu-list">
                        <li class="menu-item" data-section="reportes">
                            <a href="#" class="menu-link">
                                <i class="fas fa-chart-line"></i>
                                <span>Reportes</span>
                            </a>
                        </li>
                        <li class="menu-item" data-section="cuentas">
                            <a href="#" class="menu-link">
                                <i class="fas fa-user-cog"></i>
                                <span>Cuentas</span>
                            </a>
                        </li>
                        <li class="menu-item" data-section="estadisticas">
                            <a href="#" class="menu-link">
                                <i class="fas fa-analytics"></i>
                                <span>Estadísticas</span>
                            </a>
                        </li>
                        <li class="menu-item" data-section="notificaciones">
                            <a href="#" class="menu-link">
                                <i class="fas fa-bell"></i>
                                <span>Notificaciones</span>
                                <span class="notification-badge" id="stockNotifBadge" style="display: none;">0</span>
                            </a>
                        </li>
                    </ul>
                </div>
            </c:if>
        </div>
    </nav>

    <!-- Main Content -->
    <main class="main-content">
        <!-- Top Header -->
        <header class="top-header">
            <div class="header-left">
                <button class="mobile-toggle" id="mobileToggle">
                    <i class="fas fa-bars"></i>
                </button>
                <h1 class="page-title" id="pageTitle">Dashboard</h1>
            </div>
            <div class="header-right">
                <div class="notification-icon">
                    <i class="fas fa-bell"></i>
                    <span class="notification-count" id="notificationCount" style="display: none;">0</span>
                </div>
                <div class="user-menu" id="userMenu">
                    <div class="user-avatar">
                        <i class="fas fa-user"></i>
                    </div>
                    <div class="user-info">
                        <span class="user-name">${sessionScope.usuario.nombre} ${sessionScope.usuario.apellido}</span>
                        <span class="user-role">${sessionScope.usuario.tipoUsuario}</span>
                    </div>
                    <i class="fas fa-chevron-down dropdown-arrow"></i>
                    <div class="dropdown-menu" id="dropdownMenu">
                        <a href="#" class="dropdown-item">
                            <i class="fas fa-user"></i>
                            Mi Cuenta
                        </a>
                        <a href="${pageContext.request.contextPath}/index.jsp" class="dropdown-item">
                            <i class="fas fa-store"></i>
                            Volver a la Tienda
                        </a>
                        <a href="${pageContext.request.contextPath}/UsuarioControlador?accion=logout" class="dropdown-item logout">
                            <i class="fas fa-sign-out-alt"></i>
                            Cerrar Sesión
                        </a>
                    </div>
                </div>
            </div>
        </header>

        <!-- Content Area -->
        <div class="content-area">
            <!-- Dashboard Section -->
            <section id="dashboard-section" class="content-section active">
                <div class="dashboard-grid">
                    <div class="stats-card">
                        <div class="stats-icon stats-primary">
                            <i class="fas fa-box"></i>
                        </div>
                        <div class="stats-content">
                            <h3 id="totalProducts">0</h3>
                            <p>Total Productos</p>
                        </div>
                    </div>
                    <div class="stats-card">
                        <div class="stats-icon stats-success">
                            <i class="fas fa-shopping-cart"></i>
                        </div>
                        <div class="stats-content">
                            <h3 id="totalSales">0</h3>
                            <p>Ventas del Mes</p>
                        </div>
                    </div>
                    <div class="stats-card">
                        <div class="stats-icon stats-warning">
                            <i class="fas fa-users"></i>
                        </div>
                        <div class="stats-content">
                            <h3 id="totalClients">0</h3>
                            <p>Total Clientes</p>
                        </div>
                    </div>
                    <div class="stats-card">
                        <div class="stats-icon stats-info">
                            <i class="fas fa-dollar-sign"></i>
                        </div>
                        <div class="stats-content">
                            <h3 id="monthlyRevenue">S/. 0.00</h3>
                            <p>Ingresos del Mes</p>
                        </div>
                    </div>
                </div>

                <div class="dashboard-charts">
                    <div class="chart-card">
                        <h3>Ventas por Mes</h3>
                        <canvas id="salesChart"></canvas>
                    </div>
                    <div class="chart-card">
                        <h3>Productos Más Vendidos</h3>
                        <div id="topProducts" class="top-products-list"></div>
                    </div>
                </div>
            </section>

            <!-- Vender Section -->
            <section id="vender-section" class="content-section">
                <div class="section-header">
                    <h2>Punto de Venta</h2>
                    <button class="btn btn-primary" id="newSaleBtn">
                        <i class="fas fa-plus"></i>
                        Nueva Venta
                    </button>
                </div>
                
                <div class="sale-container">
                    <div class="sale-form-card">
                        <h3>Información del Cliente</h3>
                        <form id="clientForm">
                            <div class="form-group">
                                <label for="clientDni">DNI del Cliente</label>
                                <div class="input-group">
                                    <input type="text" id="clientDni" name="clientDni" class="form-control" placeholder="Ingrese DNI" maxlength="8">
                                    <button type="button" id="searchClientBtn" class="btn btn-secondary">
                                        <i class="fas fa-search"></i>
                                    </button>
                                </div>
                            </div>
                            <div id="clientInfo" class="client-info" style="display: none;">
                                <p><strong>Nombre:</strong> <span id="clientName"></span></p>
                                <p><strong>Teléfono:</strong> <span id="clientPhone"></span></p>
                            </div>
                            <button type="button" id="newClientBtn" class="btn btn-outline" style="display: none;">
                                <i class="fas fa-user-plus"></i>
                                Registrar Nuevo Cliente
                            </button>
                        </form>
                    </div>

                    <div class="products-selection-card">
                        <h3>Selección de Productos</h3>
                        <div class="product-search">
                            <input type="text" id="productSearch" class="form-control" placeholder="Buscar productos...">
                        </div>
                        <div id="productsList" class="products-grid"></div>
                    </div>

                    <div class="sale-summary-card">
                        <h3>Resumen de Venta</h3>
                        <div id="saleItems" class="sale-items-list"></div>
                        <div class="sale-totals">
                            <div class="total-row">
                                <span>Subtotal:</span>
                                <span id="subtotal">S/. 0.00</span>
                            </div>
                            <div class="total-row">
                                <span>IGV (18%):</span>
                                <span id="igv">S/. 0.00</span>
                            </div>
                            <div class="total-row total-final">
                                <span>Total:</span>
                                <span id="total">S/. 0.00</span>
                            </div>
                        </div>
                        <div class="form-group">
                            <label for="paymentMethod">Método de Pago</label>
                            <select id="paymentMethod" class="form-control">
                                <option value="1">Efectivo</option>
                                <option value="2">Tarjeta</option>
                                <option value="3">Yape</option>
                            </select>
                        </div>
                        <button id="completeSaleBtn" class="btn btn-success btn-block" disabled>
                            <i class="fas fa-check"></i>
                            Completar Venta
                        </button>
                    </div>
                </div>
            </section>

            <!-- Productos Section -->
            <section id="productos-section" class="content-section">
                <div class="section-header">
                    <h2>Gestión de Productos</h2>
                    <button class="btn btn-primary" id="addProductBtn">
                        <i class="fas fa-plus"></i>
                        Agregar Producto
                    </button>
                </div>
                
                <div class="products-filters">
                    <div class="filter-group">
                        <select id="categoryFilter" class="form-control">
                            <option value="">Todas las Categorías</option>
                        </select>
                    </div>
                    <div class="filter-group">
                        <select id="brandFilter" class="form-control">
                            <option value="">Todas las Marcas</option>
                        </select>
                    </div>
                    <div class="filter-group">
                        <input type="text" id="productFilterSearch" class="form-control" placeholder="Buscar productos...">
                    </div>
                </div>

                <div class="products-table-container">
                    <table class="data-table" id="productsTable">
                        <thead>
                            <tr>
                                <th>ID</th>
                                <th>Imagen</th>
                                <th>Nombre</th>
                                <th>Categoría</th>
                                <th>Marca</th>
                                <th>Precio</th>
                                <th>Stock</th>
                                <th>Estado</th>
                                <th>Acciones</th>
                            </tr>
                        </thead>
                        <tbody id="productsTableBody">
                        </tbody>
                    </table>
                </div>
            </section>

            <!-- Clientes Section -->
            <section id="clientes-section" class="content-section">
                <div class="section-header">
                    <h2>Gestión de Clientes</h2>
                </div>
                
                <div class="clients-table-container">
                    <table class="data-table" id="clientsTable">
                        <thead>
                            <tr>
                                <th>ID</th>
                                <th>Nombre</th>
                                <th>Apellido</th>
                                <th>DNI</th>
                                <th>Teléfono</th>
                                <th>Acciones</th>
                            </tr>
                        </thead>
                        <tbody id="clientsTableBody">
                        </tbody>
                    </table>
                </div>
            </section>

            <!-- Reportes Section (Solo Admin) -->
            <c:if test="${sessionScope.usuario.tipoUsuario == 'administrador'}">
                <section id="reportes-section" class="content-section">
                    <div class="section-header">
                        <h2>Reportes de Ventas</h2>
                    </div>
                    
                    <div class="reports-tabs">
                        <button class="tab-btn active" data-tab="presencial">Ventas Presenciales</button>
                        <button class="tab-btn" data-tab="virtual">Ventas Virtuales</button>
                    </div>

                    <div class="tab-content active" id="presencial-tab">
                        <div class="reports-filters">
                            <input type="date" id="fechaInicio" class="form-control">
                            <input type="date" id="fechaFin" class="form-control">
                            <button class="btn btn-primary" id="filterReportsBtn">Filtrar</button>
                            <button class="btn btn-success" id="exportPdfBtn">
                                <i class="fas fa-file-pdf"></i>
                                Exportar PDF
                            </button>
                        </div>
                        <div class="reports-table-container">
                            <table class="data-table" id="presencialReportsTable">
                                <thead>
                                    <tr>
                                        <th>ID Venta</th>
                                        <th>Fecha</th>
                                        <th>Cliente</th>
                                        <th>Vendedor</th>
                                        <th>Total</th>
                                        <th>Método Pago</th>
                                        <th>Acciones</th>
                                    </tr>
                                </thead>
                                <tbody id="presencialReportsBody">
                                </tbody>
                            </table>
                        </div>
                    </div>

                    <div class="tab-content" id="virtual-tab">
                        <div class="reports-table-container">
                            <table class="data-table" id="virtualReportsTable">
                                <thead>
                                    <tr>
                                        <th>ID Venta</th>
                                        <th>Fecha</th>
                                        <th>Cliente</th>
                                        <th>Total</th>
                                        <th>Estado</th>
                                        <th>Dirección</th>
                                        <th>Acciones</th>
                                    </tr>
                                </thead>
                                <tbody id="virtualReportsBody">
                                </tbody>
                            </table>
                        </div>
                    </div>
                </section>

                <!-- Cuentas Section (Solo Admin) -->
                <section id="cuentas-section" class="content-section">
                    <div class="section-header">
                        <h2>Gestión de Cuentas</h2>
                    </div>
                    
                    <div class="accounts-table-container">
                        <table class="data-table" id="accountsTable">
                            <thead>
                                <tr>
                                    <th>ID</th>
                                    <th>Nombre</th>
                                    <th>Apellido</th>
                                    <th>DNI</th>
                                    <th>Correo</th>
                                    <th>Tipo Usuario</th>
                                    <th>Estado</th>
                                    <th>Acciones</th>
                                </tr>
                            </thead>
                            <tbody id="accountsTableBody">
                            </tbody>
                        </table>
                    </div>
                </section>

                <!-- Estadísticas Section (Solo Admin) -->
                <section id="estadisticas-section" class="content-section">
                    <div class="section-header">
                        <h2>Estadísticas Avanzadas</h2>
                    </div>
                    
                    <div class="statistics-grid">
                        <div class="chart-card">
                            <h3>Ventas por Categoría</h3>
                            <canvas id="categoryChart"></canvas>
                        </div>
                        <div class="chart-card">
                            <h3>Comparativa Mensual</h3>
                            <canvas id="monthlyComparisonChart"></canvas>
                        </div>
                        <div class="chart-card">
                            <h3>Productos Bajo Stock</h3>
                            <div id="lowStockProducts" class="low-stock-list"></div>
                        </div>
                        <div class="chart-card">
                            <h3>Métodos de Pago</h3>
                            <canvas id="paymentMethodsChart"></canvas>
                        </div>
                    </div>
                </section>

                <!-- Notificaciones Section (Solo Admin) -->
                <section id="notificaciones-section" class="content-section">
                    <div class="section-header">
                        <h2>Notificaciones de Stock</h2>
                        <button class="btn btn-secondary" id="markAllReadBtn">
                            <i class="fas fa-check-double"></i>
                            Marcar Todas como Leídas
                        </button>
                    </div>
                    
                    <div id="notificationsList" class="notifications-list">
                    </div>
                </section>
            </c:if>
        </div>
    </main>

    <!-- Modals -->
    <!-- Modal Nuevo Cliente -->
    <div id="newClientModal" class="modal">
        <div class="modal-content">
            <div class="modal-header">
                <h3>Registrar Nuevo Cliente</h3>
                <span class="close" id="closeClientModal">&times;</span>
            </div>
            <form id="newClientForm">
                <div class="form-group">
                    <label for="newClientName">Nombre *</label>
                    <input type="text" id="newClientName" name="nombre" class="form-control" required>
                </div>
                <div class="form-group">
                    <label for="newClientLastname">Apellido *</label>
                    <input type="text" id="newClientLastname" name="apellido" class="form-control" required>
                </div>
                <div class="form-group">
                    <label for="newClientDni">DNI *</label>
                    <input type="text" id="newClientDni" name="dni" class="form-control" maxlength="8" required>
                </div>
                <div class="form-group">
                    <label for="newClientPhone">Teléfono</label>
                    <input type="text" id="newClientPhone" name="telefono" class="form-control" maxlength="9">
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" id="cancelClientBtn">Cancelar</button>
                    <button type="submit" class="btn btn-primary">Registrar Cliente</button>
                </div>
            </form>
        </div>
    </div>

    <!-- Modal Producto -->
    <div id="productModal" class="modal">
        <div class="modal-content modal-large">
            <div class="modal-header">
                <h3 id="productModalTitle">Agregar Producto</h3>
                <span class="close" id="closeProductModal">&times;</span>
            </div>
            <form id="productForm" enctype="multipart/form-data">
                <input type="hidden" id="productId" name="idProducto">
                <div class="form-row">
                    <div class="form-group">
                        <label for="productName">Nombre del Producto *</label>
                        <input type="text" id="productName" name="nombre" class="form-control" required>
                    </div>
                    <div class="form-group">
                        <label for="productPrice">Precio *</label>
                        <input type="number" id="productPrice" name="precio" class="form-control" step="0.01" min="0" required>
                    </div>
                </div>
                <div class="form-group">
                    <label for="productDescription">Descripción</label>
                    <textarea id="productDescription" name="descripcion" class="form-control" rows="3"></textarea>
                </div>
                <div class="form-row">
                    <div class="form-group">
                        <label for="productCategory">Categoría *</label>
                        <select id="productCategory" name="idCategoria" class="form-control" required>
                            <option value="">Seleccionar categoría</option>
                        </select>
                    </div>
                    <div class="form-group">
                        <label for="productBrand">Marca *</label>
                        <select id="productBrand" name="idMarca" class="form-control" required>
                            <option value="">Seleccionar marca</option>
                        </select>
                    </div>
                </div>
                <div class="form-row">
                    <div class="form-group">
                        <label for="productStock">Stock *</label>
                        <input type="number" id="productStock" name="stock" class="form-control" min="0" required>
                    </div>
                    <div class="form-group">
                        <label for="productImage">Imagen del Producto</label>
                        <input type="file" id="productImage" name="imagen" class="form-control" accept="image/*">
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" id="cancelProductBtn">Cancelar</button>
                    <button type="submit" class="btn btn-primary">Guardar Producto</button>
                </div>
            </form>
        </div>
    </div>

    <!-- Scripts -->
    <script src="${pageContext.request.contextPath}/js/jquery-3.7.1.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <script src="https://unpkg.com/sweetalert/dist/sweetalert.min.js"></script>
    <script src="${pageContext.request.contextPath}/js/dashboard.js"></script>
</body>
</html>