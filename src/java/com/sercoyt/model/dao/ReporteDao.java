/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.sercoyt.model.dao;

/**
 *
 * @author Arrunategui
 */
import com.sercoyt.config.ConnectDB;
import com.sercoyt.model.VentaExtra;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.HashMap;

public class ReporteDao {

    public List<VentaExtra> listarTodasVentas() throws SQLException {
        return listarVentasFiltradas(null, null, null);
    }

    public List<VentaExtra> listarVentasOnline() throws SQLException {
        return listarVentasFiltradas(2, new int[]{1, 2}, "v.fecha ASC");
    }

    public List<VentaExtra> listarVentasPresenciales() throws SQLException {
        return listarVentasFiltradas(1, null, "v.fecha DESC");
    }

    public List<VentaExtra> listarVentasFiltradas(Integer idTipoVenta, int[] estados, String orden) throws SQLException {
        List<VentaExtra> ventas = new ArrayList<>();

        StringBuilder sql = new StringBuilder("SELECT v.*, "
                + "tv.nombre AS tipoVentaNombre, "
                + "CONCAT(c.nombre, ' ', c.apellido) AS clienteNombre, "
                + "c.documento AS clienteDni, "
                + "ed.descripcion AS estadoNombre, "
                + "fp.metodo AS metodoPagoNombre "
                + "FROM ventas v "
                + "JOIN tipoventa tv ON v.idTipoVenta = tv.idTipoVenta "
                + "LEFT JOIN clientes c ON v.idCliente = c.idCliente "
                + "JOIN estadodespacho ed ON v.idEstado = ed.idEstado "
                + "JOIN formapago fp ON v.idPago = fp.idPago "
                + "WHERE 1=1");

        if (idTipoVenta != null) {
            sql.append(" AND v.idTipoVenta = ?");
        }

        if (estados != null && estados.length > 0) {
            sql.append(" AND v.idEstado IN (");
            for (int i = 0; i < estados.length; i++) {
                sql.append("?");
                if (i < estados.length - 1) {
                    sql.append(",");
                }
            }
            sql.append(")");
        }

        if (orden != null && !orden.isEmpty()) {
            sql.append(" ORDER BY ").append(orden);
        } else {
            sql.append(" ORDER BY v.fecha DESC");
        }

        try (Connection con = ConnectDB.getConnection(); PreparedStatement ps = con.prepareStatement(sql.toString())) {

            int paramIndex = 1;
            if (idTipoVenta != null) {
                ps.setInt(paramIndex++, idTipoVenta);
            }

            if (estados != null) {
                for (int estado : estados) {
                    ps.setInt(paramIndex++, estado);
                }
            }

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    VentaExtra ve = new VentaExtra();
                    ve.setIdVenta(rs.getInt("idVenta"));
                    ve.setFecha(rs.getTimestamp("fecha"));
                    ve.setIdTipoVenta(rs.getInt("idTipoVenta"));
                    ve.setIdCliente(rs.getInt("idCliente"));
                    ve.setIdUsuario(rs.getInt("idUsuario"));
                    ve.setIdEstado(rs.getInt("idEstado"));
                    ve.setIdPago(rs.getInt("idPago"));
                    ve.setSubtotal(rs.getDouble("subtotal"));
                    ve.setIgv(rs.getDouble("igv"));
                    ve.setTotal(rs.getDouble("total"));
                    ve.setTipoVentaNombre(rs.getString("tipoVentaNombre"));
                    ve.setClienteNombre(rs.getString("clienteNombre"));
                    ve.setClienteDni(rs.getString("clienteDni"));
                    ve.setEstadoNombre(rs.getString("estadoNombre"));
                    ve.setMetodoPagoNombre(rs.getString("metodoPagoNombre"));

                    ventas.add(ve);
                }
            }
        }
        return ventas;
    }

    public boolean cambiarEstadoVenta(int idVenta, int nuevoEstado) throws SQLException {
        String sql = "UPDATE ventas SET idEstado = ? WHERE idVenta = ?";

        try (Connection con = ConnectDB.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, nuevoEstado);
            ps.setInt(2, idVenta);

            return ps.executeUpdate() > 0;
        }
    }

    public Map<String, String> obtenerNombresRelacionados(int idVenta) throws SQLException {
        Map<String, String> nombres = new HashMap<>();
        String sql = "SELECT "
                + "tv.nombre AS tipoVentaNombre, "
                + "CONCAT(c.nombre, ' ', c.apellido) AS clienteNombre, "
                + "c.documento AS clienteDni, "
                + "ed.descripcion AS estadoNombre, "
                + "fp.metodo AS metodoPagoNombre "
                + "FROM ventas v "
                + "JOIN tipoventa tv ON v.idTipoVenta = tv.idTipoVenta "
                + "LEFT JOIN clientes c ON v.idCliente = c.idCliente "
                + "JOIN estadodespacho ed ON v.idEstado = ed.idEstado "
                + "JOIN formapago fp ON v.idPago = fp.idPago "
                + "WHERE v.idVenta = ?";

        try (Connection con = ConnectDB.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, idVenta);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    nombres.put("tipoVentaNombre", rs.getString("tipoVentaNombre"));
                    nombres.put("clienteNombre", rs.getString("clienteNombre"));
                    nombres.put("clienteDni", rs.getString("clienteDni"));
                    nombres.put("estadoNombre", rs.getString("estadoNombre"));
                    nombres.put("metodoPagoNombre", rs.getString("metodoPagoNombre"));
                }
            }
        }
        return nombres;
    }

    
