<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>SercoYT - Tecnología y Computación</title>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/styleonline.css">
        <link rel="stylesheet" href="https://use.fontawesome.com/releases/v5.8.2/css/all.css">
    </head>
    <body>
        <!-- Header -->
        <header class="main-header">
            <%@include file="resources/commons/header.jsp" %>
        </header>

        <!-- Contenido Principal -->
        <main class="product-container">
            <h2 class="section-title">Nuestros Productos</h2>

            <div class="product-grid">
                <c:forEach var="p" items="${productos}">
                    <div class="product-card">
                        <div class="product-badge">Nuevo</div>
                        <div class="product-image-container">
                            <img src="ControladorIMG?id=${p.id}" alt="${p.nombres}" class="product-image">
                        </div>
                        <div class="product-info">
                            <h3 class="product-title">${p.nombres}</h3>
                            <div class="product-price">S/${p.precio}0</div>
                            <p class="product-description">${p.descripcion}</p>
                            <div class="product-actions">
                                <a href="#" class="btn-add-to-cart" onclick="agregarAlCarrito(${p.id}, '${param.accion}')">
                                    <i class="fas fa-cart-plus"></i> Añadir
                                </a>
                                <button class="btn-buy-now" onclick="window.location.href = 'Controlador?accion=Comprar&id=${p.id}'">
                                    <i class="fas fa-credit-card"></i> Comprar
                                </button>
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </div>

            <div class="pagination">
                <c:if test="${paginaActual > 1}">
                    <a href="Controlador?accion=${param.accion}&pagina=${paginaActual - 1}" class="page-link">Anterior</a>
                </c:if>

                <c:forEach begin="1" end="${totalPaginas}" var="i">
                    <a href="Controlador?accion=${param.accion}&pagina=${i}" 
                       class="page-link ${paginaActual == i ? 'active' : ''}">${i}</a>
                </c:forEach>

                <c:if test="${paginaActual < totalPaginas}">
                    <a href="Controlador?accion=${param.accion}&pagina=${paginaActual + 1}" class="page-link">Siguiente</a>
                </c:if>
            </div>
        </main>

        <!-- Footer -->
        <footer class="main-footer">
            <%@include file="resources/commons/footer.jsp" %>
        </footer>

        <script src="${pageContext.request.contextPath}/js/jquery-3.7.1.min.js"></script>
        <script src="${pageContext.request.contextPath}/js/bootstrap.min.js"></script>
        <script>
function agregarAlCarrito(idProducto, categoria) {
    fetch('Controlador?accion=AgregarCarrito&id=' + idProducto + '&categoria=' + categoria, {
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

function mostrarNotificacion(mensaje) {
    const notificacion = document.createElement('div');
    notificacion.className = 'notificacion-carrito';
    notificacion.innerHTML = `
        <i class="fas fa-check-circle"></i>
        <span>Producto Añadido</span>
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