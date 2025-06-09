package com.sercoyt.controller;

import com.sercoyt.model.dao.ClienteDao;
import com.sercoyt.model.dao.ProductoDao;
import com.sercoyt.model.dao.VentaDao;
import java.io.IOException;
import java.sql.SQLException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet(name = "DashboardControlador", urlPatterns = {"/DashboardControlador"})
public class DashboardControlador extends HttpServlet {

    private final ProductoDao productoDao = new ProductoDao();
    private final ClienteDao clienteDao = new ClienteDao();
    private final VentaDao ventaDao = new VentaDao();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int totalProductos = productoDao.contarProductosActivos();
            int totalClientes = clienteDao.contarClientes();
            int ventasSemana = ventaDao.contarVentasUltimaSemana();
            double ingresosSemana = ventaDao.calcularIngresosUltimaSemana();

            request.setAttribute("totalProductos", totalProductos);
            request.setAttribute("totalClientes", totalClientes);
            request.setAttribute("ventasSemana", ventasSemana);
            request.setAttribute("ingresosSemana", ingresosSemana);

            request.getRequestDispatcher("/admin/dashboard.jsp").forward(request, response);
        } catch (SQLException e) {
            throw new ServletException("Error al cargar estadísticas del dashboard", e);
        }
    }
}