public Map<String, Object> obtenerDetallesVenta(int idVenta) throws SQLException {
    Map<String, Object> detalles = new HashMap<>();
    
    // SQL queries CORREGIDAS - usar alias que coincidan con el frontend
    String sqlVenta = "SELECT v.*, tv.nombre AS tipoVentaNombre, ed.descripcion AS estadoNombre, "
            + "fp.metodo AS metodoPagoNombre, CONCAT(COALESCE(c.nombre, ''), ' ', COALESCE(c.apellido, '')) AS clienteNombre, "
            + "c.documento AS clienteDni FROM ventas v "  // CAMBIO: clienteDni en lugar de clienteDni
            + "JOIN tipoventa tv ON v.idTipoVenta = tv.idTipoVenta "
            + "LEFT JOIN clientes c ON v.idCliente = c.idCliente "
            + "JOIN estadodespacho ed ON v.idEstado = ed.idEstado "
            + "JOIN formapago fp ON v.idPago = fp.idPago "
            + "WHERE v.idVenta = ?";
    
    // CAMBIO: usar nombreProducto como alias
    String sqlProductos = "SELECT dv.*, p.nombre AS nombreProducto FROM detalleventa dv "
            + "JOIN productos p ON dv.idProducto = p.idProducto "
            + "WHERE dv.idVenta = ?";
    
    String sqlDireccion = "SELECT * FROM direccionentrega WHERE idVenta = ?";
    
    try (Connection con = ConnectDB.getConnection()) {
        // Obtener datos de la venta
        try (PreparedStatement ps = con.prepareStatement(sqlVenta)) {
            ps.setInt(1, idVenta);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Map<String, Object> ventaMap = rsToMap(rs);
                    
                    // Debugging: mostrar todos los datos obtenidos
                    System.out.println("=== DATOS DE VENTA ID: " + idVenta + " ===");
                    ventaMap.forEach((key, value) -> 
                        System.out.println(key + " = " + value + " (" + (value != null ? value.getClass().getSimpleName() : "null") + ")")
                    );
                    
                    // Limpiar nombre del cliente de forma más robusta
                    String clienteNombre = (String) ventaMap.get("clienteNombre");
                    if (clienteNombre != null) {
                        clienteNombre = clienteNombre.trim();
                        if (clienteNombre.isEmpty()) {
                            ventaMap.put("clienteNombre", null);
                            System.out.println("Cliente nombre limpiado a null");
                        }
                    }
                    
                    // Verificar específicamente el DNI
                    Object clienteDni = ventaMap.get("clienteDni");
                    System.out.println("Cliente DNI obtenido: " + clienteDni);
                    
                    detalles.put("venta", ventaMap);
                } else {
                    System.out.println("No se encontró venta con ID: " + idVenta);
                    return detalles;
                }
            }
        }
        
        // Obtener productos
        List<Map<String, Object>> productos = new ArrayList<>();
        try (PreparedStatement ps = con.prepareStatement(sqlProductos)) {
            ps.setInt(1, idVenta);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    productos.add(rsToMap(rs));
                }
            }
        }
        detalles.put("productos", productos);
        System.out.println("Productos encontrados: " + productos.size());
        
        // Obtener dirección
        try (PreparedStatement ps = con.prepareStatement(sqlDireccion)) {
            ps.setInt(1, idVenta);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Map<String, Object> direccionMap = rsToMap(rs);
                    detalles.put("direccion", direccionMap);
                    System.out.println("Dirección encontrada");
                } else {
                    System.out.println("No se encontró dirección para venta ID: " + idVenta);
                }
            }
        }
        
        // Debug final: mostrar estructura completa
        System.out.println("=== ESTRUCTURA FINAL ===");
        System.out.println("Detalles keys: " + detalles.keySet());
        
    } catch (SQLException e) {
        System.err.println("Error al obtener detalles de venta ID: " + idVenta);
        e.printStackTrace();
        throw e;
    }
    
    return detalles;
}

