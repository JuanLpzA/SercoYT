/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package com.sercoyt.controller;

import com.sercoyt.model.dao.TipoUsuarioDao;
import com.sercoyt.model.TipoUsuario;
import javax.servlet.*;
import javax.servlet.http.*;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;

/**
 *
 * @author Arrunategui
 */
public class TipoUsuarioControlador extends HttpServlet {
    private final TipoUsuarioDao tipoDao = new TipoUsuarioDao();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String accion = req.getParameter("accion") != null ? req.getParameter("accion") : "listar";
        switch (accion) {
            case "gestionar":
            case "listar":
                List<TipoUsuario> tipos = tipoDao.listarTodos();
                req.setAttribute("tiposUsuario", tipos);
                req.getRequestDispatcher("/admin/tipoUsuario.jsp").forward(req, resp);
                break;
            case "editar":
                int id = Integer.parseInt(req.getParameter("id"));
                TipoUsuario tipo = tipoDao.obtenerPorId(id);
                req.setAttribute("tipoUsuario", tipo);
                req.getRequestDispatcher("/admin/tipoUsuarioEditar.jsp").forward(req, resp);
                break;
            case "existeNombre":
                validarNombreAjax(req, resp);
                break;
            default:
                resp.sendRedirect("TipoUsuarioControlador?accion=listar");
        }
    }

    private void validarNombreAjax(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        resp.setContentType("application/json");
        String nombre = req.getParameter("nombre");
        String idStr = req.getParameter("idTipoUsuario");
        Integer excluirId = (idStr != null && !idStr.isEmpty()) ? Integer.parseInt(idStr) : null;
        boolean existe = tipoDao.existeNombre(nombre, excluirId);
        try (PrintWriter out = resp.getWriter()) {
            out.print("{\"existe\":" + existe + "}");
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String accion = req.getParameter("accion");
        resp.setContentType("application/json");
        PrintWriter out = resp.getWriter();

        switch (accion) {
            case "agregar":
                String nombre = req.getParameter("nombre");
                String estado = req.getParameter("estadoTipo");
                if (tipoDao.existeNombre(nombre, null)) {
                    out.print("{\"success\":false,\"message\":\"El nombre ya existe\"}");
                    return;
                }
                TipoUsuario t = new TipoUsuario();
                t.setNombre(nombre);
                t.setEstadoTipo(estado);
                boolean creado = tipoDao.agregar(t);
                out.print("{\"success\":" + creado + ",\"message\":\"" + (creado ? "Rol creado correctamente" : "Error al crear rol") + "\"}");
                break;
            case "actualizar":
                int id = Integer.parseInt(req.getParameter("idTipoUsuario"));
                String nombreEdit = req.getParameter("nombre");
                String estadoEdit = req.getParameter("estadoTipo");
                if (tipoDao.existeNombre(nombreEdit, id)) {
                    out.print("{\"success\":false,\"message\":\"El nombre ya existe\"}");
                    return;
                }
                TipoUsuario tipo = new TipoUsuario();
                tipo.setIdTipoUsuario(id);
                tipo.setNombre(nombreEdit);
                tipo.setEstadoTipo(estadoEdit);
                boolean actualizado = tipoDao.actualizar(tipo);
                out.print("{\"success\":" + actualizado + ",\"message\":\"" + (actualizado ? "Rol actualizado correctamente" : "Error al actualizar rol") + "\"}");
                break;
        }
    }
}