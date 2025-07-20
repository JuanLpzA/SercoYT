/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.sercoyt.model.dao;

import com.sercoyt.config.ConnectDB;
import java.sql.*;
import com.sercoyt.model.*;
import java.util.ArrayList;
import java.util.List;


/**
 *
 * @author Arrunategui
 */
public class CajaDao {
    public int abrirCaja(int idUsuario, double montoInicial) throws SQLException {
        String sql = "INSERT INTO caja (idUsuario, montoInicial, estado) VALUES (?, ?, 'abierta')";
        try (Connection conn = ConnectDB.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            stmt.setInt(1, idUsuario);
            stmt.setDouble(2, montoInicial);
            stmt.executeUpdate();
            
            try (ResultSet rs = stmt.getGeneratedKeys()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        }
        return -1;
    }
    
    public boolean cerrarCaja(int idCaja, double montoRecaudado, String observaciones) throws SQLException {
        String sql = "UPDATE caja SET fechaCierre = NOW(), montoRecaudado = ?, "
                   + "montoFinal = montoInicial + (SELECT COALESCE(SUM(v.total), 0) FROM ventas v "
                   + "JOIN caja_ventas cv ON v.idVenta = cv.idVenta WHERE cv.idCaja = ?), "
                   + "estado = 'cerrada', observaciones = ? WHERE idCaja = ?";
        try (Connection conn = ConnectDB.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setDouble(1, montoRecaudado);
            stmt.setInt(2, idCaja);
            stmt.setString(3, observaciones);
            stmt.setInt(4, idCaja);
            return stmt.executeUpdate() > 0;
        }
    }
    
    public Caja obtenerCajaAbierta(int idUsuario) throws SQLException {
        String sql = "SELECT * FROM caja WHERE idUsuario = ? AND estado = 'abierta' ORDER BY fechaApertura DESC LIMIT 1";
        try (Connection conn = ConnectDB.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, idUsuario);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    Caja caja = new Caja();
                    caja.setIdCaja(rs.getInt("idCaja"));
                    caja.setIdUsuario(rs.getInt("idUsuario"));
                    caja.setFechaApertura(rs.getTimestamp("fechaApertura"));
                    caja.setMontoInicial(rs.getDouble("montoInicial"));
                    caja.setEstado(rs.getString("estado"));
                    return caja;
                }
            }
        }
        return null;
    }
    
    public boolean registrarVentaEnCaja(int idCaja, int idVenta) throws SQLException {
        String sql = "INSERT INTO caja_ventas (idCaja, idVenta) VALUES (?, ?)";
        try (Connection conn = ConnectDB.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, idCaja);
            stmt.setInt(2, idVenta);
            return stmt.executeUpdate() > 0;
        }
    }
    
    public List<VentaExtra> obtenerVentasDeCaja(int idCaja) throws SQLException {
        List<VentaExtra> ventas = new ArrayList<>();
        String sql = "SELECT v.*, c.nombre AS clienteNombre, c.documento AS clienteDni, "
                   + "tv.nombre AS tipoVentaNombre, ed.descripcion AS estadoNombre, "
                   + "fp.metodo AS metodoPagoNombre "
                   + "FROM ventas v "
                   + "JOIN caja_ventas cv ON v.idVenta = cv.idVenta "
                   + "LEFT JOIN clientes c ON v.idCliente = c.idCliente "
                   + "JOIN tipoVenta tv ON v.idTipoVenta = tv.idTipoVenta "
                   + "JOIN estadoDespacho ed ON v.idEstado = ed.idEstado "
                   + "JOIN formaPago fp ON v.idPago = fp.idPago "
                   + "WHERE cv.idCaja = ? "
                   + "ORDER BY v.fecha DESC";
        try (Connection conn = ConnectDB.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, idCaja);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    VentaExtra venta = new VentaExtra();
                    venta.setIdVenta(rs.getInt("idVenta"));
                    venta.setFecha(rs.getTimestamp("fecha"));
                    venta.setClienteNombre(rs.getString("clienteNombre"));
                    venta.setClienteDni(rs.getString("clienteDni"));
                    venta.setTipoVentaNombre(rs.getString("tipoVentaNombre"));
                    venta.setEstadoNombre(rs.getString("estadoNombre"));
                    venta.setMetodoPagoNombre(rs.getString("metodoPagoNombre"));
                    venta.setTotal(rs.getDouble("total"));
                    ventas.add(venta);
                }
            }
        }
        return ventas;
    }
    
    public double calcularTotalVentas(int idCaja) throws SQLException {
        String sql = "SELECT COALESCE(SUM(v.total), 0) AS total FROM ventas v "
                   + "JOIN caja_ventas cv ON v.idVenta = cv.idVenta WHERE cv.idCaja = ?";
        try (Connection conn = ConnectDB.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, idCaja);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getDouble("total");
                }
            }
        }
        return 0;
    }
    
}
