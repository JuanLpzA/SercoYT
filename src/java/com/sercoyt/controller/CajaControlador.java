package com.sercoyt.controller;

import com.sercoyt.model.Caja;
import com.sercoyt.model.dao.CajaDao;
import com.sercoyt.model.VentaExtra;
import com.fasterxml.jackson.databind.ObjectMapper;
import java.io.IOException;
import java.sql.SQLException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class CajaControlador extends HttpServlet {

    private final CajaDao cajaDao = new CajaDao();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String accion = request.getParameter("accion");

        if (accion == null) {
            accion = "listar";
        }

        try {
            switch (accion) {
                case "listar":
                    listarCajas(request, response);
                    break;
                case "filtrar":
                    filtrarCajas(request, response);
                    break;
                case "resumen":
                    mostrarResumen(request, response);
                    break;
                case "detalles":
                    mostrarDetalles(request, response);
                    break;
                default:
                    listarCajas(request, response);
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error en el servidor: " + e.getMessage());
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }

    private void listarCajas(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, SQLException {
        List<Caja> cajas = cajaDao.listarTodasLasCajas();
        request.setAttribute("cajas", cajas);
        request.getRequestDispatcher("/admin/cajas.jsp").forward(request, response);
    }

    private void filtrarCajas(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, SQLException, ParseException {
        String nombreUsuario = request.getParameter("nombreUsuario");
        String estado = request.getParameter("estado");
        String fechaInicioStr = request.getParameter("fechaInicio");
        String fechaFinStr = request.getParameter("fechaFin");

        Date fechaInicio = null;
        Date fechaFin = null;
        
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
        
        if (fechaInicioStr != null && !fechaInicioStr.isEmpty()) {
            fechaInicio = sdf.parse(fechaInicioStr);
        }
        
        if (fechaFinStr != null && !fechaFinStr.isEmpty()) {
            fechaFin = sdf.parse(fechaFinStr);
            // Agregar 23:59:59 al final del día para incluir todo el día
            fechaFin = new Date(fechaFin.getTime() + 24 * 60 * 60 * 1000 - 1);
        }

        List<Caja> cajas = cajaDao.filtrarCajas(nombreUsuario, estado, fechaInicio, fechaFin);
        
        request.setAttribute("cajas", cajas);
        request.setAttribute("filtroNombre", nombreUsuario);
        request.setAttribute("filtroEstado", estado);
        request.setAttribute("filtroFechaInicio", fechaInicioStr);
        request.setAttribute("filtroFechaFin", fechaFinStr);
        request.getRequestDispatcher("/admin/cajas.jsp").forward(request, response);
    }

    private void mostrarResumen(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, SQLException, ParseException {
        String fechaInicioStr = request.getParameter("fechaInicio");
        String fechaFinStr = request.getParameter("fechaFin");
        String idUsuarioStr = request.getParameter("idUsuario");

        if (fechaInicioStr == null || fechaFinStr == null || 
            fechaInicioStr.isEmpty() || fechaFinStr.isEmpty()) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write("{\"error\":\"Fechas requeridas\"}");
            return;
        }

        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
        Date fechaInicio = sdf.parse(fechaInicioStr);
        Date fechaFin = sdf.parse(fechaFinStr);
        // Agregar 23:59:59 al final del día
        fechaFin = new Date(fechaFin.getTime() + 24 * 60 * 60 * 1000 - 1);
        
        Integer idUsuario = null;
        if (idUsuarioStr != null && !idUsuarioStr.isEmpty()) {
            try {
                idUsuario = Integer.parseInt(idUsuarioStr);
            } catch (NumberFormatException e) {
                // Ignorar si no es un número válido
            }
        }

        Map<String, Object> resumen = cajaDao.obtenerResumenCajas(fechaInicio, fechaFin, idUsuario);
        
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        
        // Usar ObjectMapper para una mejor serialización JSON
        ObjectMapper mapper = new ObjectMapper();
        String json = mapper.writeValueAsString(resumen);
        
        response.getWriter().write(json);
    }

    private void mostrarDetalles(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, SQLException {
        String idStr = request.getParameter("id");
        
        if (idStr == null || idStr.isEmpty()) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "ID de caja requerido");
            return;
        }
        
        try {
            int idCaja = Integer.parseInt(idStr);
            
            // Obtener datos de la caja
            Caja caja = cajaDao.obtenerCajaPorId(idCaja);
            if (caja == null) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Caja no encontrada");
                return;
            }
            
            // Obtener ventas de la caja
            List<VentaExtra> ventas = cajaDao.obtenerVentasDeCaja(idCaja);
            
            // Calcular totales
            double totalVentas = cajaDao.calcularTotalVentas(idCaja);
            
            request.setAttribute("caja", caja);
            request.setAttribute("ventas", ventas);
            request.setAttribute("totalVentas", totalVentas);
            
            request.getRequestDispatcher("/admin/cajaDetalles.jsp").forward(request, response);
            
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "ID de caja inválido");
        }
    }
}