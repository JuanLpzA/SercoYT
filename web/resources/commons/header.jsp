<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<div class="header-top">
    <div class="logo-container">
        <img src="${pageContext.request.contextPath}/img/logo.png" alt="SercoYT Logo" class="logo">
        <div class="logo-text">
            <h1>SercoYT</h1>
            <p>Servicio de Computadoras y Tecnología E.I.R.L</p>
        </div>
    </div>
    
    <div class="user-actions">
        <c:choose>
            <c:when test="${param.accion == 'Carrito'}">
                <div class="cart-container">
                    <a href="Controlador?accion=laptops" class="cart-btn">
                        <button class="btn-continue-shopping">Seguir Comprando</button>   
                    </a>
                </div>
            </c:when>
            <c:otherwise>
                <div class="cart-container">
                    <a href="Controlador?accion=Carrito" class="cart-btn">
                        <i class="fas fa-shopping-cart"></i>
                        <span class="cart-count">${not empty sessionScope.contador ? sessionScope.contador : 0}</span>
                    </a>
                </div>
            </c:otherwise>
        </c:choose>
        
        <div class="account-dropdown">
            <button class="account-btn">
                <i class="fas fa-user-circle"></i>
                <span>
                    <c:choose>
                        <c:when test="${not empty sessionScope.usuario}">
                            ${fn:substring(sessionScope.usuario.nombre, 0, 1)}. ${sessionScope.usuario.apellido}
                        </c:when>
                        <c:otherwise>
                            Mi Cuenta
                        </c:otherwise>
                    </c:choose>
                </span>
            </button>
            <div class="dropdown-content">
                <c:choose>
                    <c:when test="${not empty sessionScope.usuario}">
                        <a href="UsuarioControlador?accion=perfil"><i class="fas fa-user"></i> Mi Perfil</a>
                        <a href="VentaControlador?accion=misPedidos"><i class="fas fa-history"></i> Mis Pedidos</a>
                        <a href="UsuarioControlador?accion=logout"><i class="fas fa-sign-out-alt"></i> Cerrar Sesión</a>
                    </c:when>
                    <c:otherwise>
                        <a href="UsuarioControlador?accion=login"><i class="fas fa-sign-in-alt"></i> Iniciar Sesión</a>
                        <a href="UsuarioControlador?accion=nuevo"><i class="fas fa-user-plus"></i> Registrarse</a>
                        <a href="VentaControlador?accion=misPedidos"><i class="fas fa-history"></i> Mis Pedidos</a>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </div>
</div>

<nav class="main-nav">
    <ul>
        <li class="${param.accion == 'laptops' ? 'active' : ''}">
            <a href="Controlador?accion=laptops"><i class="fas fa-laptop"></i> Laptops</a>
        </li>
        <li class="${param.accion == 'componentes' ? 'active' : ''}">
            <a href="Controlador?accion=componentes"><i class="fas fa-microchip"></i> Componentes</a>
        </li>
        <li class="${param.accion == 'perifericos' ? 'active' : ''}">
            <a href="Controlador?accion=perifericos"><i class="fas fa-keyboard"></i> Periféricos</a>
        </li>
        <li class="${param.accion == 'impresoras' ? 'active' : ''}">
            <a href="Controlador?accion=impresoras"><i class="fas fa-print"></i> Impresoras</a>
        </li>
        <li class="${param.accion == 'monitores' ? 'active' : ''}">
            <a href="Controlador?accion=monitores"><i class="fas fa-tv"></i> Monitores</a>
        </li>
        <li class="${param.accion == 'computadoras' ? 'active' : ''}">
            <a href="Controlador?accion=computadoras"><i class="fas fa-desktop"></i> Computadoras</a>
        </li>
        <li>
            <a href="#"><i class="fas fa-headset"></i> Asesoría</a>
        </li>
        <li>
            <a href="#"><i class="fas fa-info-circle"></i> Conócenos</a>
        </li>
    </ul>
</nav>