package com.sercoyt.controller;

import com.sercoyt.model.Carrito;
import com.sercoyt.model.Producto;
import com.sercoyt.model.dao.ProductoDao;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

public class Controlador extends HttpServlet {

    private final ProductoDao pdao = new ProductoDao();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        String accion = request.getParameter("accion");
        accion = (accion == null) ? "" : accion;

        List<Carrito> listaCarrito = (List<Carrito>) session.getAttribute("carrito");
        if (listaCarrito == null) {
            listaCarrito = new ArrayList<>();
            session.setAttribute("carrito", listaCarrito);
        }

        try {
            switch (accion) {
                case "laptops":
                case "componentes":
                case "perifericos":
                case "impresoras":
                case "monitores":
                case "computadoras":
                    String nombreCategoria = capitalizarPrimeraLetra(accion);
                    String sql = "SELECT p.*, m.nombre as nombreMarca, c.nombre as nombreCategoria "
                            + "FROM productos p "
                            + "JOIN marcas m ON p.idMarca = m.idMarca "
                            + "JOIN categorias c ON p.idCategoria = c.idCategoria "
                            + "WHERE c.nombre = ? AND p.stock > 0 AND p.estadoProducto = 'activo'";
                    List<Producto> productos = pdao.listarConFiltro(sql, nombreCategoria);
                    request.setAttribute("productos", productos);
                    request.getRequestDispatcher("index.jsp").forward(request, response);
                    break;

                case "AgregarCarrito":
    int idp = Integer.parseInt(request.getParameter("id"));
    String categoriaActual = request.getParameter("categoria");
    int cantidad = 1;
    try {
        cantidad = Integer.parseInt(request.getParameter("cantidad"));
        cantidad = Math.max(1, Math.min(cantidad, 100)); // Limitar entre 1 y 100
    } catch (NumberFormatException e) {
        cantidad = 1;
    }
    
    Producto p = pdao.listarId(idp);

    if (p != null && p.getStock() > 0) {
        boolean encontrado = false;
        for (Carrito item : listaCarrito) {
            if (item.getIdProducto() == idp) {
                int nuevaCantidad = item.getCantidad() + cantidad;
                if (nuevaCantidad <= p.getStock()) {
                    item.setCantidad(nuevaCantidad);
                    item.setSubTotal(item.getPrecioCompra() * nuevaCantidad);
                } else {
                    item.setCantidad(p.getStock());
                    item.setSubTotal(item.getPrecioCompra() * p.getStock());
                }
                encontrado = true;
                break;
            }
        }

        if (!encontrado) {
            Carrito car = new Carrito();
            car.setItem(listaCarrito.size() + 1);
            car.setIdProducto(p.getId());
            car.setNombres(p.getNombres());
            car.setDescripcion(p.getDescripcion());
            car.setPrecioCompra(p.getPrecio());
            car.setCantidad(Math.min(cantidad, p.getStock()));
            car.setSubTotal(p.getPrecio() * Math.min(cantidad, p.getStock()));
            car.setStock(p.getStock());
            listaCarrito.add(car);
        }

        session.setAttribute("contador", listaCarrito.size());

        if ("XMLHttpRequest".equals(request.getHeader("X-Requested-With"))) {
            response.setContentType("text/plain");
            response.getWriter().write("OK");
            return;
        }
        response.sendRedirect(categoriaActual != null ? "Controlador?accion=" + categoriaActual : "Controlador");
    }
    break;
                case "Delete":
                    int idproducto = Integer.parseInt(request.getParameter("idp"));
                    listaCarrito.removeIf(item -> item.getIdProducto() == idproducto);
                    session.setAttribute("contador", listaCarrito.size());
                    response.sendRedirect("Controlador?accion=Carrito");
                    break;

                case "ActualizarCantidad":
                    int idpro = Integer.parseInt(request.getParameter("idp"));
                    int cant = Integer.parseInt(request.getParameter("Cantidad"));
                    cant = Math.max(1, Math.min(cant, 100));

                    for (Carrito item : listaCarrito) {
                        if (item.getIdProducto() == idpro) {
                            cant = Math.min(cant, item.getStock());
                            item.setCantidad(cant);
                            // MANTENER: El precio ya incluye IGV, subTotal = precioConIGV * cantidad
                            item.setSubTotal(item.getPrecioCompra() * cant);
                            break;
                        }
                    }
                    response.sendRedirect("Controlador?accion=Carrito");
                    break;

                case "Carrito":
                    // Calcular el total con IGV (que es lo que ya está en subTotal)
                    double totalConIGV = listaCarrito.stream()
                            .mapToDouble(Carrito::getSubTotal)
                            .sum();

                    // Calcular subtotal sin IGV e IGV por separado para mostrar en JSP
                    double subtotalSinIGV = totalConIGV / 1.18;
                    double igvCalculado = totalConIGV - subtotalSinIGV;

                    // Pasar todos los valores al JSP
                    request.setAttribute("totalPagar", totalConIGV); // Total con IGV
                    request.setAttribute("subtotalSinIGV", subtotalSinIGV); // Subtotal sin IGV
                    request.setAttribute("igvCalculado", igvCalculado); // IGV calculado
                    request.setAttribute("carrito", listaCarrito);
                    request.getRequestDispatcher("carrito.jsp").forward(request, response);
                    break;

                case "Comprar":
    int idProductoComprar = Integer.parseInt(request.getParameter("id"));
    int cantidadComprar = 1;
    try {
        cantidadComprar = Integer.parseInt(request.getParameter("cantidad"));
        cantidadComprar = Math.max(1, Math.min(cantidadComprar, 100));
    } catch (NumberFormatException e) {
        cantidadComprar = 1;
    }
    
    Producto productoComprar = pdao.listarId(idProductoComprar);

    if (productoComprar != null && productoComprar.getStock() > 0) {
        boolean encontrado = false;
        for (Carrito item : listaCarrito) {
            if (item.getIdProducto() == idProductoComprar) {
                int nuevaCantidad = item.getCantidad() + cantidadComprar;
                if (nuevaCantidad <= productoComprar.getStock()) {
                    item.setCantidad(nuevaCantidad);
                    item.setSubTotal(item.getPrecioCompra() * nuevaCantidad);
                } else {
                    item.setCantidad(productoComprar.getStock());
                    item.setSubTotal(item.getPrecioCompra() * productoComprar.getStock());
                }
                encontrado = true;
                break;
            }
        }

        if (!encontrado) {
            Carrito nuevoItem = new Carrito();
            nuevoItem.setItem(listaCarrito.size() + 1);
            nuevoItem.setIdProducto(productoComprar.getId());
            nuevoItem.setNombres(productoComprar.getNombres());
            nuevoItem.setDescripcion(productoComprar.getDescripcion());
            nuevoItem.setPrecioCompra(productoComprar.getPrecio());
            nuevoItem.setCantidad(Math.min(cantidadComprar, productoComprar.getStock()));
            nuevoItem.setSubTotal(productoComprar.getPrecio() * Math.min(cantidadComprar, productoComprar.getStock()));
            nuevoItem.setStock(productoComprar.getStock());
            listaCarrito.add(nuevoItem);
        }

        session.setAttribute("contador", listaCarrito.size());
    }

    response.sendRedirect("Controlador?accion=Carrito");
    break;

                case "asesoria":
                    request.getRequestDispatcher("asesoria.jsp").forward(request, response);
                    break;
                case "conocenos":
                    request.getRequestDispatcher("conocenos.jsp").forward(request, response);
                    break;
                case "ObtenerContadorCarrito":
                    response.setContentType("text/plain");
                    response.getWriter().write(String.valueOf(listaCarrito.size()));
                    return;
                case "VerDetalle":
                    int idDetalle = Integer.parseInt(request.getParameter("id"));
                    Producto productoDetalle = pdao.listarId(idDetalle);
                    if (productoDetalle != null) {
                        request.setAttribute("producto", productoDetalle);
                        request.getRequestDispatcher("detalleProducto.jsp").forward(request, response);
                    } else {
                        response.sendRedirect("Controlador");
                    }
                    break;

                default:
                    request.setAttribute("productos", pdao.listar());
                    request.setAttribute("contador", listaCarrito.size());
                    request.getRequestDispatcher("index.jsp").forward(request, response);
                    break;
            }
        } catch (NumberFormatException e) {
            response.sendRedirect("Controlador");
        }
    }

    private String capitalizarPrimeraLetra(String str) {
        return (str == null || str.isEmpty())
                ? str
                : str.substring(0, 1).toUpperCase() + str.substring(1);
    }
}
