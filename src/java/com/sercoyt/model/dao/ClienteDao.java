package com.sercoyt.model.dao;

import com.sercoyt.config.ConnectDB;
import com.sercoyt.model.Cliente;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ClienteDao {
    
    public int registrarCliente(Cliente cliente) throws SQLException {
        String sql = "INSERT INTO clientes (nombre, apellido, dni, telefono) VALUES (?, ?, ?, ?)";
        int idCliente = 0;
        
        try (Connection con = ConnectDB.getConnection();
             PreparedStatement ps = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            
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
        
        try (Connection con = ConnectDB.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            
            ps.setString(1, dni);
            
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("idCliente");
                }
            }
        }
        return null;
    }
}