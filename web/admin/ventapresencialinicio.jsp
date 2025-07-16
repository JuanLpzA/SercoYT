<%-- 
    Document   : ventapresencialinicio
    Created on : 10 jul. 2025, 16:24:00
    Author     : Arrunategui
--%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="es">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Venta Presencial - SERCOYT</title>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/bootstrap.min.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/dashboard.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/ventapresencial.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/ventapresencial-inicio.css">
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
                                <a href="${pageContext.request.contextPath}/Controlador">
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
                        <h4>Panel de Venta Presencial</h4>
                        <div class="header-actions">
                            <button class="btn btn-primary btn-nueva-venta" id="btnNuevoProducto">
                                <i class="fas fa-plus"></i> Nueva Venta
                            </button>
                        </div>
                    </div>
                    
                    <div class="main-content">
                        <!-- Columna izquierda - Tabla de ventas -->
                        <div class="left-column">
                            <div class="ventas-section">
                                <div class="section-title">
                                    <h5><i class="fas fa-history"></i> Últimas Ventas Presenciales</h5>
                                </div>
                                
                                <div class="table-container">
                                    <c:choose>
                                        <c:when test="${not empty ventas}">
                                            <table class="ventas-table">
                                                <thead>
                                                    <tr>
                                                        <th>ID</th>
                                                        <th>Fecha</th>
                                                        <th>Cliente</th>
                                                        <th>DNI</th>
                                                        <th>Tipo</th>
                                                        <th>Estado</th>
                                                        <th>Método Pago</th>
                                                        <th>Total</th>
                                                        
                                                    </tr>
                                                </thead>
                                                <tbody>
                                                    <c:forEach var="venta" items="${ventas}">
                                                        <tr>
                                                            <td><strong>#${venta.idVenta}</strong></td>
                                                            <td><fmt:formatDate value="${venta.fecha}" pattern="dd/MM/yyyy HH:mm"/></td>
                                                            <td>${venta.clienteNombre}</td>
                                                            <td>${venta.clienteDni}</td>
                                                            <td>${venta.tipoVentaNombre}</td>
                                                            <td>
                                                                <span class="status-badge status-${fn:toLowerCase(fn:replace(venta.estadoNombre, ' ', '-'))}">
                                                                    ${venta.estadoNombre}
                                                                </span>
                                                            </td>
                                                            <td>${venta.metodoPagoNombre}</td>
                                                            <td class="text-success font-weight-bold">S/<fmt:formatNumber value="${venta.total}" maxFractionDigits="2" minFractionDigits="2"/></td>
                                                          
                                                        </tr>
                                                    </c:forEach>
                                                </tbody>
                                            </table>
                                        </c:when>
                                        <c:otherwise>
                                            <div class="empty-state">
                                                <i class="fas fa-receipt"></i>
                                                <h6>No hay ventas registradas</h6>
                                                <p>Comienza realizando tu primera venta presencial</p>
                                            </div>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                            </div>
                        </div>
                        
                        <!-- Columna derecha - Guía de uso -->
                        <div class="right-column">
                            <div class="guide-section">
                                <div class="section-title">
                                    <h5><i class="fas fa-info-circle"></i> Guía de Uso</h5>
                                </div>
                                
                                <div class="guide-content">
                                    <div class="guide-intro">
                                        <p>Sigue estos pasos para realizar una venta presencial exitosa:</p>
                                    </div>
                                    
                                    <div class="guide-steps">
                                        <div class="step-item">
                                            <div class="step-number">1</div>
                                            <div class="step-content">
                                                <h6><i class="fas fa-user-plus"></i> Registrar Cliente</h6>
                                                <p>Ingresa el número de documento del cliente seleccionando el tipo:</p>
                                                <ul>
                                                    <li><strong>DNI:</strong> Documento Nacional de Identidad</li>
                                                    <li><strong>RUC:</strong> Registro Único de Contribuyente</li>
                                                    <li><strong>Carnet de Extranjería:</strong> Para extranjeros</li>
                                                </ul>
                                                <div class="tip">
                                                    <i class="fas fa-lightbulb"></i>
                                                    <span>Si el cliente ya existe, se detectará automáticamente. Si no, aparecerá un formulario para registrarlo.</span>
                                                </div>
                                            </div>
                                        </div>
                                        
                                        <div class="step-item">
                                            <div class="step-number">2</div>
                                            <div class="step-content">
                                                <h6><i class="fas fa-shopping-bag"></i> Seleccionar Productos</h6>
                                                <p>En el panel central encontrarás todos los productos disponibles:</p>
                                                <ul>
                                                    <li>Usa el buscador para encontrar productos por nombre</li>
                                                    <li>Navega por las categorías disponibles</li>
                                                    <li>Haz clic en "Agregar" para añadir productos al carrito</li>
                                                </ul>
                                                <div class="tip">
                                                    <i class="fas fa-search"></i>
                                                    <span>Utiliza palabras clave para búsquedas más rápidas y precisas.</span>
                                                </div>
                                            </div>
                                        </div>
                                        
                                        <div class="step-item">
                                            <div class="step-number">3</div>
                                            <div class="step-content">
                                                <h6><i class="fas fa-shopping-cart"></i> Revisar Carrito</h6>
                                                <p>En el panel derecho verás el resumen de tu venta:</p>
                                                <ul>
                                                    <li>Productos seleccionados con cantidades</li>
                                                    <li>Precio total de la venta</li>
                                                    <li>Opciones para modificar cantidades</li>
                                                    <li>Eliminar productos del carrito</li>
                                                </ul>
                                            </div>
                                        </div>
                                        
                                        <div class="step-item">
                                            <div class="step-number">4</div>
                                            <div class="step-content">
                                                <h6><i class="fas fa-credit-card"></i> Método de Pago</h6>
                                                <p>Selecciona la forma de pago preferida del cliente:</p>
                                                <div class="payment-methods">
                                                    <div class="payment-option">
                                                        <i class="fas fa-money-bill-wave"></i>
                                                        <span>Efectivo</span>
                                                    </div>
                                                    <div class="payment-option">
                                                        <i class="fas fa-credit-card"></i>
                                                        <span>Tarjeta</span>
                                                    </div>
                                                    <div class="payment-option">
                                                        <i class="fas fa-mobile-alt"></i>
                                                        <span>Yape</span>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                        
                                        <div class="step-item">
                                            <div class="step-number">5</div>
                                            <div class="step-content">
                                                <h6><i class="fas fa-check-circle"></i> Finalizar Venta</h6>
                                                <p>Una vez que todo esté listo:</p>
                                                <ul>
                                                    <li>Verifica que el cliente esté correctamente seleccionado</li>
                                                    <li>Confirma los productos y cantidades</li>
                                                    <li>Haz clic en "Finalizar Venta"</li>
                                                    <li>Se generará automáticamente la boleta</li>
                                                </ul>
                                                <div class="warning">
                                                    <i class="fas fa-exclamation-triangle"></i>
                                                    <span>Asegúrate de que el cliente esté seleccionado, de lo contrario no podrás procesar la venta.</span>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                    
                                    <div class="guide-footer">
                                        <div class="success-message">
                                            <i class="fas fa-trophy"></i>
                                            <div>
                                                <h6>¡Venta Completada!</h6>
                                                <p>Después de finalizar, podrás imprimir la boleta y regresarás a este panel automáticamente.</p>
                                            </div>
                                        </div>
                                        
                                        <button class="btn btn-primary btn-start-sale" id="btnIniciarVenta">
                                            <i class="fas fa-play"></i> Iniciar Nueva Venta
                                        </button>
                                    </div>
                                </div>
                            </div>
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
            
            // Event listeners para los botones de nueva venta
            document.getElementById("btnNuevoProducto").addEventListener("click", function () {
                window.location.href = AppContext.endpoints.producto.nuevo;
            });
            
            document.getElementById("btnIniciarVenta").addEventListener("click", function () {
                window.location.href = AppContext.endpoints.producto.nuevo;
            });
            
            // Animación de los pasos de la guía
            document.addEventListener('DOMContentLoaded', function() {
                const steps = document.querySelectorAll('.step-item');
                steps.forEach((step, index) => {
                    setTimeout(() => {
                        step.style.opacity = '1';
                        step.style.transform = 'translateY(0)';
                    }, index * 200);
                });
            });
        </script>                            
    </body>
</html>