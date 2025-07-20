/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.sercoyt.model.dao;


import com.sercoyt.config.ConnectDB;
import com.sercoyt.model.Permiso;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author Arrunategui
 */
public class PermisoDao {
    private Connection conn;
    
    public PermisoDao() {
        try {
            conn = ConnectDB.getConnection();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
    
    /**
     * Verifica si un tipo de usuario tiene permiso para un recurso y acción específicos
     */
    public boolean tienePermiso(int idTipoUsuario, String recurso, String accion) {
        String sql = "SELECT permitido FROM permisos WHERE idTipoUsuario = ? AND recurso = ? AND (accion = ? OR accion = 'ALL')";
        
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, idTipoUsuario);
            ps.setString(2, recurso);
            ps.setString(3, accion);
            
            ResultSet rs = ps.executeQuery();
            
            // Si encuentra un permiso específico para la acción, lo retorna
            while (rs.next()) {
                if (rs.getBoolean("permitido")) {
                    return true;
                }
            }
            
            // Si no encuentra permiso específico, verifica si tiene permiso ALL
            String sqlAll = "SELECT permitido FROM permisos WHERE idTipoUsuario = ? AND recurso = ? AND accion = 'ALL'";
            try (PreparedStatement psAll = conn.prepareStatement(sqlAll)) {
                psAll.setInt(1, idTipoUsuario);
                psAll.setString(2, recurso);
                
                ResultSet rsAll = psAll.executeQuery();
                if (rsAll.next()) {
                    return rsAll.getBoolean("permitido");
                }
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return false; // Por defecto no tiene permiso
    }
    
    /**
     * Obtiene todos los permisos de un tipo de usuario
     */
    public List<Permiso> obtenerPermisosPorTipoUsuario(int idTipoUsuario) {
        List<Permiso> permisos = new ArrayList<>();
        String sql = "SELECT * FROM permisos WHERE idTipoUsuario = ? ORDER BY recurso, accion";
        
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, idTipoUsuario);
            ResultSet rs = ps.executeQuery();
            
            while (rs.next()) {
                Permiso permiso = new Permiso();
                permiso.setIdPermiso(rs.getInt("idPermiso"));
                permiso.setIdTipoUsuario(rs.getInt("idTipoUsuario"));
                permiso.setRecurso(rs.getString("recurso"));
                permiso.setAccion(rs.getString("accion"));
                permiso.setPermitido(rs.getBoolean("permitido"));
                permiso.setFechaCreacion(rs.getString("fechaCreacion"));
                permiso.setFechaModificacion(rs.getString("fechaModificacion"));
                
                permisos.add(permiso);
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return permisos;
    }
    
    /**
     * Obtiene todos los permisos del sistema
     */
    public List<Permiso> obtenerTodosLosPermisos() {
        List<Permiso> permisos = new ArrayList<>();
        String sql = "SELECT p.*, tu.nombre as nombreTipoUsuario FROM permisos p " +
                    "JOIN tipoUsuario tu ON p.idTipoUsuario = tu.idTipoUsuario " +
                    "ORDER BY tu.nombre, p.recurso, p.accion";
        
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ResultSet rs = ps.executeQuery();
            
            while (rs.next()) {
                Permiso permiso = new Permiso();
                permiso.setIdPermiso(rs.getInt("idPermiso"));
                permiso.setIdTipoUsuario(rs.getInt("idTipoUsuario"));
                permiso.setRecurso(rs.getString("recurso"));
                permiso.setAccion(rs.getString("accion"));
                permiso.setPermitido(rs.getBoolean("permitido"));
                permiso.setFechaCreacion(rs.getString("fechaCreacion"));
                permiso.setFechaModificacion(rs.getString("fechaModificacion"));
                
                permisos.add(permiso);
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return permisos;
    }
    
    /**
     * Actualiza un permiso existente
     */
    public boolean actualizarPermiso(int idPermiso, boolean permitido) {
        String sql = "UPDATE permisos SET permitido = ?, fechaModificacion = CURRENT_TIMESTAMP WHERE idPermiso = ?";
        
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setBoolean(1, permitido);
            ps.setInt(2, idPermiso);
            
            return ps.executeUpdate() > 0;
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return false;
    }
    
    /**
     * Inserta o actualiza un permiso
     */
    public boolean guardarPermiso(Permiso permiso) {
        String sql = "INSERT INTO permisos (idTipoUsuario, recurso, accion, permitido) VALUES (?, ?, ?, ?) " +
                    "ON DUPLICATE KEY UPDATE permitido = VALUES(permitido), fechaModificacion = CURRENT_TIMESTAMP";
        
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, permiso.getIdTipoUsuario());
            ps.setString(2, permiso.getRecurso());
            ps.setString(3, permiso.getAccion());
            ps.setBoolean(4, permiso.isPermitido());
            
            return ps.executeUpdate() > 0;
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return false;
    }
    
    /**
     * Elimina un permiso
     */
    public boolean eliminarPermiso(int idPermiso) {
        String sql = "DELETE FROM permisos WHERE idPermiso = ?";
        
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, idPermiso);
            
            return ps.executeUpdate() > 0;
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return false;
    }
    
    /**
     * Obtiene todos los recursos disponibles en el sistema
     */
    public List<String> obtenerRecursosDisponibles() {
        List<String> recursos = new ArrayList<>();
        recursos.add("DashboardControlador");
        recursos.add("VentaPresencialControlador");
        recursos.add("DespachoControlador");
        recursos.add("ReporteControlador");
        recursos.add("ProductoControlador");
        recursos.add("UsuarioControlador");
        recursos.add("MarcaControlador");
        recursos.add("CategoriaControlador");
        recursos.add("ClienteControlador");
        recursos.add("TipoUsuarioControlador");
        recursos.add("PermisosControlador");
        
        return recursos;
    }
    
    /**
     * Obtiene todas las acciones disponibles
     */
    public List<String> obtenerAccionesDisponibles() {
        List<String> acciones = new ArrayList<>();
        acciones.add("ALL");
        acciones.add("listar");
        acciones.add("crear");
        acciones.add("editar");
        acciones.add("eliminar");
        acciones.add("ver");
        acciones.add("buscar");
        
        return acciones;
    }
    
}
