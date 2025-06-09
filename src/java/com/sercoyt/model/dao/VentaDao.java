package com.sercoyt.model.dao;

import com.sercoyt.config.ConnectDB;
import com.sercoyt.model.Venta;
import com.sercoyt.model.DetalleVenta;
import com.sercoyt.model.DireccionEntrega;
import com.sercoyt.model.VentaExtra;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.HashMap;

public class VentaDao {

    public int registrarVenta(Venta venta, List<DetalleVenta> detalles) throws SQLException {
        Connection con = null;
        PreparedStatement psVenta = null;
        PreparedStatement psDetalle = null;
        ResultSet rs = null;
        int idVenta = 0;

        try {
            con = ConnectDB.getConnection();
            con.setAutoCommit(false);

            // Registrar la venta
            String sqlVenta = "INSERT INTO ventas (fecha, idTipoVenta, idCliente, idUsuario, idEstado, idPago, subtotal, igv, total) "
                    + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
            psVenta = con.prepareStatement(sqlVenta, Statement.RETURN_GENERATED_KEYS);
            psVenta.setTimestamp(1, new Timestamp(venta.getFecha().getTime()));
            psVenta.setInt(2, venta.getIdTipoVenta());
            psVenta.setInt(3, venta.getIdCliente());
            psVenta.setInt(4, venta.getIdUsuario());
            psVenta.setInt(5, venta.getIdEstado());
            psVenta.setInt(6, venta.getIdPago());
            psVenta.setDouble(7, venta.getSubtotal());
            psVenta.setDouble(8, venta.getIgv());
            psVenta.setDouble(9, venta.getTotal());

            int affectedRows = psVenta.executeUpdate();

            if (affectedRows == 0) {
                throw new SQLException("No se pudo registrar la venta");
            }

            rs = psVenta.getGeneratedKeys();
            if (rs.next()) {
                idVenta = rs.getInt(1);
            } else {
                throw new SQLException("No se pudo obtener el ID de la venta");
            }

            // Registrar detalles de venta
            String sqlDetalle = "INSERT INTO detalleventa (idVenta, idProducto, cantidad, precioUnitario, subtotal) "
                    + "VALUES (?, ?, ?, ?, ?)";
            psDetalle = con.prepareStatement(sqlDetalle);

            for (DetalleVenta detalle : detalles) {
                psDetalle.setInt(1, idVenta);
                psDetalle.setInt(2, detalle.getIdProducto());
                psDetalle.setInt(3, detalle.getCantidad());
                psDetalle.setDouble(4, detalle.getPrecioUnitario());
                psDetalle.setDouble(5, detalle.getSubtotal());
                psDetalle.addBatch();

                // Actualizar stock
                actualizarStock(con, detalle.getIdProducto(), -detalle.getCantidad());
            }

            psDetalle.executeBatch();

            con.commit();
            return idVenta;

        } catch (SQLException e) {
            if (con != null) {
                con.rollback();
            }
            throw e;
        } finally {
            if (rs != null) {
                rs.close();
            }
            if (psVenta != null) {
                psVenta.close();
            }
            if (psDetalle != null) {
                psDetalle.close();
            }
            if (con != null) {
                con.close();
            }
        }
    }

