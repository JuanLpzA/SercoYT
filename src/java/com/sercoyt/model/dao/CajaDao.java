package com.sercoyt.model.dao;

import com.sercoyt.config.ConnectDB;
import java.sql.*;
import com.sercoyt.model.*;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Date;

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
    
    // Método nuevo para obtener una caja por ID
    public Caja obtenerCajaPorId(int idCaja) throws SQLException {
        String sql = "SELECT c.*, CONCAT(u.nombre, ' ', u.apellido) AS nombreUsuario " +
                     "FROM caja c " +
                     "JOIN usuarios u ON c.idUsuario = u.idUsuario " +
                     "WHERE c.idCaja = ?";
        try (Connection conn = ConnectDB.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, idCaja);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    Caja caja = new Caja();
                    caja.setIdCaja(rs.getInt("idCaja"));
                    caja.setIdUsuario(rs.getInt("idUsuario"));
                    caja.setFechaApertura(rs.getTimestamp("fechaApertura"));
                    caja.setFechaCierre(rs.getTimestamp("fechaCierre"));
                    caja.setMontoInicial(rs.getDouble("montoInicial"));
                    caja.setMontoFinal(rs.getDouble("montoFinal"));
                    caja.setMontoRecaudado(rs.getDouble("montoRecaudado"));
                    caja.setEstado(rs.getString("estado"));
                    caja.setObservaciones(rs.getString("observaciones"));
                    caja.setNombreUsuario(rs.getString("nombreUsuario"));
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
        String sql = "SELECT v.*, " +
                     "COALESCE(CONCAT(c.nombre, ' ', c.apellido), c.nombre, 'Cliente General') AS clienteNombre, " +
                     "COALESCE(c.documento, 'S/D') AS clienteDni, " +
                     "COALESCE(tv.nombre, 'S/D') AS tipoVentaNombre, " +
                     "COALESCE(ed.descripcion, 'S/D') AS estadoNombre, " +
                     "COALESCE(fp.metodo, 'S/D') AS metodoPagoNombre " +
                     "FROM ventas v " +
                     "JOIN caja_ventas cv ON v.idVenta = cv.idVenta " +
                     "LEFT JOIN clientes c ON v.idCliente = c.idCliente " +
                     "LEFT JOIN tipoVenta tv ON v.idTipoVenta = tv.idTipoVenta " +
                     "LEFT JOIN estadoDespacho ed ON v.idEstado = ed.idEstado " +
                     "LEFT JOIN formaPago fp ON v.idPago = fp.idPago " +
                     "WHERE cv.idCaja = ? " +
                     "ORDER BY v.fecha DESC";
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
    
    public List<Caja> listarTodasLasCajas() throws SQLException {
        String sql = "SELECT c.*, CONCAT(u.nombre, ' ', u.apellido) AS nombreUsuario FROM caja c "
                   + "JOIN usuarios u ON c.idUsuario = u.idUsuario ORDER BY c.fechaApertura DESC";
        List<Caja> cajas = new ArrayList<>();
        try (Connection conn = ConnectDB.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                Caja caja = new Caja();
                caja.setIdCaja(rs.getInt("idCaja"));
                caja.setIdUsuario(rs.getInt("idUsuario"));
                caja.setFechaApertura(rs.getTimestamp("fechaApertura"));
                caja.setFechaCierre(rs.getTimestamp("fechaCierre"));
                caja.setMontoInicial(rs.getDouble("montoInicial"));
                caja.setMontoFinal(rs.getDouble("montoFinal"));
                caja.setMontoRecaudado(rs.getDouble("montoRecaudado"));
                caja.setEstado(rs.getString("estado"));
                caja.setObservaciones(rs.getString("observaciones"));
                caja.setNombreUsuario(rs.getString("nombreUsuario"));
                cajas.add(caja);
            }
        }
        return cajas;
    }

    public List<Caja> filtrarCajas(String nombreUsuario, String estado, Date fechaInicio, Date fechaFin) throws SQLException {
        String sql = "SELECT c.*, CONCAT(u.nombre, ' ', u.apellido) AS nombreUsuario FROM caja c "
                   + "JOIN usuarios u ON c.idUsuario = u.idUsuario WHERE 1=1";
        
        List<Object> params = new ArrayList<>();
        
        if (nombreUsuario != null && !nombreUsuario.isEmpty()) {
            sql += " AND CONCAT(u.nombre, ' ', u.apellido) LIKE ?";
            params.add("%" + nombreUsuario + "%");
        }
        
        if (estado != null && !estado.isEmpty()) {
            sql += " AND c.estado = ?";
            params.add(estado);
        }
        
        if (fechaInicio != null) {
            sql += " AND c.fechaApertura >= ?";
            params.add(new java.sql.Timestamp(fechaInicio.getTime()));
        }
        
        if (fechaFin != null) {
            sql += " AND c.fechaApertura <= ?";
            params.add(new java.sql.Timestamp(fechaFin.getTime()));
        }
        
        sql += " ORDER BY c.fechaApertura DESC";
        
        List<Caja> cajas = new ArrayList<>();
        try (Connection conn = ConnectDB.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            for (int i = 0; i < params.size(); i++) {
                stmt.setObject(i + 1, params.get(i));
            }
            
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Caja caja = new Caja();
                    caja.setIdCaja(rs.getInt("idCaja"));
                    caja.setIdUsuario(rs.getInt("idUsuario"));
                    caja.setFechaApertura(rs.getTimestamp("fechaApertura"));
                    caja.setFechaCierre(rs.getTimestamp("fechaCierre"));
                    caja.setMontoInicial(rs.getDouble("montoInicial"));
                    caja.setMontoFinal(rs.getDouble("montoFinal"));
                    caja.setMontoRecaudado(rs.getDouble("montoRecaudado"));
                    caja.setEstado(rs.getString("estado"));
                    caja.setObservaciones(rs.getString("observaciones"));
                    caja.setNombreUsuario(rs.getString("nombreUsuario"));
                    cajas.add(caja);
                }
            }
        }
        return cajas;
    }

    public Map<String, Object> obtenerResumenCajas(Date fechaInicio, Date fechaFin, Integer idUsuario) throws SQLException {
        String sql = "SELECT COUNT(*) AS totalCajas, "
                   + "COALESCE(SUM(montoInicial), 0) AS totalInicial, "
                   + "COALESCE(SUM(montoFinal), 0) AS totalFinal, "
                   + "COALESCE(SUM(montoRecaudado), 0) AS totalRecaudado, "
                   + "COALESCE(SUM(montoFinal - montoRecaudado), 0) AS diferenciaTotal "
                   + "FROM caja WHERE estado = 'cerrada' "
                   + "AND fechaApertura >= ? AND fechaApertura <= ?";
        
        if (idUsuario != null) {
            sql += " AND idUsuario = ?";
        }
        
        Map<String, Object> resumen = new HashMap<>();
        try (Connection conn = ConnectDB.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setTimestamp(1, new java.sql.Timestamp(fechaInicio.getTime()));
            stmt.setTimestamp(2, new java.sql.Timestamp(fechaFin.getTime()));
            
            if (idUsuario != null) {
                stmt.setInt(3, idUsuario);
            }
            
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    resumen.put("totalCajas", rs.getInt("totalCajas"));
                    resumen.put("totalInicial", rs.getDouble("totalInicial"));
                    resumen.put("totalFinal", rs.getDouble("totalFinal"));
                    resumen.put("totalRecaudado", rs.getDouble("totalRecaudado"));
                    resumen.put("diferenciaTotal", rs.getDouble("diferenciaTotal"));
                } else {
                    // Valores por defecto si no hay resultados
                    resumen.put("totalCajas", 0);
                    resumen.put("totalInicial", 0.0);
                    resumen.put("totalFinal", 0.0);
                    resumen.put("totalRecaudado", 0.0);
                    resumen.put("diferenciaTotal", 0.0);
                }
            }
        }
        return resumen;
    }
}