/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.sercoyt.model.dao;

import com.sercoyt.config.ConnectDB;
import com.sercoyt.model.Categoria;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
/**
 *
 * @author Arrunategui
 */
public class CategoriaDao {
    private static final String SQL_SELECT = "SELECT * FROM categorias";
    private static final String SQL_INSERT = "INSERT INTO categorias(nombre, estadoCategoria) VALUES(?, ?)";
    private static final String SQL_UPDATE = "UPDATE categorias SET nombre = ?, estadoCategoria = ? WHERE idCategoria = ?";
    private static final String SQL_DELETE = "UPDATE categorias SET estadoCategoria = 'inactivo' WHERE idCategoria = ?";
    private static final String SQL_GET_BY_ID = "SELECT * FROM categorias WHERE idCategoria = ?";
    private static final String SQL_CHECK_NOMBRE = "SELECT COUNT(*) FROM categorias WHERE nombre = ? AND idCategoria != ?";

    public List<Categoria> listar() {
        List<Categoria> categorias = new ArrayList<>();
        try (Connection conn = ConnectDB.getConnection();
             PreparedStatement stmt = conn.prepareStatement(SQL_SELECT);
             ResultSet rs = stmt.executeQuery()) {
            
            while (rs.next()) {
                int id = rs.getInt("idCategoria");
                String nombre = rs.getString("nombre");
                String estado = rs.getString("estadoCategoria");
                
                categorias.add(new Categoria(id, nombre, estado));
            }
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
        return categorias;
    }

    public int insertar(Categoria categoria) {
        try (Connection conn = ConnectDB.getConnection();
             PreparedStatement stmt = conn.prepareStatement(SQL_INSERT, PreparedStatement.RETURN_GENERATED_KEYS)) {
            
            stmt.setString(1, categoria.getNombre());
            stmt.setString(2, categoria.getEstado());
            
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

    public boolean actualizar(Categoria categoria) {
        try (Connection conn = ConnectDB.getConnection();
             PreparedStatement stmt = conn.prepareStatement(SQL_UPDATE)) {
            
            stmt.setString(1, categoria.getNombre());
            stmt.setString(2, categoria.getEstado());
            stmt.setInt(3, categoria.getId());
            
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

    public Categoria obtenerPorId(int id) {
        try (Connection conn = ConnectDB.getConnection();
             PreparedStatement stmt = conn.prepareStatement(SQL_GET_BY_ID)) {
            
            stmt.setInt(1, id);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return new Categoria(
                        rs.getInt("idCategoria"),
                        rs.getString("nombre"),
                        rs.getString("estadoCategoria")
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
