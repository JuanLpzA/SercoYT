package com.sercoyt.model.dao;

import com.sercoyt.config.ConnectDB;
import com.sercoyt.model.Cliente;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ClienteDao {
    private static final String SQL_SELECT = "SELECT * FROM clientes";
    private static final String SQL_INSERT = "INSERT INTO clientes(nombre, apellido, dni, telefono) VALUES(?, ?, ?, ?)";
    private static final String SQL_UPDATE = "UPDATE clientes SET nombre = ?, apellido = ?, dni = ?, telefono = ? WHERE idCliente = ?";
    private static final String SQL_DELETE = "DELETE FROM clientes WHERE idCliente = ?";
    private static final String SQL_GET_BY_ID = "SELECT * FROM clientes WHERE idCliente = ?";
    private static final String SQL_CHECK_DNI = "SELECT COUNT(*) FROM clientes WHERE dni = ? AND idCliente != ?";

    public int registrarCliente(Cliente cliente) throws SQLException {
        String sql = "INSERT INTO clientes (nombre, apellido, dni, telefono) VALUES (?, ?, ?, ?)";
        int idCliente = 0;

        try (Connection con = ConnectDB.getConnection(); PreparedStatement ps = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            ps.setString(1, cliente.getNombre());
            ps.setString(2, cliente.getApellido());
            ps.setString(3, cliente.getDni());
            ps.setString(4, cliente.getTelefono());

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
        String sql = "SELECT idCliente FROM clientes WHERE dni = ?";

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
                clientes.add(new Cliente(
                    rs.getInt("idCliente"),
                    rs.getString("nombre"),
                    rs.getString("apellido"),
                    rs.getString("dni"),
                    rs.getString("telefono")
                ));
            }
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
        return clientes;
    }

    public int insertar(Cliente cliente) {
        try (Connection conn = ConnectDB.getConnection();
             PreparedStatement stmt = conn.prepareStatement(SQL_INSERT, PreparedStatement.RETURN_GENERATED_KEYS)) {
            
            stmt.setString(1, cliente.getNombre());
            stmt.setString(2, cliente.getApellido());
            stmt.setString(3, cliente.getDni());
            stmt.setString(4, cliente.getTelefono());
            
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

    public boolean actualizar(Cliente cliente) {
        try (Connection conn = ConnectDB.getConnection();
             PreparedStatement stmt = conn.prepareStatement(SQL_UPDATE)) {
            
            stmt.setString(1, cliente.getNombre());
            stmt.setString(2, cliente.getApellido());
            stmt.setString(3, cliente.getDni());
            stmt.setString(4, cliente.getTelefono());
            stmt.setInt(5, cliente.getIdCliente());
            
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
                    return new Cliente(
                        rs.getInt("idCliente"),
                        rs.getString("nombre"),
                        rs.getString("apellido"),
                        rs.getString("dni"),
                        rs.getString("telefono")
                    );
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


}
