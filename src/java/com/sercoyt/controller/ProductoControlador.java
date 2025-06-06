package com.sercoyt.controller;

import com.google.gson.Gson;
import com.sercoyt.model.Producto;
import com.sercoyt.model.dao.CategoriaDao;
import com.sercoyt.model.dao.MarcaDao;
import com.sercoyt.model.dao.ProductoDao;
import java.io.IOException;
import java.io.InputStream;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.servlet.http.Part;
import com.sercoyt.model.*;

@MultipartConfig
public class ProductoControlador extends HttpServlet {

    private final ProductoDao productoDao = new ProductoDao();
    private final MarcaDao marcaDao = new MarcaDao();
    private final CategoriaDao categoriaDao = new CategoriaDao();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String accion = request.getParameter("accion");
        
        if (accion == null) {
            accion = "listar";
        }
        
        try {
            switch (accion) {
                case "nuevo":
                    mostrarFormularioNuevo(request, response);
                    break;
                case "editar":
                    mostrarFormularioEditar(request, response);
                    break;
                case "eliminar":
                    eliminarProducto(request, response);
                    break;
                case "activar":
                    activarProducto(request, response);
                    break;
                case "stock":
                    mostrarFormularioStock(request, response);
                    break;
                
                case "filtrar":
                    filtrarProductos(request, response);
                    break;
                default:
                    listarProductos(request, response);
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Error en el servidor: " + e.getMessage());
            listarProductos(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String accion = request.getParameter("accion");
        
        try {
            switch (accion) {
                case "guardar":
                    guardarProducto(request, response);
                    break;
                case "actualizar":
                    actualizarProducto(request, response);
                    break;
                case "actualizarStock":
                    actualizarStock(request, response);
                    break;    
                default:
                    response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Acción no válida");
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Error en el servidor: " + e.getMessage());
            listarProductos(request, response);
        }
    }

    private void listarProductos(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<Producto> productos = productoDao.listarTodos();
        List<Marca> marcas = marcaDao.listar();
        List<Categoria> categorias = categoriaDao.listar();
        
        request.setAttribute("productos", productos);
        request.setAttribute("marcas", marcas);
        request.setAttribute("categorias", categorias);
        request.getRequestDispatcher("/admin/productos.jsp").forward(request, response);
    }

    private void mostrarFormularioNuevo(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<Marca> marcas = marcaDao.listar();
        List<Categoria> categorias = categoriaDao.listar();
        
        request.setAttribute("marcas", marcas);
        request.setAttribute("categorias", categorias);
        request.getRequestDispatcher("/admin/nuevoProducto.jsp").forward(request, response);
    }

    private void mostrarFormularioEditar(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        Producto producto = productoDao.listarId(id);
        
        if (producto != null) {
            request.setAttribute("producto", producto);
            request.setAttribute("marcas", marcaDao.listar());
            request.setAttribute("categorias", categoriaDao.listar());
            
            // Enviar como JSON para el modal
            if ("XMLHttpRequest".equals(request.getHeader("X-Requested-With"))) {
                response.setContentType("application/json");
                response.getWriter().write(new Gson().toJson(producto));
            } else {
                request.getRequestDispatcher("/admin/editarProducto.jsp").forward(request, response);
            }
        } else {
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "Producto no encontrado");
        }
    }

    private void mostrarFormularioStock(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        Producto producto = productoDao.listarId(id);
        
        if (producto != null) {
            request.setAttribute("producto", producto);
            request.getRequestDispatcher("/admin/stock.jsp").forward(request, response);
        } else {
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "Producto no encontrado");
        }
    }

    private void guardarProducto(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            String nombreMarca = request.getParameter("marca");
            String nombreCategoria = request.getParameter("categoria");
            
            // Verificar si la marca existe, si no, crearla
            if (!productoDao.existeMarca(nombreMarca)) {
                Marca nuevaMarca = new Marca();
                nuevaMarca.setNombre(nombreMarca);
                nuevaMarca.setEstado("activo");
                marcaDao.insertar(nuevaMarca);
            }
            
            // Verificar si la categoría existe
            if (!productoDao.existeCategoria(nombreCategoria)) {
                throw new ServletException("La categoría especificada no existe");
            }

            Producto producto = new Producto();
            producto.setNombres(request.getParameter("nombre"));
            producto.setDescripcion(request.getParameter("descripcion"));
            producto.setPrecio(Double.parseDouble(request.getParameter("precio")));
            producto.setStock(Integer.parseInt(request.getParameter("stock")));
            
            Part filePart = request.getPart("imagen");
            if (filePart != null && filePart.getSize() > 0) {
                InputStream fileContent = filePart.getInputStream();
                producto.setFoto(fileContent);
            }
            
            producto.setNombreMarca(nombreMarca);
            producto.setNombreCategoria(nombreCategoria);
         
            
            if (productoDao.insertar(producto)) {
                request.getSession().setAttribute("exito", "Producto creado correctamente");
            } else {
                request.getSession().setAttribute("error", "Error al crear el producto");
            }
            
            response.sendRedirect(request.getContextPath() + "/ProductoControlador");
        } catch (Exception e) {
            e.printStackTrace();
            request.getSession().setAttribute("error", "Error al crear el producto: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/ProductoControlador");
        }
    }
    
