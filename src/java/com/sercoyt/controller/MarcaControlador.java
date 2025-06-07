package com.sercoyt.controller;

import com.sercoyt.model.Marca;
import com.sercoyt.model.dao.MarcaDao;
import java.io.IOException;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class MarcaControlador extends HttpServlet {

    private final MarcaDao marcaDao = new MarcaDao();

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
                    eliminarMarca(request, response);
                    break;
                default:
                    listarMarcas(request, response);
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
                    guardarMarca(request, response);
                    break;
                case "actualizar":
                    actualizarMarca(request, response);
                    break;
                default:
                    response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Acción no válida");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error en el servidor");
        }
    }

   private void listarMarcas(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {
    List<Marca> marcas = marcaDao.listar();
    request.setAttribute("marcas", marcas);
    request.getRequestDispatcher("/admin/marcas.jsp").forward(request, response);
}

    private void mostrarFormularioNuevo(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/admin/nuevaMarca.jsp").forward(request, response);
    }

    private void mostrarFormularioEditar(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        Marca marca = marcaDao.obtenerPorId(id);
        
        if (marca != null) {
            request.setAttribute("marca", marca);
            request.getRequestDispatcher("/admin/editarMarca.jsp").forward(request, response);
        } else {
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "Marca no encontrada");
        }
    }

    private void guardarMarca(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            Marca marca = new Marca();
            marca.setNombre(request.getParameter("nombre"));
            marca.setEstado("activo");

            int idGenerado = marcaDao.insertar(marca);

            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");

            if (idGenerado > 0) {
                response.getWriter().write("{\"exito\": true}");
            } else {
                response.getWriter().write("{\"error\": \"Error al guardar la marca\"}");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            response.getWriter().write("{\"error\": \"" + e.getMessage() + "\"}");
        }
    }

    private void actualizarMarca(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            Marca marca = new Marca();
            marca.setId(id);
            marca.setNombre(request.getParameter("nombre"));
            marca.setEstado(request.getParameter("estado"));
            
            if (marcaDao.actualizar(marca)) {
                response.sendRedirect(request.getContextPath() + "/MarcaControlador?accion=listar&exito=actualizar");
            } else {
                response.sendRedirect(request.getContextPath() + "/MarcaControlador?accion=editar&id=" + id + "&error=actualizar");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/MarcaControlador?accion=editar&id=" + request.getParameter("id") + "&error=actualizar");
        }
    }

    private void eliminarMarca(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        
        if (marcaDao.eliminar(id)) {
            response.sendRedirect(request.getContextPath() + "/MarcaControlador?accion=listar&exito=eliminar");
        } else {
            response.sendRedirect(request.getContextPath() + "/MarcaControlador?accion=listar&error=eliminar");
        }
    }
}