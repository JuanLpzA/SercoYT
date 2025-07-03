package com.sercoyt.controller;

import com.sercoyt.model.VentaExtra;
import com.sercoyt.model.dao.ReporteDao;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;
import java.util.Map;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.json.JSONObject;

@WebServlet(name = "ReporteControlador", urlPatterns = {"/ReporteControlador"})
public class ReporteControlador extends HttpServlet {

    private final ReporteDao reporteDao = new ReporteDao();

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {
    String accion = request.getParameter("accion");
    accion = (accion == null) ? "" : accion;

    boolean hayFiltros = request.getParameter("id") != null ||
                         request.getParameter("cliente") != null ||
                         request.getParameter("estado") != null ||
                         request.getParameter("fecha") != null;

    try {
        if (hayFiltros) {
            listarVentasFiltradas(request, response);
            return;
        }
        switch (accion) {
            case "listarOnline":
                listarVentasOnline(request, response);
                break;
            case "listarPresencial":
                listarVentasPresenciales(request, response);
                break;
            case "cambiarEstado":
                cambiarEstadoVenta(request, response);
                break;
            case "obtenerDetalles":
                obtenerDetallesVenta(request, response);
                break;
            default:
                listarTodasVentas(request, response);
        }
    } catch (Exception e) {
        e.printStackTrace();
        response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error en el servidor");
    }
}
    
    private void listarTodasVentas(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, SQLException {
        List<VentaExtra> ventas = reporteDao.listarTodasVentas();
        request.setAttribute("ventas", ventas);
        request.setAttribute("filtroActivo", "todas");
        request.getRequestDispatcher("/admin/reportes.jsp").forward(request, response);
    }
    
    private void listarVentasOnline(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, SQLException {
        List<VentaExtra> ventas = reporteDao.listarVentasOnline();
        request.setAttribute("ventas", ventas);
        request.setAttribute("filtroActivo", "online");
        request.getRequestDispatcher("/admin/reportes.jsp").forward(request, response);
    }
    
    private void listarVentasPresenciales(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, SQLException {
        List<VentaExtra> ventas = reporteDao.listarVentasPresenciales();
        request.setAttribute("ventas", ventas);
        request.setAttribute("filtroActivo", "presencial");
        request.getRequestDispatcher("/admin/reportes.jsp").forward(request, response);
    }
    
    private void cambiarEstadoVenta(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, SQLException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        
        try {
            int idVenta = Integer.parseInt(request.getParameter("idVenta"));
            int nuevoEstado = Integer.parseInt(request.getParameter("nuevoEstado"));
            
            boolean exito = reporteDao.cambiarEstadoVenta(idVenta, nuevoEstado);
            
            JSONObject jsonResponse = new JSONObject();
            jsonResponse.put("success", exito);
            
            if (exito) {
                jsonResponse.put("message", "Estado de venta actualizado correctamente");
            } else {
                jsonResponse.put("message", "No se pudo actualizar el estado de la venta");
            }
            
            response.getWriter().write(jsonResponse.toString());
            
        } catch (NumberFormatException e) {
            JSONObject jsonResponse = new JSONObject();
            jsonResponse.put("success", false);
            jsonResponse.put("message", "Parámetros inválidos");
            response.getWriter().write(jsonResponse.toString());
        }
    }
    
    private void obtenerDetallesVenta(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException, SQLException {
    response.setContentType("application/json");
    response.setCharacterEncoding("UTF-8");
    
    try {
        // Obtener idVenta desde la URL o parámetro
        String idVentaStr = request.getParameter("idVenta");
        
        // Si no viene como parámetro, extraer de pathInfo
        if (idVentaStr == null) {
            String pathInfo = request.getPathInfo();
            if (pathInfo != null && pathInfo.length() > 1) {
                idVentaStr = pathInfo.substring(1); // Remover el '/' inicial
            }
        }
        
        System.out.println("ID Venta recibido: " + idVentaStr);
        
        if (idVentaStr == null || idVentaStr.trim().isEmpty()) {
            JSONObject errorResponse = new JSONObject();
            errorResponse.put("error", true);
            errorResponse.put("message", "ID de venta requerido");
            response.getWriter().write(errorResponse.toString());
            return;
        }
        
        int idVenta = Integer.parseInt(idVentaStr);
        Map<String, Object> detalles = reporteDao.obtenerDetallesVenta(idVenta);
        
        // Debugging: verificar datos antes de enviar
        System.out.println("=== DATOS ANTES DE ENVIAR AL FRONTEND ===");
        if (detalles.containsKey("venta")) {
            Map<String, Object> venta = (Map<String, Object>) detalles.get("venta");
            System.out.println("Cliente DNI en controlador: " + venta.get("clienteDni"));
            System.out.println("Cliente Nombre en controlador: " + venta.get("clienteNombre"));
        }
        
        // Verificar si se encontraron detalles
        if (detalles.isEmpty() || !detalles.containsKey("venta")) {
            JSONObject errorResponse = new JSONObject();
            errorResponse.put("error", true);
            errorResponse.put("message", "No se encontraron detalles para la venta especificada");
            response.getWriter().write(errorResponse.toString());
            return;
        }
        
        JSONObject jsonResponse = new JSONObject(detalles);
        String jsonString = jsonResponse.toString();
        
        // Debug: mostrar JSON que se envía
        System.out.println("JSON enviado: " + jsonString);
        
        response.getWriter().write(jsonString);
        
    } catch (NumberFormatException e) {
        System.err.println("Error parsing ID venta: " + e.getMessage());
        JSONObject errorResponse = new JSONObject();
        errorResponse.put("error", true);
        errorResponse.put("message", "ID de venta inválido");
        response.getWriter().write(errorResponse.toString());
    } catch (Exception e) {
        System.err.println("Error en obtenerDetallesVenta: " + e.getMessage());
        e.printStackTrace();
        JSONObject errorResponse = new JSONObject();
        errorResponse.put("error", true);
        errorResponse.put("message", "Error interno del servidor");
        response.getWriter().write(errorResponse.toString());
    }
}
    
    private void listarVentasFiltradas(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException, SQLException {
    String id = request.getParameter("id");
    String cliente = request.getParameter("cliente");
    String estado = request.getParameter("estado");
    String fecha = request.getParameter("fecha");
    String accion = request.getParameter("accion");

    Integer idTipoVenta = null;
    if ("listarOnline".equals(accion)) idTipoVenta = 2;
    else if ("listarPresencial".equals(accion)) idTipoVenta = 1;

    List<VentaExtra> ventas = reporteDao.listarVentasFiltradasConFiltros(idTipoVenta, id, cliente, estado, fecha);
    request.setAttribute("ventas", ventas);
    request.setAttribute("filtroActivo", accion == null ? "todas" : (accion.equals("listarOnline") ? "online" : "presencial"));
    request.getRequestDispatcher("/admin/reportes.jsp").forward(request, response);
}

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
}