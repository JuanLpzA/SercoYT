package com.sercoyt.controller;

import com.itextpdf.text.DocumentException;
import com.sercoyt.model.*;
import com.sercoyt.model.dao.*;
import com.sercoyt.util.PDFGenerator;
import com.sercoyt.model.Carrito;
import java.io.IOException;
import java.math.BigDecimal;
import java.math.RoundingMode;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.http.*;
import javax.servlet.annotation.WebServlet;

@WebServlet(name = "VentaControlador", urlPatterns = {"/VentaControlador"})
public class VentaControlador extends HttpServlet {
    
    private final VentaDao ventaDao = new VentaDao();
    private final ClienteDao clienteDao = new ClienteDao();
    private final ProductoDao productoDao = new ProductoDao();
    
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String accion = request.getParameter("accion");
        accion = (accion == null) ? "" : accion;
        
        HttpSession session = request.getSession();
        Usuario usuario = (Usuario) session.getAttribute("usuario");
        
        if (usuario == null) {
            response.sendRedirect("UsuarioControlador?accion=login&redirect=carrito");
            return;
        }
        
        try {
            switch (accion) {
                case "generarCompra":
                    generarCompra(request, response, usuario);
                    break;
                case "guardarDireccion":
                    guardarDireccion(request, response, usuario);
                    break;
                case "listarCompras":
                    listarCompras(request, response, usuario);
                    break;
                case "verDetalle":
                    verDetalleCompra(request, response);
                    break;
                case "generarBoleta":
                    generarBoletaPDF(request, response);
                    break;
                default:
                    response.sendRedirect("Controlador?accion=Carrito");
            }
        } catch (Exception e) {
            request.setAttribute("error", "Error al procesar la solicitud: " + e.getMessage());
            request.getRequestDispatcher("error.jsp").forward(request, response);
        }
    }

    private void generarCompra(HttpServletRequest request, HttpServletResponse response, Usuario usuario)
            throws ServletException, IOException, SQLException {

        System.out.println("=== INICIO generarCompra ===");
        System.out.println("Método de pago recibido: " + request.getParameter("metodoPago"));

        HttpSession session = request.getSession();
        List<Carrito> carrito = (List<Carrito>) session.getAttribute("carrito");

        if (carrito == null || carrito.isEmpty()) {
            System.out.println("ERROR: Carrito vacío o null");
            response.setContentType("application/json");
            response.getWriter().write("{\"success\": false, \"error\": \"El carrito está vacío\"}");
            return;
        }

        System.out.println("Carrito tiene " + carrito.size() + " items");

        try {
            // Calcular totales
            double subtotal = carrito.stream().mapToDouble(Carrito::getSubTotal).sum();
            double igv = redondearDecimales(subtotal * 0.18, 2);
            double total = redondearDecimales(subtotal + igv, 2);

            System.out.println("Subtotal: " + subtotal + ", IGV: " + igv + ", Total: " + total);

            // Crear cliente si no existe
            int idCliente = obtenerOcrearCliente(usuario);
            System.out.println("ID Cliente: " + idCliente);

            // Crear venta
            Venta venta = new Venta();
            venta.setFecha(new Date());
            venta.setIdTipoVenta(2); // Virtual
            venta.setIdCliente(idCliente);
            venta.setIdUsuario(usuario.getIdUsuario());
            venta.setIdEstado(1); // En espera
            venta.setIdPago(Integer.parseInt(request.getParameter("metodoPago")));
            venta.setSubtotal(subtotal);
            venta.setIgv(igv);
            venta.setTotal(total);

            System.out.println("Venta creada, registrando en BD...");

            // Crear detalles
            List<DetalleVenta> detalles = new ArrayList<>();
            for (Carrito item : carrito) {
                DetalleVenta detalle = new DetalleVenta();
                detalle.setIdProducto(item.getIdProducto());
                detalle.setCantidad(item.getCantidad());
                detalle.setPrecioUnitario(item.getPrecioCompra());
                detalle.setSubtotal(item.getSubTotal());
                detalles.add(detalle);
            }

            System.out.println("Detalles creados: " + detalles.size() + " items");

            // Registrar venta en la base de datos (sin dirección)
            int idVenta = ventaDao.registrarVenta(venta, detalles);
            System.out.println("Venta registrada con ID: " + idVenta);

            // Guardar ID de venta en sesión para el paso de dirección
            session.setAttribute("idVentaPendiente", idVenta);

            // Responder con JSON de éxito
            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            String jsonResponse = "{\"success\": true, \"idVenta\": " + idVenta + "}";
            System.out.println("Enviando respuesta JSON: " + jsonResponse);
            response.getWriter().write(jsonResponse);
            response.getWriter().flush();

            System.out.println("=== FIN generarCompra EXITOSO ===");

        } catch (Exception e) {
            System.out.println("ERROR en generarCompra: " + e.getMessage());
            e.printStackTrace();

            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            String errorResponse = "{\"success\": false, \"error\": \"" + e.getMessage().replace("\"", "'") + "\"}";
            System.out.println("Enviando respuesta de error: " + errorResponse);
            response.getWriter().write(errorResponse);
            response.getWriter().flush();
        }
    }

    private void guardarDireccion(HttpServletRequest request, HttpServletResponse response, Usuario usuario) 
        throws ServletException, IOException, SQLException {
    
    HttpSession session = request.getSession();
    Integer idVenta = (Integer) session.getAttribute("idVentaPendiente");
    
    if (idVenta == null) {
        response.setContentType("application/json");
        response.getWriter().write("{\"error\": \"No hay venta pendiente para registrar dirección\"}");
        return;
    }
    
    // Construir dirección completa
    String direccionPrincipal = request.getParameter("direccion");
    String direccionSecundaria = request.getParameter("direccion2");
    String distrito = request.getParameter("distrito");
    String ciudad = request.getParameter("ciudad");
    String referencia = request.getParameter("referencia");
    
    StringBuilder direccionCompleta = new StringBuilder();
    direccionCompleta.append(direccionPrincipal);
    if (direccionSecundaria != null && !direccionSecundaria.isEmpty()) {
        direccionCompleta.append(", ").append(direccionSecundaria);
    }
    direccionCompleta.append(", ").append(distrito);
    direccionCompleta.append(", ").append(ciudad);
    direccionCompleta.append(". Referencia: ").append(referencia);
    
    // Crear dirección de entrega
    DireccionEntrega direccion = new DireccionEntrega();
    direccion.setIdVenta(idVenta);
    direccion.setDireccion(direccionCompleta.toString());
    
    // Actualizar venta con dirección
    ventaDao.registrarDireccionEntrega(direccion);
    
    // Limpiar carrito y venta pendiente
    session.removeAttribute("carrito");
    session.removeAttribute("contador");
    session.removeAttribute("idVentaPendiente");
    
    // Guardar ID de venta para mostrar boleta
    session.setAttribute("ultimaVenta", idVenta);
    
    // Responder con JSON incluyendo el ID de venta
    response.setContentType("application/json");
    response.getWriter().write("{\"success\": true, \"idVenta\": " + idVenta + "}");
}
    
    private int obtenerOcrearCliente(Usuario usuario) throws SQLException {
        // Verificar si el cliente ya existe
        Integer idCliente = clienteDao.obtenerIdClientePorDni(usuario.getDni());
        
        if (idCliente == null) {
            // Crear nuevo cliente
            Cliente cliente = new Cliente();
            cliente.setNombre(usuario.getNombre());
            cliente.setApellido(usuario.getApellido());
            cliente.setDni(usuario.getDni());
            cliente.setTelefono(usuario.getTelefono());
            
            idCliente = clienteDao.registrarCliente(cliente);
        }
        
        return idCliente;
    }
    
    private void listarCompras(HttpServletRequest request, HttpServletResponse response, Usuario usuario) 
            throws ServletException, IOException, SQLException {
        
        List<Venta> ventas = ventaDao.listarVentasPorUsuario(usuario.getIdUsuario());
        request.setAttribute("ventas", ventas);
        request.getRequestDispatcher("misCompras.jsp").forward(request, response);
    }
    
    private void verDetalleCompra(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException, SQLException {
        
        int idVenta = Integer.parseInt(request.getParameter("id"));
        
        Venta venta = ventaDao.obtenerVentaPorId(idVenta);
        List<DetalleVenta> detalles = ventaDao.listarDetallesVenta(idVenta);
        DireccionEntrega direccion = ventaDao.obtenerDireccionEntrega(idVenta);
        
        request.setAttribute("venta", venta);
        request.setAttribute("detalles", detalles);
        request.setAttribute("direccion", direccion);
        request.getRequestDispatcher("detalleCompra.jsp").forward(request, response);
    }
    
    private void generarBoletaPDF(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException, SQLException, DocumentException {
        
        int idVenta = Integer.parseInt(request.getParameter("id"));
        
        Venta venta = ventaDao.obtenerVentaPorId(idVenta);
        List<DetalleVenta> detalles = ventaDao.listarDetallesVenta(idVenta);
        
        response.setContentType("application/pdf");
        response.setHeader("Content-disposition", "inline; filename=boleta_" + idVenta + ".pdf");
        
        PDFGenerator.generarBoleta(venta, detalles, response.getOutputStream());
    }
    
    private double redondearDecimales(double valor, int decimales) {
        BigDecimal bd = new BigDecimal(Double.toString(valor));
        bd = bd.setScale(decimales, RoundingMode.HALF_UP);
        return bd.doubleValue();
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