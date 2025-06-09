<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard - SERCOYT</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/bootstrap.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/dashboard.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
</head>
<body>
    <div class="dashboard-container">
        <!-- Menú lateral -->
        <%@include file="/WEB-INF/views/includes/menuDashboard.jsp" %>

        <!-- Contenido principal -->
        <div class="dashboard-content">
            <!-- Barra superior -->
            <div class="dashboard-topbar">
                <div class="topbar-left">
                    <button class="sidebar-toggle">
                        <i class="fas fa-bars"></i>
                    </button>
                    <h4>Dashboard</h4>
                </div>
                <div class="topbar-right">
                    <div class="user-dropdown">
                        <button class="user-btn">
                            <i class="fas fa-user-circle"></i>
                            <span>${sessionScope.usuario.nombre} ${sessionScope.usuario.apellido}</span>
                            <i class="fas fa-caret-down"></i>
                        </button>
                        <div class="dropdown-content">
                            <a href="${pageContext.request.contextPath}/Controlador?accion=laptops">
                                <i class="fas fa-store"></i> Ir a la tienda
                            </a>
                            <a href="${pageContext.request.contextPath}/UsuarioControlador?accion=logout">
                                <i class="fas fa-sign-out-alt"></i> Cerrar sesión
                            </a>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Contenido del dashboard -->
            <div class="dashboard-main">
                <div class="dashboard-cards">
                    <div class="card">
                        <div class="card-icon bg-primary">
                            <i class="fas fa-boxes"></i>
                        </div>
                        <div class="card-info">
                            <h3>${totalProductos}</h3>
                            <p>Productos</p>
                        </div>
                    </div>
                    <div class="card">
                        <div class="card-icon bg-success">
                            <i class="fas fa-users"></i>
                        </div>
                        <div class="card-info">
                            <h3>${totalClientes}</h3>
                            <p>Clientes</p>
                        </div>
                    </div>
                    <div class="card">
                        <div class="card-icon bg-warning">
                            <i class="fas fa-shopping-cart"></i>
                        </div>
                        <div class="card-info">
                            <h3>${ventasSemana}</h3>
                            <p>Ventas esta semana</p>
                        </div>
                    </div>
                    <div class="card">
                        <div class="card-icon bg-danger">
                            <i class="fas fa-chart-line"></i>
                        </div>
                        <div class="card-info">
                            <h3>S/. ${ingresosSemana}</h3>
                            <p>Ingresos esta semana</p>
                        </div>
                    </div>
                </div>

                <div class="dashboard-section">
                    <div class="section-header">
                        <h4>Últimas ventas</h4>
                        <a href="#" class="btn-view-all">Ver todas</a>
                    </div>
                    <div class="section-content">
                        <table class="table table-striped">
                            <thead>
                                <tr>
                                    <th>ID</th>
                                    <th>Fecha</th>
                                    <th>Cliente</th>
                                    <th>Total</th>
                                    <th>Estado</th>
                                </tr>
                            </thead>
                            <tbody>
                                <!-- Aquí irían las últimas ventas -->
                                <tr>
                                    <td colspan="5" class="text-center">No hay ventas recientes</td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script src="${pageContext.request.contextPath}/js/jquery-3.7.1.min.js"></script>
    <script src="${pageContext.request.contextPath}/js/bootstrap.min.js"></script>
    <script src="${pageContext.request.contextPath}/js/dashboard.js"></script>
</body>
</html>