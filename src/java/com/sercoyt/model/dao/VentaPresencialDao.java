package com.sercoyt.model.dao;

import com.sercoyt.config.ConnectDB;
import com.sercoyt.model.Cliente;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class VentaPresencialDao {
   
    public Cliente buscarPorDocumento(String documento) throws SQLException {
        String sql = "SELECT c.idCliente, c.nombre, c.apellido, c.documento, c.telefono, "
                   + "tc.descripcion as tipoCliente FROM clientes c "
                   + "JOIN tipocliente tc ON c.idTipoCliente = tc.idTipoCliente "
                   + "WHERE c.documento = ?";
        
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
                    return cliente;
                }
            }
        }
        return null;
    }
}