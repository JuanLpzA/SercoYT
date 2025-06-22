package com.sercoyt.model.dao;

import com.sercoyt.config.ConnectDB;
import com.sercoyt.model.Cliente;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ClienteDao {
    private static final String SQL_SELECT = "SELECT c.idCliente, c.nombre, c.apellido, c.documento, c.telefono, c.idTipoCliente, tc.descripcion as tipoCliente FROM clientes c INNER JOIN tipocliente tc ON c.idTipoCliente = tc.idTipoCliente ORDER BY c.idCliente ASC";
    private static final String SQL_INSERT = "INSERT INTO clientes(nombre, apellido, documento, telefono, idTipoCliente) VALUES(?, ?, ?, ?, ?)";
    private static final String SQL_UPDATE = "UPDATE clientes SET nombre = ?, apellido = ?, documento = ?, telefono = ?, idTipoCliente = ? WHERE idCliente = ?";
    private static final String SQL_DELETE = "DELETE FROM clientes WHERE idCliente = ?";
    private static final String SQL_GET_BY_ID = "SELECT c.idCliente, c.nombre, c.apellido, c.documento, c.telefono, c.idTipoCliente, tc.descripcion as tipoCliente FROM clientes c INNER JOIN tipocliente tc ON c.idTipoCliente = tc.idTipoCliente WHERE c.idCliente = ?";
    private static final String SQL_CHECK_DNI = "SELECT COUNT(*) FROM clientes WHERE documento = ? AND idCliente != ?";

    public int registrarCliente(Cliente cliente) throws SQLException {
        String sql = "INSERT INTO clientes (nombre, apellido, documento, telefono, idTipoCliente) VALUES (?, ?, ?, ?, ?)";
        int idCliente = 0;

        try (Connection con = ConnectDB.getConnection(); PreparedStatement ps = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            ps.setString(1, cliente.getNombre());
            ps.setString(2, cliente.getApellido());
            ps.setString(3, cliente.getDocumento());
            ps.setString(4, cliente.getTelefono());
            ps.setInt(5, 1);

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
        try (Connection conn = ConnectDB.getConnection(); PreparedStatement stmt = conn.prepareStatement(SQL_SELECT); ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                Cliente cliente = new Cliente(
                        rs.getInt("idCliente"),
                        rs.getString("nombre"),
                        rs.getString("apellido"),
                        rs.getString("documento"),
                        rs.getString("telefono"),
                        rs.getString("tipoCliente")
                );
                cliente.setIdTipoCliente(rs.getInt("idTipoCliente")); // AGREGAR ESTA LÍNEA
                clientes.add(cliente);
            }
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
        return clientes;
    }

    public int insertar(Cliente cliente, int tipoCliente) {
    try (Connection conn = ConnectDB.getConnection();
         PreparedStatement stmt = conn.prepareStatement(SQL_INSERT, PreparedStatement.RETURN_GENERATED_KEYS)) {
        
        stmt.setString(1, cliente.getNombre());
        stmt.setString(2, cliente.getApellido());
        stmt.setString(3, cliente.getDocumento());
        stmt.setString(4, cliente.getTelefono());
        stmt.setInt(5, tipoCliente);
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
        stmt.setInt(5, tipoCliente); // CAMBIAR: ahora recibe tipoCliente como parámetro
        stmt.setInt(6, cliente.getIdCliente()); // CAMBIAR: ahora es el parámetro 6
        
        return stmt.executeUpdate() > 0;
    } catch (SQLException ex) {
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
                // AGREGAR ESTA LÍNEA:
                cliente.setIdTipoCliente(rs.getInt("idTipoCliente"));
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


}
