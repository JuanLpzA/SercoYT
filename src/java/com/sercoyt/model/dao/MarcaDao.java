package com.sercoyt.model.dao;

import com.sercoyt.config.ConnectDB;
import com.sercoyt.model.Marca;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class MarcaDao {
    private static final String SQL_SELECT = "SELECT * FROM marcas";
    private static final String SQL_SELECT2 = "SELECT * FROM marcas WHERE estadoMarca='activo'";
    private static final String SQL_INSERT = "INSERT INTO marcas(nombre, estadoMarca) VALUES(?, ?)";
    private static final String SQL_UPDATE = "UPDATE marcas SET nombre = ?, estadoMarca = ? WHERE idMarca = ?";
    private static final String SQL_DELETE = "UPDATE marcas SET estadoMarca = 'inactivo' WHERE idMarca = ?";
    private static final String SQL_ACTIVE = "UPDATE marcas SET estadoMarca = 'activo' WHERE idMarca = ?";
    private static final String SQL_GET_BY_ID = "SELECT * FROM marcas WHERE idMarca = ?";
    private static final String SQL_CHECK_NOMBRE = "SELECT COUNT(*) FROM marcas WHERE nombre = ? AND idMarca != ?";

    public List<Marca> listar() {
        List<Marca> marcas = new ArrayList<>();
        try (Connection conn = ConnectDB.getConnection();
             PreparedStatement stmt = conn.prepareStatement(SQL_SELECT);
             ResultSet rs = stmt.executeQuery()) {
            
            while (rs.next()) {
                int id = rs.getInt("idMarca");
                String nombre = rs.getString("nombre");
                String estado = rs.getString("estadoMarca");
                
                marcas.add(new Marca(id, nombre, estado));
            }
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
        return marcas;
    }
    
    public List<Marca> listarActivo() {
        List<Marca> marcas = new ArrayList<>();
        try (Connection conn = ConnectDB.getConnection();
             PreparedStatement stmt = conn.prepareStatement(SQL_SELECT2);
             ResultSet rs = stmt.executeQuery()) {
            
            while (rs.next()) {
                int id = rs.getInt("idMarca");
                String nombre = rs.getString("nombre");
                String estado = rs.getString("estadoMarca");
                
                marcas.add(new Marca(id, nombre, estado));
            }
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
        return marcas;
    }

    public int insertar(Marca marca) {
        try (Connection conn = ConnectDB.getConnection();
             PreparedStatement stmt = conn.prepareStatement(SQL_INSERT, PreparedStatement.RETURN_GENERATED_KEYS)) {
            
            stmt.setString(1, marca.getNombre());
            stmt.setString(2, marca.getEstado());
            
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

    public boolean actualizar(Marca marca) {
        try (Connection conn = ConnectDB.getConnection();
             PreparedStatement stmt = conn.prepareStatement(SQL_UPDATE)) {
            
            stmt.setString(1, marca.getNombre());
            stmt.setString(2, marca.getEstado());
            stmt.setInt(3, marca.getId());
            
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
    
    public boolean activar(int id) {
        try (Connection conn = ConnectDB.getConnection();
             PreparedStatement stmt = conn.prepareStatement(SQL_ACTIVE)) {
            
            stmt.setInt(1, id);
            return stmt.executeUpdate() > 0;
        } catch (SQLException ex) {
            ex.printStackTrace();
            return false;
        }
    }
    
    

    public Marca obtenerPorId(int id) {
        try (Connection conn = ConnectDB.getConnection();
             PreparedStatement stmt = conn.prepareStatement(SQL_GET_BY_ID)) {
            
            stmt.setInt(1, id);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return new Marca(
                        rs.getInt("idMarca"),
                        rs.getString("nombre"),
                        rs.getString("estadoMarca")
                    );
                }
            }
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
        return null;
    }

    public boolean existeNombre(String nombre, int idExcluir) {
        try (Connection conn = ConnectDB.getConnection();
             PreparedStatement stmt = conn.prepareStatement(SQL_CHECK_NOMBRE)) {
            
            stmt.setString(1, nombre);
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