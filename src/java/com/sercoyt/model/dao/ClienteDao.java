package com.sercoyt.model.dao;

import com.sercoyt.config.ConnectDB;
import com.sercoyt.model.Cliente;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ClienteDao {
    private static final String SQL_SELECT = "SELECT c.idCliente, c.nombre, c.apellido, c.documento, c.telefono, c.idTipoCliente, tc.descripcion as tipoCliente, c.estadoCliente, c.api FROM clientes c INNER JOIN tipocliente tc ON c.idTipoCliente = tc.idTipoCliente ORDER BY c.idCliente ASC";
    private static final String SQL_INSERT = "INSERT INTO clientes(nombre, apellido, documento, telefono, idTipoCliente, estadoCliente, api) VALUES(?, ?, ?, ?, ?, ?, ?)";
    private static final String SQL_UPDATE = "UPDATE clientes SET nombre = ?, apellido = ?, documento = ?, telefono = ?, idTipoCliente = ? WHERE idCliente = ?";
    private static final String SQL_DELETE = "DELETE FROM clientes WHERE idCliente = ?";
    private static final String SQL_GET_BY_ID = "SELECT c.idCliente, c.nombre, c.apellido, c.documento, c.telefono, c.idTipoCliente, tc.descripcion as tipoCliente, c.estadoCliente, c.api FROM clientes c INNER JOIN tipocliente tc ON c.idTipoCliente = tc.idTipoCliente WHERE c.idCliente = ?";
    private static final String SQL_CHECK_DNI = "SELECT COUNT(*) FROM clientes WHERE documento = ? AND idCliente != ?";

    public int registrarCliente(Cliente cliente) throws SQLException {
        String sql = "INSERT INTO clientes (nombre, apellido, documento, telefono, idTipoCliente, estadoCliente, api) VALUES (?, ?, ?, ?, ?, ?, ?)";
        int idCliente = 0;

        try (Connection con = ConnectDB.getConnection(); PreparedStatement ps = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            ps.setString(1, cliente.getNombre());
            ps.setString(2, cliente.getApellido());
            ps.setString(3, cliente.getDocumento());
            ps.setString(4, cliente.getTelefono());
            ps.setInt(5, 1);
            ps.setString(6, "activo");
            ps.setInt(7, 1);

            int affectedRows = ps.executeUpdate();

            if (affectedRows == 0) {
                throw new SQLException("No se pudo registrar el cliente");
            }

            try (ResultSet rs = ps.getGeneratedKeys()) {
                if (rs.next()) {
                    idCliente = rs.getInt(1);
                }
            }
        }
        return idCliente;
    }

    public Integer obtenerIdClientePorDni(String dni) throws SQLException {
        String sql = "SELECT idCliente FROM clientes WHERE documento = ?";

        try (Connection con = ConnectDB.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, dni);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("idCliente");
                }
            }
        }
        return null;
    }
    
    
    //para el dashboard
    public int contarClientes() throws SQLException {
        String sql = "SELECT COUNT(*) FROM clientes";
        try (Connection con = ConnectDB.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        }
        return 0;
    }
    
    public List<Cliente> listarTodos() {
    List<Cliente> clientes = new ArrayList<>();
    try (Connection conn = ConnectDB.getConnection(); 
         PreparedStatement stmt = conn.prepareStatement(SQL_SELECT); 
         ResultSet rs = stmt.executeQuery()) {

        while (rs.next()) {
            Cliente cliente = new Cliente(
                    rs.getInt("idCliente"),
                    rs.getString("nombre"),
                    rs.getString("apellido"),
                    rs.getString("documento"),
                    rs.getString("telefono"),
                    rs.getString("tipoCliente")
            );
            cliente.setIdTipoCliente(rs.getInt("idTipoCliente"));
            cliente.setEstadoCliente(rs.getString("estadoCliente"));
            cliente.setApi(rs.getInt("api"));
            clientes.add(cliente);
        }
    } catch (SQLException ex) {
        ex.printStackTrace();
    }
    return clientes;
}


    public int insertar(Cliente cliente, int tipoCliente, int api) {
    try (Connection conn = ConnectDB.getConnection();
         PreparedStatement stmt = conn.prepareStatement(SQL_INSERT, PreparedStatement.RETURN_GENERATED_KEYS)) {
        
        stmt.setString(1, cliente.getNombre());
        stmt.setString(2, cliente.getApellido());
        stmt.setString(3, cliente.getDocumento());
        stmt.setString(4, cliente.getTelefono());
        stmt.setInt(5, tipoCliente);
        stmt.setString(6, "activo"); // estado por defecto
        stmt.setInt(7, api); // 1 si fue creado por API, 0 si fue manual
        
        int affectedRows = stmt.executeUpdate();
        if (affectedRows > 0) {
            try (ResultSet generatedKeys = stmt.getGeneratedKeys()) {
                if (generatedKeys.next()) {
                    return generatedKeys.getInt(1);
                }
            }
        }
    } catch (SQLException ex) {
        ex.printStackTrace();
    }
    return -1;
}


    public boolean actualizar(Cliente cliente, int tipoCliente) {
    try (Connection conn = ConnectDB.getConnection();
         PreparedStatement stmt = conn.prepareStatement(SQL_UPDATE)) {
        
        stmt.setString(1, cliente.getNombre());
        stmt.setString(2, cliente.getApellido());
        stmt.setString(3, cliente.getDocumento());
        stmt.setString(4, cliente.getTelefono());
        stmt.setInt(5, tipoCliente);
        stmt.setInt(6, cliente.getIdCliente());
        
        return stmt.executeUpdate() > 0;
    } catch (SQLException ex) {
        ex.printStackTrace();
        return false;
    }
}
    
    public boolean cambiarEstado(int id, String estado) {
    String sql = "UPDATE clientes SET estadoCliente = ? WHERE idCliente = ?";
    
    System.out.println("DAO - Ejecutando cambio de estado:");
    System.out.println("  SQL: " + sql);
    System.out.println("  ID: " + id);
    System.out.println("  Estado: " + estado);
    
    try (Connection conn = ConnectDB.getConnection();
         PreparedStatement stmt = conn.prepareStatement(sql)) {
        
        stmt.setString(1, estado);
        stmt.setInt(2, id);
        
        int filasAfectadas = stmt.executeUpdate();
        System.out.println("  Filas afectadas: " + filasAfectadas);
        
        if (filasAfectadas > 0) {
            System.out.println("  Estado cambiado exitosamente");
            return true;
        } else {
            System.out.println("  No se encontró el cliente con ID: " + id);
            return false;
        }
        
    } catch (SQLException ex) {
        System.out.println("Error SQL al cambiar estado:");
        System.out.println("  Mensaje: " + ex.getMessage());
        System.out.println("  Código: " + ex.getErrorCode());
        ex.printStackTrace();
        return false;
    } catch (Exception ex) {
        System.out.println("Error general al cambiar estado: " + ex.getMessage());
        ex.printStackTrace();
        return false;
    }
}

    public boolean eliminar(int id) {
        try (Connection conn = ConnectDB.getConnection();
             PreparedStatement stmt = conn.prepareStatement(SQL_DELETE)) {
            
            stmt.setInt(1, id);
            return stmt.executeUpdate() > 0;
        } catch (SQLException ex) {
            ex.printStackTrace();
            return false;
        }
    }

    public Cliente obtenerPorId(int id) {
    try (Connection conn = ConnectDB.getConnection();
         PreparedStatement stmt = conn.prepareStatement(SQL_GET_BY_ID)) {
        
        stmt.setInt(1, id);
        try (ResultSet rs = stmt.executeQuery()) {
            if (rs.next()) {
                Cliente cliente = new Cliente(
                    rs.getInt("idCliente"),
                    rs.getString("nombre"),
                    rs.getString("apellido"),
                    rs.getString("documento"),
                    rs.getString("telefono"),
                    rs.getString("tipoCliente")
                );
                cliente.setIdTipoCliente(rs.getInt("idTipoCliente"));
                cliente.setEstadoCliente(rs.getString("estadoCliente"));
                cliente.setApi(rs.getInt("api"));
                return cliente;
            }
        }
    } catch (SQLException ex) {
        ex.printStackTrace();
    }
    return null;
}

    public boolean existeDni(String dni, int idExcluir) {
        try (Connection conn = ConnectDB.getConnection();
             PreparedStatement stmt = conn.prepareStatement(SQL_CHECK_DNI)) {
            
            stmt.setString(1, dni);
            stmt.setInt(2, idExcluir);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
        return false;
    }
    
    public boolean existeDocumento(String documento, int idExcluir) {
    String sql = "SELECT COUNT(*) FROM clientes WHERE documento = ? AND idCliente != ?";
    try (Connection conn = ConnectDB.getConnection();
         PreparedStatement stmt = conn.prepareStatement(sql)) {
        
        stmt.setString(1, documento);
        stmt.setInt(2, idExcluir);
        try (ResultSet rs = stmt.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
        }
    } catch (SQLException ex) {
        ex.printStackTrace();
    }
    return false;
}
    
    public Cliente obtenerPorDocumento(String documento) throws SQLException {
    String sql = "SELECT c.idCliente, c.nombre, c.apellido, c.documento, c.telefono, " +
                 "c.idTipoCliente, tc.descripcion as tipoCliente, c.estadoCliente, c.api " +
                 "FROM clientes c INNER JOIN tipocliente tc ON c.idTipoCliente = tc.idTipoCliente " +
                 "WHERE c.documento = ?";
    
    try (Connection conn = ConnectDB.getConnection();
         PreparedStatement stmt = conn.prepareStatement(sql)) {
        
        stmt.setString(1, documento);
        try (ResultSet rs = stmt.executeQuery()) {
            if (rs.next()) {
                Cliente cliente = new Cliente();
                cliente.setIdCliente(rs.getInt("idCliente"));
                cliente.setNombre(rs.getString("nombre"));
                cliente.setApellido(rs.getString("apellido"));
                cliente.setDocumento(rs.getString("documento"));
                cliente.setTelefono(rs.getString("telefono"));
                cliente.setTipoCliente(rs.getString("tipoCliente"));
                cliente.setIdTipoCliente(rs.getInt("idTipoCliente"));
                cliente.setEstadoCliente(rs.getString("estadoCliente"));
                cliente.setApi(rs.getInt("api"));
                return cliente;
            }
        }
    }
    return null;
}


}