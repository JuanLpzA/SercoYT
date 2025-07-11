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

public class DespachoDao {

    public List<VentaExtra> listarVentasOnline() throws SQLException {
        return listarVentasFiltradas(2, new int[]{1, 2}, "v.fecha ASC");
    }

    public List<VentaExtra> listarVentasPresenciales() throws SQLException {
        return listarVentasFiltradas(1, new int[]{5}, "v.fecha DESC");
    }

    private List<VentaExtra> listarVentasFiltradas(Integer idTipoVenta, int[] estados, String orden) throws SQLException {
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

        sql.append(" ORDER BY ").append(orden);

        try (Connection con = ConnectDB.getConnection(); 
             PreparedStatement ps = con.prepareStatement(sql.toString())) {

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

        try (Connection con = ConnectDB.getConnection(); 
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, nuevoEstado);
            ps.setInt(2, idVenta);

            return ps.executeUpdate() > 0;
        }
    }

    public Map<String, Object> obtenerDetallesVenta(int idVenta) throws SQLException {
        Map<String, Object> detalles = new HashMap<>();
        
        String sqlVenta = "SELECT v.*, tv.nombre AS tipoVentaNombre, ed.descripcion AS estadoNombre, "
                + "fp.metodo AS metodoPagoNombre, CONCAT(COALESCE(c.nombre, ''), ' ', COALESCE(c.apellido, '')) AS clienteNombre, "
                + "c.documento AS clienteDni FROM ventas v "
                + "JOIN tipoventa tv ON v.idTipoVenta = tv.idTipoVenta "
                + "LEFT JOIN clientes c ON v.idCliente = c.idCliente "
                + "JOIN estadodespacho ed ON v.idEstado = ed.idEstado "
                + "JOIN formapago fp ON v.idPago = fp.idPago "
                + "WHERE v.idVenta = ?";
        
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
                        Map<String, Object> ventaMap = new HashMap<>();
                        ResultSetMetaData metaData = rs.getMetaData();
                        int columnCount = metaData.getColumnCount();

                        for (int i = 1; i <= columnCount; i++) {
                            ventaMap.put(metaData.getColumnName(i), rs.getObject(i));
                        }
                        detalles.put("venta", ventaMap);
                    }
                }
            }
            
            // Obtener productos
            List<Map<String, Object>> productos = new ArrayList<>();
            try (PreparedStatement ps = con.prepareStatement(sqlProductos)) {
                ps.setInt(1, idVenta);
                try (ResultSet rs = ps.executeQuery()) {
                    while (rs.next()) {
                        Map<String, Object> productoMap = new HashMap<>();
                        ResultSetMetaData metaData = rs.getMetaData();
                        int columnCount = metaData.getColumnCount();

                        for (int i = 1; i <= columnCount; i++) {
                            productoMap.put(metaData.getColumnName(i), rs.getObject(i));
                        }
                        productos.add(productoMap);
                    }
                }
            }
            detalles.put("productos", productos);
            
            // Obtener dirección
            try (PreparedStatement ps = con.prepareStatement(sqlDireccion)) {
                ps.setInt(1, idVenta);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        Map<String, Object> direccionMap = new HashMap<>();
                        ResultSetMetaData metaData = rs.getMetaData();
                        int columnCount = metaData.getColumnCount();

                        for (int i = 1; i <= columnCount; i++) {
                            direccionMap.put(metaData.getColumnName(i), rs.getObject(i));
                        }
                        detalles.put("direccion", direccionMap);
                    }
                }
            }
        }
        return detalles;
    }
}
