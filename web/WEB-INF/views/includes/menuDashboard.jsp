<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<div class="dashboard-sidebar">
    <div class="sidebar-header">
        <img src="${pageContext.request.contextPath}/img/logo.png" alt="Logo" class="logo">
        <h3>SERCOYT</h3>
    </div>
    <ul class="sidebar-menu">
        <li class="${pageContext.request.requestURI.contains('dashboard') ? 'active' : ''}">
            <a href="${pageContext.request.contextPath}/DashboardControlador">
                <i class="fas fa-tachometer-alt"></i> Dashboard
            </a>
        </li>
        <li class="${pageContext.request.requestURI.contains('ventapresencial') ? 'active' : ''}">
            <a href="${pageContext.request.contextPath}/VentaPresencialControlador">
                <i class="fas fa-credit-card"></i> Venta Presencial
            </a>
        </li>
        <li class="${pageContext.request.requestURI.contains('Producto') ? 'active' : ''}">
            <a href="${pageContext.request.contextPath}/ProductoControlador">
                <i class="fas fa-box"></i> Productos
            </a>
        </li>
        <li class="${pageContext.request.requestURI.contains('Marca') ? 'active' : ''}">
            <a href="${pageContext.request.contextPath}/MarcaControlador">
                <i class="fas fa-tags"></i> Marcas
            </a>
        </li>
        <li class="${pageContext.request.requestURI.contains('Categoria') ? 'active' : ''}">
            <a href="${pageContext.request.contextPath}/CategoriaControlador">
                <i class="fas fa-list"></i> Categorías
            </a>
        </li>
        <li class="${pageContext.request.requestURI.contains('reportes') ? 'active' : ''}">
            <a href="#">
                <i class="fas fa-chart-line"></i> Reportes
            </a>
        </li>
        <li class="${pageContext.request.requestURI.contains('clientes') ? 'active' : ''}">
            <a href="${pageContext.request.contextPath}/ClienteControlador">
                <i class="fas fa-users"></i> Clientes
            </a>
        </li>
        <c:if test="${sessionScope.usuario.tipoUsuario == 'administrador'}">
            <li class="${pageContext.request.requestURI.contains('cuentas') ? 'active' : ''}">
                <a href="#">
                    <i class="fas fa-user-cog"></i> Cuentas
                </a>
            </li>
            <li class="${pageContext.request.requestURI.contains('estadisticas') ? 'active' : ''}">
                <a href="#">
                    <i class="fas fa-chart-pie"></i> Estadísticas
                </a>
            </li>
            <li class="${pageContext.request.requestURI.contains('notificaciones') ? 'active' : ''}">
                <a href="#">
                    <i class="fas fa-bell"></i> Notificaciones
                </a>
            </li>
        </c:if>
    </ul>
</div>