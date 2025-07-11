

import com.itextpdf.text.DocumentException;
import com.sercoyt.model.*;
import com.sercoyt.model.dao.*;
import com.sercoyt.util.PDFGenerator;
import java.io.IOException;
import java.math.BigDecimal;
import java.math.RoundingMode;
import java.sql.SQLException;
import java.util.*;
import javax.servlet.ServletException;
import javax.servlet.http.*;
import org.json.JSONArray;
import org.json.JSONObject;

public class VentaPresencialControlador extends HttpServlet {

    private final VentaDao ventaDao = new VentaDao();
    private final ClienteDao clienteDao = new ClienteDao();
    private final ProductoDao productoDao = new ProductoDao();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String accion = request.getParameter("accion");
        
        if (accion == null) {
            accion = "default";
        }

        try {
            switch (accion) {
                case "buscarCliente":
                    buscarCliente(request, response);
                    break;
                case "buscarProducto":
                    buscarProducto(request, response);
                    break;
                case "generarBoleta":
                    generarBoletaPDF(request, response);
                    break;
                case "inicio":
                    mostrarVentaInicio(request, response);
                default:
                    mostrarVentaPresencial(request, response);
            }
        } catch (Exception e) {
            enviarErrorJson(response, "Error: " + e.getMessage());
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String accion = request.getParameter("accion");
        
        try {
            switch (accion) {
                case "registrarCliente":
                    registrarCliente(request, response);
                    break;
                case "finalizarVenta":
                    finalizarVenta(request, response);
                    break;
                default:
                    enviarErrorJson(response, "Acción no válida");
            }
        } catch (Exception e) {
            enviarErrorJson(response, "Error: " + e.getMessage());
        }
    }

