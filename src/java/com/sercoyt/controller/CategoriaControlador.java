package com.sercoyt.controller;

import com.sercoyt.model.Categoria;
import com.sercoyt.model.dao.CategoriaDao;
import java.io.IOException;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class CategoriaControlador extends HttpServlet {

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
                    eliminarCategoria(request, response);
                    break;
                default:
                    listarCategorias(request, response);
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error en el servidor");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String accion = request.getParameter("accion");
        
        try {
            switch (accion) {
                case "guardar":
                    guardarCategoria(request, response);
                    break;
                case "actualizar":
                    actualizarCategoria(request, response);
                    break;
                default:
                    response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Acción no válida");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error en el servidor");
        }
    }

    private void listarCategorias(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<Categoria> categorias = categoriaDao.listar();
        request.setAttribute("categorias", categorias);
        request.getRequestDispatcher("/admin/categorias.jsp").forward(request, response);
    }

    private void mostrarFormularioNuevo(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/admin/nuevaCategoria.jsp").forward(request, response);
    }

    private void mostrarFormularioEditar(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        Categoria categoria = categoriaDao.obtenerPorId(id);
        
        if (categoria != null) {
            request.setAttribute("categoria", categoria);
            request.getRequestDispatcher("/admin/editarCategoria.jsp").forward(request, response);
        } else {
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "Categoría no encontrada");
        }
    }

    private void guardarCategoria(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            Categoria categoria = new Categoria();
            categoria.setNombre(request.getParameter("nombre"));
            categoria.setEstado("activo");
            
            if (categoriaDao.insertar(categoria) > 0) {
                response.sendRedirect(request.getContextPath() + "/CategoriaControlador?accion=listar&exito=guardar");
            } else {
                response.sendRedirect(request.getContextPath() + "/CategoriaControlador?accion=nuevo&error=guardar");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/CategoriaControlador?accion=nuevo&error=guardar");
        }
    }

    private void actualizarCategoria(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            Categoria categoria = new Categoria();
            categoria.setId(id);
            categoria.setNombre(request.getParameter("nombre"));
            categoria.setEstado(request.getParameter("estado"));
            
            if (categoriaDao.actualizar(categoria)) {
                response.sendRedirect(request.getContextPath() + "/CategoriaControlador?accion=listar&exito=actualizar");
            } else {
                response.sendRedirect(request.getContextPath() + "/CategoriaControlador?accion=editar&id=" + id + "&error=actualizar");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/CategoriaControlador?accion=editar&id=" + request.getParameter("id") + "&error=actualizar");
        }
    }

    private void eliminarCategoria(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        
        if (categoriaDao.eliminar(id)) {
            response.sendRedirect(request.getContextPath() + "/CategoriaControlador?accion=listar&exito=eliminar");
        } else {
            response.sendRedirect(request.getContextPath() + "/CategoriaControlador?accion=listar&error=eliminar");
        }
    }
}