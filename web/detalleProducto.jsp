<%-- 
    Document   : detalleProducto
    Created on : 13 jul. 2025, 23:05:21
    Author     : Arrunategui
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Detalle del Producto - SercoYT</title>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/styleonline.css?v3">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/detalleProducto.css?v3">
        <link rel="stylesheet" href="https://use.fontawesome.com/releases/v5.8.2/css/all.css">
    </head>
    <body>
        <!-- Header -->
        <header class="main-header">
            <%@include file="resources/commons/header.jsp" %>
        </header>

        <!-- Contenido Principal -->
        <main class="product-detail-container">
            <a href="javascript:history.back()" class="back-button">
                <i class="fas fa-arrow-left"></i> Volver atrás
            </a>
            
            <div class="product-detail-content">
                <div class="product-image-container">
                    <img src="ControladorIMG?id=${producto.id}" alt="${producto.nombres}" class="product-image-large">
                </div>
                
                <div class="product-info-container">
                    <h1 class="product-title">${producto.nombres}</h1>
                    <div class="product-price">S/${producto.precio}0</div>
                    
                    <div class="product-meta">
                        <span><strong>Marca:</strong> ${producto.nombreMarca}</span>
                        <span><strong>Categoría:</strong> ${producto.nombreCategoria}</span>
                        <span>
                            <strong>Disponibilidad:</strong> 
                            <span class="stock-status 
                                  ${producto.stock > 10 ? 'in-stock' : 
                                   (producto.stock > 0 ? 'low-stock' : 'out-of-stock')}">
                                ${producto.stock > 10 ? 'En stock' : 
                                  (producto.stock > 0 ? 'Últimas unidades' : 'Agotado')}
                            </span>
                        </span>
                        <span><strong>Unidades disponibles:</strong> ${producto.stock}</span>
                    </div>
                    
                    <div class="product-description">
                        <h3>Descripción</h3>
                        <p>${producto.descripcion}</p>
                    </div>
                    
                    <div class="detail-actions">
                        <div class="quantity-selector">
                            <label for="quantity">Cantidad:</label>
                            <input type="number" id="quantity" name="quantity" min="1" max="${producto.stock}" value="1">
                        </div>
                        
                        <button class="btn-detail btn-detail-add" 
                                onclick="agregarAlCarrito(${producto.id}, '${param.accion}', document.getElementById('quantity').value)">
                            <i class="fas fa-cart-plus"></i> Añadir al carrito
                        </button>
                        
                        <button class="btn-detail btn-detail-buy" 
                                onclick="comprarAhora(${producto.id}, document.getElementById('quantity').value)">
                            <i class="fas fa-credit-card"></i> Comprar ahora
                        </button>
                    </div>
                </div>
            </div>
            
            <div class="product-specs">
                <h3>Especificaciones técnicas</h3>
                <table class="specs-table">
                    <tr>
                        <th>Característica</th>
                        <th>Detalle</th>
                    </tr>
                    <tr>
                        <td>Marca</td>
                        <td>${producto.nombreMarca}</td>
                    </tr>
                    <tr>
                        <td>Categoría</td>
                        <td>${producto.nombreCategoria}</td>
                    </tr>
                    <tr>
                        <td>Precio</td>
                        <td>S/${producto.precio}0</td>
                    </tr>
                    <tr>
                        <td>Disponibilidad</td>
                        <td>${producto.stock} unidades</td>
                    </tr>
                </table>
            </div>
        </main>

        <!-- Footer -->
        <footer class="main-footer">
            <%@include file="resources/commons/footer.jsp" %>
        </footer>

        <script src="${pageContext.request.contextPath}/js/jquery-3.7.1.min.js"></script>
        <script src="${pageContext.request.contextPath}/js/bootstrap.min.js"></script>
        <script>
            function agregarAlCarrito(idProducto, categoria, cantidad) {
                fetch('Controlador?accion=AgregarCarrito&id=' + idProducto + '&categoria=' + categoria + '&cantidad=' + cantidad, {
                    headers: {
                        'X-Requested-With': 'XMLHttpRequest'
                    }
                })
                .then(response => response.text())
                .then(data => {
                    if (data === 'OK') {
                        mostrarNotificacion('Producto añadido al carrito');
                        actualizarContadorCarrito();
                    }
                })
                .catch(error => console.error('Error:', error));
            }
            
            function comprarAhora(idProducto, cantidad) {
                window.location.href = 'Controlador?accion=Comprar&id=' + idProducto + '&cantidad=' + cantidad;
            }
            
            function mostrarNotificacion(mensaje) {
                const notificacion = document.createElement('div');
                notificacion.className = 'notificacion-carrito';
                notificacion.innerHTML = `
                    <i class="fas fa-check-circle"></i>
                    <span>${mensaje}</span>
                `;

                document.body.appendChild(notificacion);

                setTimeout(() => {
                    notificacion.classList.add('mostrar');
                }, 10);

                setTimeout(() => {
                    notificacion.classList.remove('mostrar');
                    setTimeout(() => {
                        document.body.removeChild(notificacion);
                    }, 300);
                }, 3000);
            }

            function actualizarContadorCarrito() {
                fetch('Controlador?accion=ObtenerContadorCarrito', {
                    headers: {
                        'X-Requested-With': 'XMLHttpRequest'
                    }
                })
                .then(response => response.text())
                .then(count => {
                    const contador = document.querySelector('.cart-count');
                    if (contador) {
                        contador.textContent = count;
                    }
                })
                .catch(error => console.error('Error:', error));
            }
        </script>
    </body>
</html>