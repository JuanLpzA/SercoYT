package com.sercoyt.controller;

import com.itextpdf.text.DocumentException;
import com.sercoyt.model.*;
import com.sercoyt.model.dao.*;
import com.sercoyt.util.PDFGenerator;
import java.io.*;
import java.math.BigDecimal;
import java.math.RoundingMode;
import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.util.*;
import javax.servlet.ServletException;
import javax.servlet.http.*;
import javax.servlet.annotation.WebServlet;
import org.json.JSONObject;

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
                case "generarCompraCompleta":
                    generarCompraCompleta(request, response, usuario);
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
            sendJsonError(response, "Error al procesar la solicitud: " + e.getMessage());
        }
    }

    private void generarCompraCompleta(HttpServletRequest request, HttpServletResponse response, Usuario usuario)
            throws ServletException, IOException, SQLException, DocumentException {

        HttpSession session = request.getSession();
        List<Carrito> carrito = (List<Carrito>) session.getAttribute("carrito");

        if (carrito == null || carrito.isEmpty()) {
            sendJsonError(response, "El carrito está vacío");
            return;
        }

        try {
            // 1. Parsear datos de dirección
            JSONObject direccionJson = new JSONObject(request.getParameter("direccion"));

            // 2. Calcular totales
            double subtotal = carrito.stream().mapToDouble(Carrito::getSubTotal).sum();
            double igv = redondearDecimales(subtotal * 0.18, 2);
            double total = redondearDecimales(subtotal + igv, 2);

            // 3. Crear o obtener cliente
            int idCliente = obtenerOcrearCliente(usuario);

            // 4. Crear venta
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

            // 5. Crear detalles
            List<DetalleVenta> detalles = new ArrayList<>();
            for (Carrito item : carrito) {
                DetalleVenta detalle = new DetalleVenta();
                detalle.setIdProducto(item.getIdProducto());
                detalle.setCantidad(item.getCantidad());
                detalle.setPrecioUnitario(item.getPrecioCompra());
                detalle.setSubtotal(item.getSubTotal());
                detalles.add(detalle);
            }

            // 6. Registrar venta y detalles
            int idVenta = ventaDao.registrarVenta(venta, detalles);

            // 7. Registrar dirección de entrega (MODIFICADO)
            DireccionEntrega direccion = new DireccionEntrega();
            direccion.setIdVenta(idVenta);
            direccion.setNombreReceptor(direccionJson.getString("nombreReceptor"));
            direccion.setTelefono(direccionJson.getString("telefono"));
            direccion.setProvincia(direccionJson.getString("provincia"));
            direccion.setDireccion(direccionJson.getString("direccion"));

            // Campos opcionales
            if (direccionJson.has("referencia") && !direccionJson.getString("referencia").isEmpty()) {
                direccion.setReferencia(direccionJson.getString("referencia"));
            }

            if (direccionJson.has("codigoPostal") && !direccionJson.getString("codigoPostal").isEmpty()) {
                direccion.setCodigoPostal(direccionJson.getString("codigoPostal"));
            }

            ventaDao.registrarDireccionEntrega(direccion);

            // 8. Generar y guardar PDF
            String pdfPath = generarYGuardarBoleta(idVenta);

            // 9. Limpiar carrito
            session.removeAttribute("carrito");
            session.removeAttribute("contador");

            // 10. Responder con éxito
            sendJsonSuccess(response, idVenta);

        } catch (Exception e) {
            sendJsonError(response, "Error al procesar la compra: " + e.getMessage());
        }
    }

    private String construirDireccionCompleta(JSONObject direccionJson) {
        StringBuilder sb = new StringBuilder();
        sb.append("Receptor: ").append(direccionJson.getString("nombreReceptor"));
        sb.append(" | Tel: ").append(direccionJson.getString("telefono"));
        sb.append(" | Provincia: ").append(direccionJson.getString("provincia"));
        sb.append(" | Dirección: ").append(direccionJson.getString("direccion"));

        if (direccionJson.has("referencia") && !direccionJson.getString("referencia").isEmpty()) {
            sb.append(" | Ref: ").append(direccionJson.getString("referencia"));
        }

        if (direccionJson.has("codigoPostal") && !direccionJson.getString("codigoPostal").isEmpty()) {
            sb.append(" | CP: ").append(direccionJson.getString("codigoPostal"));
        }

        return sb.toString();
    }

    private String generarYGuardarBoleta(int idVenta)
            throws SQLException, IOException, DocumentException {

        Venta venta = ventaDao.obtenerVentaPorId(idVenta);
        List<DetalleVenta> detalles = ventaDao.listarDetallesVenta(idVenta);

        // Obtener la ruta absoluta al directorio /pdf dentro del contexto del proyecto web
        String pdfDir = ServletContextProvider.getContextServlet().getRealPath("SercoYT/web/pdf");
        File dir = new File(pdfDir);
        if (!dir.exists()) {
            dir.mkdirs();
        }

        // Crear nombre de archivo con timestamp
        String nombreArchivo = "boleta_" + idVenta + "_"
                + new SimpleDateFormat("yyyyMMddHHmmss").format(new Date()) + ".pdf";

        String filePath = pdfDir + File.separator + nombreArchivo;

        try (OutputStream fileOut = new FileOutputStream(filePath)) {
            PDFGenerator.generarBoleta(venta, detalles, fileOut);
        }

        System.out.println("PDF generado correctamente en: " + filePath);
        return filePath;
    }

    private void sendJsonSuccess(HttpServletResponse response, int idVenta) throws IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        response.getWriter().write("{\"success\": true, \"idVenta\": " + idVenta + "}");
    }

    private void sendJsonError(HttpServletResponse response, String message) throws IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        response.getWriter().write("{\"success\": false, \"error\": \"" + message + "\"}");
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

        // Obtenemos el DNI del usuario logueado
        String dniUsuario = usuario.getDni();

        // Buscamos las ventas asociadas a este DNI (a través de la tabla clientes)
        List<VentaExtra> ventas = ventaDao.listarVentasCompletasPorClienteDni(dniUsuario);

        request.setAttribute("ventas", ventas);
        request.getRequestDispatcher("misPedidos.jsp").forward(request, response);
    }

    private void verDetalleCompra(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, SQLException {

        int idVenta = Integer.parseInt(request.getParameter("id"));

        // Primero obtenemos la venta básica
        Venta venta = ventaDao.obtenerVentaPorId(idVenta);

        if (venta == null) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "Venta no encontrada");
            return;
        }

        // Convertimos a VentaExtra con todos los datos relacionados
        VentaExtra ventaExtra = new VentaExtra();
        ventaExtra.setIdVenta(venta.getIdVenta());
        ventaExtra.setFecha(venta.getFecha());
        ventaExtra.setIdTipoVenta(venta.getIdTipoVenta());
        ventaExtra.setIdCliente(venta.getIdCliente());
        ventaExtra.setIdUsuario(venta.getIdUsuario());
        ventaExtra.setIdEstado(venta.getIdEstado());
        ventaExtra.setIdPago(venta.getIdPago());
        ventaExtra.setSubtotal(venta.getSubtotal());
        ventaExtra.setIgv(venta.getIgv());
        ventaExtra.setTotal(venta.getTotal());

        // Obtenemos los nombres relacionados
        Map<String, String> nombresRelacionados = ventaDao.obtenerNombresRelacionados(idVenta);
        ventaExtra.setTipoVentaNombre(nombresRelacionados.get("tipoVentaNombre"));
        ventaExtra.setClienteNombre(nombresRelacionados.get("clienteNombre"));
        ventaExtra.setClienteDni(nombresRelacionados.get("clienteDni"));
        ventaExtra.setEstadoNombre(nombresRelacionados.get("estadoNombre"));
        ventaExtra.setMetodoPagoNombre(nombresRelacionados.get("metodoPagoNombre"));

        List<DetalleVenta> detalles = ventaDao.listarDetallesVenta(idVenta);
        DireccionEntrega direccion = ventaDao.obtenerDireccionEntrega(idVenta);

        request.setAttribute("venta", ventaExtra);
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