    private void actualizarStock(Connection con, int idProducto, int cantidad) throws SQLException {
        String sql = "UPDATE productos SET stock = stock + ? WHERE idProducto = ?";
        try (PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, cantidad);
            ps.setInt(2, idProducto);
            ps.executeUpdate();
        }
    }

    public List<Venta> listarVentasPorUsuario(int idUsuario) throws SQLException {
        List<Venta> ventas = new ArrayList<>();
        String sql = "SELECT * FROM ventas WHERE idUsuario = ? ORDER BY fecha DESC";

        try (Connection con = ConnectDB.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, idUsuario);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Venta v = new Venta();
                    v.setIdVenta(rs.getInt("idVenta"));
                    v.setFecha(rs.getTimestamp("fecha"));
                    v.setIdTipoVenta(rs.getInt("idTipoVenta"));
                    v.setIdCliente(rs.getInt("idCliente"));
                    v.setIdUsuario(rs.getInt("idUsuario"));
                    v.setIdEstado(rs.getInt("idEstado"));
                    v.setIdPago(rs.getInt("idPago"));
                    v.setSubtotal(rs.getDouble("subtotal"));
                    v.setIgv(rs.getDouble("igv"));
                    v.setTotal(rs.getDouble("total"));
                    ventas.add(v);
                }
            }
        }
        return ventas;
    }

    public List<DetalleVenta> listarDetallesVenta(int idVenta) throws SQLException {
        List<DetalleVenta> detalles = new ArrayList<>();
        String sql = "SELECT d.*, p.nombre as nombreProducto FROM detalleventa d "
                + "JOIN productos p ON d.idProducto = p.idProducto "
                + "WHERE d.idVenta = ?";

        try (Connection con = ConnectDB.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, idVenta);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    DetalleVenta d = new DetalleVenta();
                    d.setIdDetalle(rs.getInt("idDetalle"));
                    d.setIdVenta(rs.getInt("idVenta"));
                    d.setIdProducto(rs.getInt("idProducto"));
                    d.setCantidad(rs.getInt("cantidad"));
                    d.setPrecioUnitario(rs.getDouble("precioUnitario"));
                    d.setSubtotal(rs.getDouble("subtotal"));
                    d.setNombreProducto(rs.getString("nombreProducto"));

                    detalles.add(d);
                }
            }
        }
        return detalles;
    }

    public DireccionEntrega obtenerDireccionEntrega(int idVenta) throws SQLException {
        String sql = "SELECT * FROM direccionentrega WHERE idVenta = ?";

        try (Connection con = ConnectDB.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, idVenta);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    DireccionEntrega de = new DireccionEntrega();
                    de.setIdEntrega(rs.getInt("idEntrega"));
                    de.setIdVenta(rs.getInt("idVenta"));
                    de.setDireccion(rs.getString("direccion"));
                    return de;
                }
            }
        }
        return null;
    }

    public void registrarDireccionEntrega(DireccionEntrega direccion) throws SQLException {
        String sql = "INSERT INTO direccionentrega (idVenta, direccion) VALUES (?, ?)";

        try (Connection con = ConnectDB.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, direccion.getIdVenta());
            ps.setString(2, direccion.getDireccion());
            ps.executeUpdate();
        }
    }

    public Venta obtenerVentaPorId(int idVenta) throws SQLException {
        String sql = "SELECT * FROM ventas WHERE idVenta = ?";
        Venta venta = null;

        try (Connection con = ConnectDB.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, idVenta);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    venta = new Venta();
                    venta.setIdVenta(rs.getInt("idVenta"));
                    venta.setFecha(rs.getTimestamp("fecha"));
                    venta.setIdTipoVenta(rs.getInt("idTipoVenta"));
                    venta.setIdCliente(rs.getInt("idCliente"));
                    venta.setIdUsuario(rs.getInt("idUsuario"));
                    venta.setIdEstado(rs.getInt("idEstado"));
                    venta.setIdPago(rs.getInt("idPago"));
                    venta.setSubtotal(rs.getDouble("subtotal"));
                    venta.setIgv(rs.getDouble("igv"));
                    venta.setTotal(rs.getDouble("total"));
                }
            }
        }
        return venta;
    }

// Añadidos para la busqueda de ventas ya realizadas en tu cuenta
    public List<VentaExtra> listarVentasCompletasPorClienteDni(String dni) throws SQLException {
        List<VentaExtra> ventas = new ArrayList<>();
        String sql = "SELECT v.*, "
                + "tv.nombre AS tipoVentaNombre, "
                + "CONCAT(c.nombre, ' ', c.apellido) AS clienteNombre, "
                + "c.dni AS clienteDni, "
                + "ed.descripcion AS estadoNombre, "
                + "fp.metodo AS metodoPagoNombre "
                + "FROM ventas v "
                + "JOIN tipoventa tv ON v.idTipoVenta = tv.idTipoVenta "
                + "JOIN clientes c ON v.idCliente = c.idCliente "
                + "JOIN estadodespacho ed ON v.idEstado = ed.idEstado "
                + "JOIN formapago fp ON v.idPago = fp.idPago "
                + "WHERE c.dni = ? "
                + "ORDER BY v.fecha DESC";

        try (Connection con = ConnectDB.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, dni);

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

    public Map<String, String> obtenerNombresRelacionados(int idVenta) throws SQLException {
        Map<String, String> nombres = new HashMap<>();
        String sql = "SELECT "
                + "tv.nombre AS tipoVentaNombre, "
                + "CONCAT(c.nombre, ' ', c.apellido) AS clienteNombre, "
                + "c.dni AS clienteDni, "
                + "ed.descripcion AS estadoNombre, "
                + "fp.metodo AS metodoPagoNombre "
                + "FROM ventas v "
                + "JOIN tipoventa tv ON v.idTipoVenta = tv.idTipoVenta "
                + "JOIN clientes c ON v.idCliente = c.idCliente "
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
    
    //para el dashboard
    public int contarVentasUltimaSemana() throws SQLException {
    String sql = "SELECT COUNT(*) FROM ventas WHERE fecha >= DATE_SUB(CURDATE(), INTERVAL 7 DAY)";
    try (Connection con = ConnectDB.getConnection();
         PreparedStatement ps = con.prepareStatement(sql);
         ResultSet rs = ps.executeQuery()) {
        if (rs.next()) {
            return rs.getInt(1);
        }
    }
    return 0;
}

public double calcularIngresosUltimaSemana() throws SQLException {
    String sql = "SELECT COALESCE(SUM(total), 0) FROM ventas WHERE fecha >= DATE_SUB(CURDATE(), INTERVAL 7 DAY)";
    try (Connection con = ConnectDB.getConnection();
         PreparedStatement ps = con.prepareStatement(sql);
         ResultSet rs = ps.executeQuery()) {
        if (rs.next()) {
            return rs.getDouble(1);
        }
    }
    return 0.0;
}

}
