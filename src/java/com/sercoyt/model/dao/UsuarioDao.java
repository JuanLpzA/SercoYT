package com.sercoyt.model.dao;

import com.sercoyt.config.ConnectDB;
import com.sercoyt.model.Usuario;
import com.sercoyt.util.PasswordUtil;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Random;

public class UsuarioDao {

    private static final String SQL_INSERT = "INSERT INTO usuarios (nombre, apellido, correo, contrasena, dni, telefono, direccion, idTipoUsuario, estadoUsuario) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
    private static final String SQL_CHECK_DNI = "SELECT COUNT(*) FROM usuarios WHERE dni = ?";
    private static final String SQL_CHECK_EMAIL = "SELECT COUNT(*) FROM usuarios WHERE correo = ?";
    private static final String SQL_GET_BY_DNI = "SELECT * FROM usuarios WHERE dni = ?";
    private static final String SQL_GET_BY_EMAIL = "SELECT * FROM usuarios WHERE correo = ?";
    private static final String SQL_UPDATE_PASSWORD = "UPDATE usuarios SET contrasena = ? WHERE idUsuario = ?";
    private static final String SQL_GET_TIPO_USUARIO = "SELECT nombre FROM tipousuario WHERE idTipoUsuario = ?";

    public boolean registrarUsuario(Usuario usuario) {
        Connection con = null;
        PreparedStatement ps = null;

        try {
            con = ConnectDB.getConnection();
            con.setAutoCommit(false);

            // Verificar si DNI ya existe
            if (existeDni(usuario.getDni())) {
                throw new RuntimeException("El DNI ya está registrado");
            }

            // Verificar si correo ya existe
            if (usuario.getCorreo() != null && !usuario.getCorreo().isEmpty() && existeCorreo(usuario.getCorreo())) {
                throw new RuntimeException("El correo electrónico ya está registrado");
            }

            // Insertar nuevo usuario
            ps = con.prepareStatement(SQL_INSERT, PreparedStatement.RETURN_GENERATED_KEYS);
            ps.setString(1, usuario.getNombre());
            ps.setString(2, usuario.getApellido());
            ps.setString(3, usuario.getCorreo());
            ps.setString(4, usuario.getContraseña());
            ps.setString(5, usuario.getDni());
            ps.setString(6, usuario.getTelefono());
            ps.setString(7, usuario.getDireccion());
            ps.setInt(8, 3); // Registra siempre como TipoUsuario "Cliente" por defecto
            ps.setString(9, "activo");

            int result = ps.executeUpdate();

            if (result > 0) {
                con.commit();
                return true;
            } else {
                con.rollback();
                return false;
            }
        } catch (SQLException e) {
            if (con != null) {
                try {
                    con.rollback();
                } catch (SQLException ex) {
                }
            }
            throw new RuntimeException("Error en la base de datos: " + e.getMessage());
        } finally {
            closeResources(con, ps, null);
        }
    }

    private boolean existeDni(String dni) throws SQLException {
        return checkExistence(SQL_CHECK_DNI, dni);
    }

    private boolean existeCorreo(String correo) throws SQLException {
        return checkExistence(SQL_CHECK_EMAIL, correo);
    }

    private boolean checkExistence(String sql, String param) throws SQLException {
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            con = ConnectDB.getConnection();
            ps = con.prepareStatement(sql);
            ps.setString(1, param);
            rs = ps.executeQuery();

            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
            return false;
        } finally {
            closeResources(null, ps, rs);
        }
    }

    public Usuario validarUsuario(String dni, String contrasena) {
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            con = ConnectDB.getConnection();
            ps = con.prepareStatement(SQL_GET_BY_DNI);
            ps.setString(1, dni);
            rs = ps.executeQuery();

            if (rs.next()) {
                String contrasenaEncriptada = PasswordUtil.encriptar(contrasena);
                String contrasenaAlmacenada = rs.getString("contrasena");

                if (contrasenaEncriptada.equals(contrasenaAlmacenada)) {
                    Usuario usuario = new Usuario();
                    usuario.setIdUsuario(rs.getInt("idUsuario"));
                    usuario.setNombre(rs.getString("nombre"));
                    usuario.setApellido(rs.getString("apellido"));
                    usuario.setCorreo(rs.getString("correo"));
                    usuario.setDni(rs.getString("dni"));
                    usuario.setTelefono(rs.getString("telefono"));
                    usuario.setDireccion(rs.getString("direccion"));

                    // Obtener nombre del tipo de usuario
                    int idTipoUsuario = rs.getInt("idTipoUsuario");
                    usuario.setTipoUsuario(obtenerNombreTipoUsuario(idTipoUsuario));

                    usuario.setEstado(rs.getString("estadoUsuario"));
                    return usuario;
                }
            }
            return null;
        } catch (SQLException e) {
            throw new RuntimeException("Error al validar usuario: " + e.getMessage(), e);
        } finally {
            closeResources(con, ps, rs);
        }
    }

    public Usuario obtenerUsuarioPorCorreo(String correo) {
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            con = ConnectDB.getConnection();
            ps = con.prepareStatement(SQL_GET_BY_EMAIL);
            ps.setString(1, correo);
            rs = ps.executeQuery();

            if (rs.next()) {
                Usuario usuario = new Usuario();
                usuario.setIdUsuario(rs.getInt("idUsuario"));
                usuario.setNombre(rs.getString("nombre"));
                usuario.setApellido(rs.getString("apellido"));
                usuario.setCorreo(rs.getString("correo"));
                usuario.setDni(rs.getString("dni"));
                usuario.setTelefono(rs.getString("telefono"));
                usuario.setDireccion(rs.getString("direccion"));

                // Obtener nombre del tipo de usuario
                int idTipoUsuario = rs.getInt("idTipoUsuario");
                usuario.setTipoUsuario(obtenerNombreTipoUsuario(idTipoUsuario));

                usuario.setEstado(rs.getString("estadoUsuario"));
                return usuario;
            }
            return null;
        } catch (SQLException e) {
            throw new RuntimeException("Error al obtener usuario por correo: " + e.getMessage(), e);
        } finally {
            closeResources(con, ps, rs);
        }
    }

    public boolean actualizarContrasena(int idUsuario, String nuevaContrasena) {
        Connection con = null;
        PreparedStatement ps = null;

        try {
            con = ConnectDB.getConnection();
            ps = con.prepareStatement(SQL_UPDATE_PASSWORD);
            ps.setString(1, nuevaContrasena);
            ps.setInt(2, idUsuario);

            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            throw new RuntimeException("Error al actualizar contraseña: " + e.getMessage(), e);
        } finally {
            closeResources(con, ps, null);
        }
    }

    private String obtenerNombreTipoUsuario(int idTipoUsuario) {
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            con = ConnectDB.getConnection();
            ps = con.prepareStatement(SQL_GET_TIPO_USUARIO);
            ps.setInt(1, idTipoUsuario);
            rs = ps.executeQuery();

            if (rs.next()) {
                return rs.getString("nombre");
            }
            return "cliente";
        } catch (SQLException e) {
            throw new RuntimeException("Error al obtener tipo de usuario: " + e.getMessage(), e);
        } finally {
            closeResources(con, ps, rs);
        }
    }

    private void closeResources(Connection con, PreparedStatement ps, ResultSet rs) {
        try {
            if (rs != null) {
                rs.close();
            }
        } catch (SQLException e) {
        }
        try {
            if (ps != null) {
                ps.close();
            }
        } catch (SQLException e) {
        }
        try {
            if (con != null) {
                con.close();
            }
        } catch (SQLException e) {
        }
    }
}
