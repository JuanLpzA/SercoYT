<%-- 
    Document   : ventapresencialinicio
    Created on : 10 jul. 2025, 16:24:00
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
        <title>Venta Presencial - SERCOYT</title>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/bootstrap.min.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/dashboard.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/ventapresencial.css">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    </head>
    <body>
        <div class="dashboard-container">1
            <%@include file="/WEB-INF/views/includes/menuDashboard.jsp" %>

            <div class="dashboard-content">
                <div class="dashboard-topbar">
                    <div class="topbar-left">
                        <button class="sidebar-toggle">
                            <i class="fas fa-bars"></i>
                        </button>
                        <h4>Venta Presencial</h4>
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


                <div class="dashboard-main">
                    <div class="section-header">
                        <h4>Ultimas Ventas Presenciales</h4>
                        <div class="header-actions">
                            <button class="btn btn-primary" id="btnNuevoProducto">
                                <i class="fas fa-plus"></i> Nuevo Venta
                            </button>
                        </div>
                    </div>
                </div>
            </div>
        </div>
                                    
        <script>
            const AppContext = {
                path: '${pageContext.request.contextPath}',
                endpoints: {
                    producto: {
                        nuevo: '${pageContext.request.contextPath}/VentaPresencialControlador?accion=nuevaventa'
                    }
                }
            };

            document.getElementById("btnNuevoProducto").addEventListener("click", function () {
                window.location.href = AppContext.endpoints.producto.nuevo;
            });
        </script>                            
    </body>
</html>