    private void mostrarVentaPresencial(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, SQLException {
        List<Producto> productos = productoDao.listarActivos();
        request.setAttribute("productos", productos);
        request.getRequestDispatcher("/admin/ventapresencial.jsp").forward(request, response);
    }
    
    private void mostrarVentaInicio(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, SQLException {
        List<Producto> productos = productoDao.listarActivos();
        request.setAttribute("productos", productos);
        request.getRequestDispatcher("/admin/ventapresencialinicio.jsp").forward(request, response);
    }

    private void buscarCliente(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, SQLException {
        String tipoDocumento = request.getParameter("tipoDocumento");
        String documento = request.getParameter("documento");
        
        JSONObject respuesta = new JSONObject();
        
        // Validar documento según tipo
        if (tipoDocumento.equals("1") && documento.length() != 8) { // DNI
            respuesta.put("error", "El DNI debe tener 8 dígitos");
        } else if (tipoDocumento.equals("2") && documento.length() != 11) { // RUC
            respuesta.put("error", "El RUC debe tener 11 dígitos");
        } else if (tipoDocumento.equals("3") && documento.length() != 10) { // Carnet extranjería
            respuesta.put("error", "El Carnet de Extranjería debe tener 10 dígitos");
        } else {
            // Buscar cliente en la base de datos
            Cliente cliente = clienteDao.obtenerPorDocumento(documento);
            
            if (cliente != null) {
                respuesta.put("existe", true);
                respuesta.put("cliente", new JSONObject(cliente));
            } else {
                respuesta.put("existe", false);
                respuesta.put("tipoDocumento", tipoDocumento);
                respuesta.put("documento", documento);
            }
        }
        
        response.setContentType("application/json");
        response.getWriter().write(respuesta.toString());
    }

    private void registrarCliente(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, SQLException {
        String tipoDocumento = request.getParameter("tipoDocumento");
        String documento = request.getParameter("documento");
        String nombre = request.getParameter("nombre");
        String apellido = request.getParameter("apellido");
        String telefono = request.getParameter("telefono");
        
        Cliente cliente = new Cliente();
        cliente.setNombre(nombre);
        cliente.setApellido(apellido);
        cliente.setDocumento(documento);
        cliente.setTelefono(telefono);
        
        int idCliente = clienteDao.insertar(cliente, Integer.parseInt(tipoDocumento), 0);
        
        JSONObject respuesta = new JSONObject();
        if (idCliente > 0) {
            respuesta.put("success", true);
            respuesta.put("idCliente", idCliente);
            respuesta.put("nombreCompleto", nombre + " " + apellido);
        } else {
            respuesta.put("error", "No se pudo registrar el cliente");
        }
        
        response.setContentType("application/json");
        response.getWriter().write(respuesta.toString());
    }

    private void buscarProducto(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, SQLException {
        String filtro = request.getParameter("filtro");
        List<Producto> productos;
        
        if (filtro == null || filtro.isEmpty()) {
            productos = productoDao.listarActivos();
        } else {
            productos = productoDao.filtrarProductos(filtro, null, null, null, null);
        }
        
        JSONObject respuesta = new JSONObject();
        respuesta.put("productos", productos);
        
        response.setContentType("application/json");
        response.getWriter().write(respuesta.toString());
    }

    private void finalizarVenta(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, SQLException {
        HttpSession session = request.getSession();
        Usuario usuario = (Usuario) session.getAttribute("usuario");
        
        if (usuario == null) {
            enviarErrorJson(response, "No hay usuario autenticado");
            return;
        }
        
        // Parsear datos del carrito desde JSON
        JSONObject datos = new JSONObject(request.getParameter("datos"));
        int idCliente = datos.getInt("idCliente");
        int metodoPago = datos.getInt("metodoPago");
        JSONArray carritoJson = datos.getJSONArray("carrito");
        
        // Convertir JSONArray a List<DetalleVenta>
        List<DetalleVenta> detalles = new ArrayList<>();
        double subtotal = 0;
        
        for (int i = 0; i < carritoJson.length(); i++) {
            JSONObject item = carritoJson.getJSONObject(i);
            DetalleVenta detalle = new DetalleVenta();
            detalle.setIdProducto(item.getInt("idProducto"));
            detalle.setCantidad(item.getInt("cantidad"));
            detalle.setPrecioUnitario(item.getDouble("precio"));
            detalle.setSubtotal(item.getDouble("subtotal"));
            detalles.add(detalle);
            
            subtotal += detalle.getSubtotal();
        }
        
        // Calcular totales
        double igv = redondearDecimales(subtotal * 0.18, 2);
        double total = redondearDecimales(subtotal + igv, 2);
        
        // Crear venta
        Venta venta = new Venta();
        venta.setFecha(new Date());
        venta.setIdTipoVenta(1); // Presencial
        venta.setIdCliente(idCliente);
        venta.setIdUsuario(usuario.getIdUsuario());
        venta.setIdEstado(3); // Entregado (venta presencial)
        venta.setIdPago(metodoPago);
        venta.setSubtotal(subtotal);
        venta.setIgv(igv);
        venta.setTotal(total);
        
        // Registrar venta
        int idVenta = ventaDao.registrarVenta(venta, detalles);
        
        // Generar respuesta
        JSONObject respuesta = new JSONObject();
        if (idVenta > 0) {
            respuesta.put("success", true);
            respuesta.put("idVenta", idVenta);
        } else {
            respuesta.put("error", "No se pudo registrar la venta");
        }
        
        response.setContentType("application/json");
        response.getWriter().write(respuesta.toString());
    }

    private void generarBoletaPDF(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {
    
    System.out.println("=== Iniciando generación de PDF ===");
    
    try {
        String idParam = request.getParameter("id");
        System.out.println("ID recibido: " + idParam);
        
        if (idParam == null || idParam.trim().isEmpty()) {
            System.err.println("ID de venta no proporcionado");
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "ID de venta requerido");
            return;
        }
        
        int idVenta = Integer.parseInt(idParam);
        System.out.println("ID parseado: " + idVenta);
        
        // Verificar venta
        Venta venta = ventaDao.obtenerVentaPorId(idVenta);
        if (venta == null) {
            System.err.println("Venta no encontrada para ID: " + idVenta);
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "Venta no encontrada");
            return;
        }
        System.out.println("Venta encontrada: " + venta.getIdVenta());
        
        // Verificar detalles
        List<DetalleVenta> detalles = ventaDao.listarDetallesVenta(idVenta);
        if (detalles == null || detalles.isEmpty()) {
            System.err.println("No se encontraron detalles para la venta: " + idVenta);
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "No se encontraron detalles de la venta");
            return;
        }
        System.out.println("Detalles encontrados: " + detalles.size());
        
        // Configurar respuesta ANTES de escribir cualquier cosa
        response.reset(); // Limpiar cualquier contenido previo
        response.setContentType("application/pdf");
        response.setHeader("Content-Disposition", "inline; filename=boleta_" + idVenta + ".pdf");
        response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
        response.setHeader("Pragma", "no-cache");
        response.setHeader("Expires", "0");
        
        System.out.println("Headers configurados, generando PDF...");
        
        // Generar PDF
        PDFGenerator.generarBoleta(venta, detalles, response.getOutputStream());
        
        System.out.println("PDF generado exitosamente");
        
    } catch (NumberFormatException e) {
        System.err.println("Error al parsear ID: " + e.getMessage());
        response.sendError(HttpServletResponse.SC_BAD_REQUEST, "ID de venta inválido");
    } catch (SQLException e) {
        System.err.println("Error de base de datos: " + e.getMessage());
        e.printStackTrace();
        response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error de base de datos");
    } catch (DocumentException e) {
        System.err.println("Error al generar PDF: " + e.getMessage());
        e.printStackTrace();
        response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error al generar PDF");
    } catch (Exception e) {
        System.err.println("Error inesperado: " + e.getMessage());
        e.printStackTrace();
        response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error interno del servidor");
    }
}

    private double redondearDecimales(double valor, int decimales) {
        BigDecimal bd = new BigDecimal(Double.toString(valor));
        bd = bd.setScale(decimales, RoundingMode.HALF_UP);
        return bd.doubleValue();
    }

    private void enviarErrorJson(HttpServletResponse response, String mensaje) throws IOException {
        JSONObject error = new JSONObject();
        error.put("error", mensaje);
        
        response.setContentType("application/json");
        response.getWriter().write(error.toString());
    }
}