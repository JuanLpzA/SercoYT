/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.sercoyt.model.dao;

import com.sercoyt.config.ConnectDB;
import com.sercoyt.model.TipoUsuario;
import java.sql.*;
import java.util.*;
/**
 *
 * @author Arrunategui
 */
public class TipoUsuarioDao {
    public List<TipoUsuario> listarTodos() {
        List<TipoUsuario> lista = new ArrayList<>();
        String sql = "SELECT * FROM tipousuario";
        try (Connection con = ConnectDB.getConnection();
             Statement st = con.createStatement();
             ResultSet rs = st.executeQuery(sql)) {
            while (rs.next()) {
                TipoUsuario t = new TipoUsuario();
                t.setIdTipoUsuario(rs.getInt("idTipoUsuario"));
                t.setNombre(rs.getString("nombre"));
                t.setEstadoTipo(rs.getString("estadoTipo"));
                lista.add(t);
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return lista;
    }

    public boolean existeNombre(String nombre, Integer excluirId) {
        String sql = "SELECT COUNT(*) FROM tipousuario WHERE nombre = ?" + (excluirId != null ? " AND idTipoUsuario <> ?" : "");
        try (Connection con = ConnectDB.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, nombre);
            if (excluirId != null) { ps.setInt(2, excluirId); }
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getInt(1) > 0;
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return false;
    }

    public boolean agregar(TipoUsuario tipo) {
        String sql = "INSERT INTO tipousuario (nombre, estadoTipo) VALUES (?, ?)";
        try (Connection con = ConnectDB.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, tipo.getNombre());
            ps.setString(2, tipo.getEstadoTipo());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); return false; }
    }

    public boolean actualizar(TipoUsuario tipo) {
        String sql = "UPDATE tipousuario SET nombre=?, estadoTipo=? WHERE idTipoUsuario=?";
        try (Connection con = ConnectDB.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, tipo.getNombre());
            ps.setString(2, tipo.getEstadoTipo());
            ps.setInt(3, tipo.getIdTipoUsuario());
            boolean updated = ps.executeUpdate() > 0;
            if ("inactivo".equals(tipo.getEstadoTipo())) {
                desactivarUsuariosDeRol(tipo.getIdTipoUsuario(), con);
            }
            return updated;
        } catch (SQLException e) { e.printStackTrace(); return false; }
    }

    public TipoUsuario obtenerPorId(int id) {
        TipoUsuario tipo = null;
        String sql = "SELECT * FROM tipousuario WHERE idTipoUsuario=?";
        try (Connection con = ConnectDB.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    tipo = new TipoUsuario();
                    tipo.setIdTipoUsuario(rs.getInt("idTipoUsuario"));
                    tipo.setNombre(rs.getString("nombre"));
                    tipo.setEstadoTipo(rs.getString("estadoTipo"));
                }
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return tipo;
    }

    private void desactivarUsuariosDeRol(int idTipoUsuario, Connection con) throws SQLException {
        String sql = "UPDATE usuarios SET estadoUsuario='inactivo' WHERE idTipoUsuario=?";
        try (PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, idTipoUsuario);
            ps.executeUpdate();
        }
    }
    
}
