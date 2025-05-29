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
                               + "WHERE c.nombre = ?";
                    List<Producto> productos = pdao.listarConFiltro(sql, nombreCategoria);
                    request.setAttribute("productos", productos);
                    request.getRequestDispatcher("index.jsp").forward(request, response);
                    break;

                case "AgregarCarrito":
                    int idp = Integer.parseInt(request.getParameter("id"));
                    String categoriaActual = request.getParameter("categoria");
                    Producto p = pdao.listarId(idp);

                    if (p != null && p.getStock() > 0) {
                        boolean encontrado = false;
                        for (Carrito item : listaCarrito) {
                            if (item.getIdProducto() == idp) {
                                if (item.getCantidad() < p.getStock()) {
                                    item.setCantidad(item.getCantidad() + 1);
                                    item.setSubTotal(item.getPrecioCompra() * item.getCantidad());
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
                            car.setCantidad(1);
                            car.setSubTotal(p.getPrecio());
                            car.setStock(p.getStock());
                            listaCarrito.add(car);
                        }

                        session.setAttribute("contador", listaCarrito.size());
                    }
                    response.sendRedirect(categoriaActual != null ? "Controlador?accion=" + categoriaActual : "Controlador");
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
                            item.setSubTotal(item.getPrecioCompra() * cant);
                            break;
                        }
                    }
                    response.sendRedirect("Controlador?accion=Carrito");
                    break;

                case "Carrito":
                    double totalPagar = listaCarrito.stream()
                            .mapToDouble(Carrito::getSubTotal)
                            .sum();
                    request.setAttribute("totalPagar", totalPagar);
                    request.setAttribute("carrito", listaCarrito);
                    request.getRequestDispatcher("carrito.jsp").forward(request, response);
                    break;
                    
                case "Comprar":
                    int idProductoComprar = Integer.parseInt(request.getParameter("id"));
                    Producto productoComprar = pdao.listarId(idProductoComprar);

                    if (productoComprar != null && productoComprar.getStock() > 0) {
                        boolean encontrado = false;
                        for (Carrito item : listaCarrito) {
                            if (item.getIdProducto() == idProductoComprar) {
                                if (item.getCantidad() < productoComprar.getStock()) {
                                    item.setCantidad(item.getCantidad() + 1);
                                    item.setSubTotal(item.getPrecioCompra() * item.getCantidad());
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
                            nuevoItem.setCantidad(1);
                            nuevoItem.setSubTotal(productoComprar.getPrecio());
                            nuevoItem.setStock(productoComprar.getStock());
                            listaCarrito.add(nuevoItem);
                        }

                        session.setAttribute("contador", listaCarrito.size());
                    }

                    response.sendRedirect("Controlador?accion=Carrito");
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