private Map<String, Object> rsToMap(ResultSet rs) throws SQLException {
    Map<String, Object> map = new HashMap<>();
    ResultSetMetaData metaData = rs.getMetaData();
    int columnCount = metaData.getColumnCount();

    for (int i = 1; i <= columnCount; i++) {
        String columnName = metaData.getColumnName(i);
        Object value = rs.getObject(i);
        
        // Convertir valores null a null explícitamente
        if (rs.wasNull()) {
            value = null;
        }
        
        map.put(columnName, value);
    }

    return map;
}
    
    
    
    public List<VentaExtra> listarVentasFiltradasConFiltros(Integer idTipoVenta, String id, String cliente, String estado, String fecha) throws SQLException {
    List<VentaExtra> ventas = new ArrayList<>();
    StringBuilder sql = new StringBuilder("SELECT v.*, "
            + "tv.nombre AS tipoVentaNombre, "
            + "CONCAT(c.nombre, ' ', c.apellido) AS clienteNombre, "
            + "c.documento AS clienteDni, "
            + "ed.descripcion AS estadoNombre, "
            + "fp.metodo AS metodoPagoNombre "
            + "FROM ventas v "
            + "JOIN tipoventa tv ON v.idTipoVenta = tv.idTipoVenta "
            + "LEFT JOIN clientes c ON v.idCliente = c.idCliente "
            + "JOIN estadodespacho ed ON v.idEstado = ed.idEstado "
            + "JOIN formapago fp ON v.idPago = fp.idPago "
            + "WHERE 1=1");

    List<Object> params = new ArrayList<>();
    if (idTipoVenta != null) {
        sql.append(" AND v.idTipoVenta = ?");
        params.add(idTipoVenta);
    }
    if (id != null && !id.isEmpty()) {
        sql.append(" AND v.idVenta = ?");
        params.add(Integer.parseInt(id));
    }
    if (cliente != null && !cliente.isEmpty()) {
        sql.append(" AND (c.nombre LIKE ? OR c.apellido LIKE ?)");
        params.add("%" + cliente + "%");
        params.add("%" + cliente + "%");
    }
    if (estado != null && !estado.isEmpty()) {
        sql.append(" AND v.idEstado = ?");
        params.add(Integer.parseInt(estado));
    }
    if (fecha != null && !fecha.isEmpty()) {
        sql.append(" AND DATE(v.fecha) = ?");
        params.add(Date.valueOf(fecha));
    }
    sql.append(" ORDER BY v.fecha DESC");

    try (Connection con = ConnectDB.getConnection(); PreparedStatement ps = con.prepareStatement(sql.toString())) {
        for (int i = 0; i < params.size(); i++) {
            ps.setObject(i + 1, params.get(i));
        }
        try (ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                VentaExtra ve = new VentaExtra();
                ve.setIdVenta(rs.getInt("idVenta"));
                ve.setFecha(rs.getTimestamp("fecha"));
                ve.setIdTipoVenta(rs.getInt("idTipoVenta"));
                ve.setIdCliente(rs.getInt("idCliente"));
                ve.setIdUsuario(rs.getInt("idUsuario"));
                ve.setIdEstado(rs.getInt("idEstado"));
                ve.setIdPago(rs.getInt("idPago"));
                ve.setSubtotal(rs.getDouble("subtotal"));
                ve.setIgv(rs.getDouble("igv"));
                ve.setTotal(rs.getDouble("total"));
                ve.setTipoVentaNombre(rs.getString("tipoVentaNombre"));
                ve.setClienteNombre(rs.getString("clienteNombre"));
                ve.setClienteDni(rs.getString("clienteDni"));
                ve.setEstadoNombre(rs.getString("estadoNombre"));
                ve.setMetodoPagoNombre(rs.getString("metodoPagoNombre"));
                ventas.add(ve);
            }
        }
    }
    return ventas;
}

}
