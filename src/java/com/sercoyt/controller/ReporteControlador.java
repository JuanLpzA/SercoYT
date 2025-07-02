package com.sercoyt.controller;

import com.sercoyt.model.VentaExtra;
import com.sercoyt.model.dao.ReporteDao;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;
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
        
        try {
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