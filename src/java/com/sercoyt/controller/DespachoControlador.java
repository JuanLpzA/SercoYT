package com.sercoyt.controller;

import com.sercoyt.model.VentaExtra;
import com.sercoyt.model.dao.DespachoDao;
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

@WebServlet(name = "DespachoControlador", urlPatterns = {"/DespachoControlador"})
public class DespachoControlador extends HttpServlet {

    private final DespachoDao despachoDao = new DespachoDao();

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
                case "obtenerDetalles":
                    obtenerDetallesVenta(request, response);
                    break;
                default:
                    listarVentasOnline(request, response);
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error en el servidor");
        }
    }

    private void listarVentasOnline(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, SQLException {
        List<VentaExtra> ventas = despachoDao.listarVentasOnline();
        request.setAttribute("ventas", ventas);
        request.setAttribute("filtroActivo", "online");
        request.getRequestDispatcher("/admin/despacho.jsp").forward(request, response);
    }

    private void listarVentasPresenciales(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, SQLException {
        List<VentaExtra> ventas = despachoDao.listarVentasPresenciales();
        request.setAttribute("ventas", ventas);
        request.setAttribute("filtroActivo", "presencial");
        request.getRequestDispatcher("/admin/despacho.jsp").forward(request, response);
    }

    private void cambiarEstadoVenta(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, SQLException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        try {
            int idVenta = Integer.parseInt(request.getParameter("idVenta"));
            int nuevoEstado = Integer.parseInt(request.getParameter("nuevoEstado"));

            boolean exito = despachoDao.cambiarEstadoVenta(idVenta, nuevoEstado);

            JSONObject jsonResponse = new JSONObject();
            jsonResponse.put("success", exito);
            jsonResponse.put("message", exito
                    ? "Estado de venta actualizado correctamente"
                    : "No se pudo actualizar el estado de la venta");

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
            int idVenta = Integer.parseInt(request.getParameter("idVenta"));
            Map<String, Object> detalles = despachoDao.obtenerDetallesVenta(idVenta);

            if (detalles.isEmpty() || !detalles.containsKey("venta")) {
                JSONObject errorResponse = new JSONObject();
                errorResponse.put("error", true);
                errorResponse.put("message", "No se encontraron detalles para la venta especificada");
                response.getWriter().write(errorResponse.toString());
                return;
            }

            JSONObject jsonResponse = new JSONObject(detalles);
            response.getWriter().write(jsonResponse.toString());

        } catch (NumberFormatException e) {
            JSONObject errorResponse = new JSONObject();
            errorResponse.put("error", true);
            errorResponse.put("message", "ID de venta inválido");
            response.getWriter().write(errorResponse.toString());
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