    private void filtrarProductos(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String nombre = request.getParameter("nombre");
        String marca = request.getParameter("marca");
        String categoria = request.getParameter("categoria");
        String stockMinStr = request.getParameter("stockMin");
        String stockMaxStr = request.getParameter("stockMax");
        
        Integer stockMin = null;
        Integer stockMax = null;
        
        try {
            if (stockMinStr != null && !stockMinStr.isEmpty()) {
                stockMin = Integer.parseInt(stockMinStr);
            }
            if (stockMaxStr != null && !stockMaxStr.isEmpty()) {
                stockMax = Integer.parseInt(stockMaxStr);
            }
        } catch (NumberFormatException e) {
            // Manejar error de formato numérico
        }
        
        List<Producto> productos = productoDao.filtrarProductos(nombre, marca, categoria, stockMin, stockMax);
        List<Marca> marcas = marcaDao.listar();
        List<Categoria> categorias = categoriaDao.listar();
        
        request.setAttribute("productos", productos);
        request.setAttribute("marcas", marcas);
        request.setAttribute("categorias", categorias);
        request.setAttribute("filtroNombre", nombre);
        request.setAttribute("filtroMarca", marca);
        request.setAttribute("filtroCategoria", categoria);
        request.setAttribute("filtroStockMin", stockMinStr);
        request.setAttribute("filtroStockMax", stockMaxStr);
        
        request.getRequestDispatcher("/admin/productos.jsp").forward(request, response);
    }

    private void actualizarProducto(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            Producto producto = new Producto();
            producto.setId(id);
            producto.setNombres(request.getParameter("nombre"));
            producto.setDescripcion(request.getParameter("descripcion"));
            producto.setPrecio(Double.parseDouble(request.getParameter("precio")));
            
            Part filePart = request.getPart("imagen");
            if (filePart != null && filePart.getSize() > 0) {
                InputStream fileContent = filePart.getInputStream();
                producto.setFoto(fileContent);
            }
            
            producto.setNombreMarca(request.getParameter("marca"));
            producto.setNombreCategoria(request.getParameter("categoria"));
            
            if (productoDao.actualizar(producto)) {
                request.getSession().setAttribute("exito", "Producto actualizado correctamente");
            } else {
                request.getSession().setAttribute("error", "Error al actualizar el producto");
            }
            
            response.sendRedirect(request.getContextPath() + "/ProductoControlador");
        } catch (Exception e) {
            e.printStackTrace();
            request.getSession().setAttribute("error", "Error al actualizar el producto: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/ProductoControlador");
        }
    }

    private void eliminarProducto(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        
        if (productoDao.eliminar(id)) {
            request.getSession().setAttribute("exito", "Producto desactivado correctamente");
        } else {
            request.getSession().setAttribute("error", "Error al desactivar el producto");
        }
        
        response.sendRedirect(request.getContextPath() + "/ProductoControlador");
    }
    
    private void activarProducto(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        
        if (productoDao.activar(id)) {
            request.getSession().setAttribute("exito", "Producto activado correctamente");
        } else {
            request.getSession().setAttribute("error", "Error al activar el producto");
        }
        
        response.sendRedirect(request.getContextPath() + "/ProductoControlador");
    }

    private void actualizarStock(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        int cantidad = Integer.parseInt(request.getParameter("cantidad"));
        
        if (productoDao.actualizarStock(id, cantidad)) {
            request.getSession().setAttribute("exito", "Stock actualizado correctamente");
        } else {
            request.getSession().setAttribute("error", "Error al actualizar el stock");
        }
        
        response.sendRedirect(request.getContextPath() + "/ProductoControlador");
    }
}