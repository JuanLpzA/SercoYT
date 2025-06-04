package com.sercoyt.model.dao;

import com.sercoyt.config.ConnectDB;
import com.sercoyt.model.Producto;
import java.io.BufferedInputStream;
import java.io.BufferedOutputStream;
import java.io.InputStream;
import java.io.OutputStream;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import javax.servlet.http.HttpServletResponse;

public class ProductoDao {

    public Producto listarId(int id) {
        String sql = "SELECT p.*, m.nombre as nombreMarca, c.nombre as nombreCategoria "
                + "FROM productos p "
                + "JOIN marcas m ON p.idMarca = m.idMarca "
                + "JOIN categorias c ON p.idCategoria = c.idCategoria "
                + "WHERE p.idProducto = ?";
        Producto p = new Producto();

        try (Connection con = ConnectDB.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, id);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    p.setId(rs.getInt("idProducto"));
                    p.setNombres(rs.getString("nombre"));
                    p.setDescripcion(rs.getString("descripcion"));
                    p.setPrecio(rs.getDouble("precio"));
                    p.setStock(rs.getInt("stock"));
                    p.setFoto(rs.getBinaryStream("imagenUrl"));
                    p.setNombreMarca(rs.getString("nombreMarca"));
                    p.setNombreCategoria(rs.getString("nombreCategoria"));
                }
            }
        } catch (SQLException e) {
            System.err.println("Error en listarId: " + e.getMessage());
            e.printStackTrace();
        }
        return p;
    }

    public List<Producto> listarConFiltro(String sql, String parametroCategoria) {
        List<Producto> productos = new ArrayList<>();

        try (Connection con = ConnectDB.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, parametroCategoria);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Producto p = new Producto();
                    p.setId(rs.getInt("idProducto"));
                    p.setNombres(rs.getString("nombre"));
                    p.setDescripcion(rs.getString("descripcion"));
                    p.setPrecio(rs.getDouble("precio"));
                    p.setStock(rs.getInt("stock"));
                    p.setFoto(rs.getBinaryStream("imagenUrl"));
                    p.setNombreMarca(rs.getString("nombreMarca"));
                    p.setNombreCategoria(rs.getString("nombreCategoria"));
                    productos.add(p);
                }
            }
        } catch (SQLException e) {
            System.err.println("Error en listarConFiltro: " + e.getMessage());
            e.printStackTrace();
        }
        return productos;
    }

    public List<Producto> listarPorCategoria(String sql, String categoria) {
        List<Producto> productos = new ArrayList<>();

        try (Connection con = ConnectDB.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, categoria);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Producto p = new Producto();
                    p.setId(rs.getInt("idProducto"));
                    p.setNombres(rs.getString("nombre"));
                    p.setDescripcion(rs.getString("descripcion"));
                    p.setPrecio(rs.getDouble("precio"));
                    p.setStock(rs.getInt("stock"));
                    p.setFoto(rs.getBinaryStream("imagenUrl"));
                    p.setNombreMarca(rs.getString("nombreMarca"));
                    p.setNombreCategoria(rs.getString("nombreCategoria"));
                    productos.add(p);
                }
            }
        } catch (SQLException e) {
            System.err.println("Error en listarPorCategoria: " + e.getMessage());
            e.printStackTrace();
        }
        return productos;
    }

    public List<Producto> listar() {
        List<Producto> productos = new ArrayList<>();
        String sql = "SELECT p.*, m.nombre as nombreMarca, c.nombre as nombreCategoria "
                + "FROM productos p "
                + "JOIN marcas m ON p.idMarca = m.idMarca "
                + "JOIN categorias c ON p.idCategoria = c.idCategoria";

        try (Connection con = ConnectDB.getConnection(); PreparedStatement ps = con.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Producto p = new Producto();
                p.setId(rs.getInt("idProducto"));
                p.setNombres(rs.getString("nombre"));
                p.setDescripcion(rs.getString("descripcion"));
                p.setPrecio(rs.getDouble("precio"));
                p.setStock(rs.getInt("stock"));
                p.setFoto(rs.getBinaryStream("imagenUrl"));
                p.setNombreMarca(rs.getString("nombreMarca"));
                p.setNombreCategoria(rs.getString("nombreCategoria"));
                productos.add(p);
            }
        } catch (SQLException e) {
            System.err.println("Error en listar: " + e.getMessage());
            e.printStackTrace();
        }
        return productos;
    }

    public void listarImg(int id, HttpServletResponse response) {
        String sql = "SELECT imagenUrl FROM productos WHERE idProducto = ?";

        try (Connection con = ConnectDB.getConnection(); PreparedStatement ps = con.prepareStatement(sql); OutputStream outputStream = response.getOutputStream()) {

            ps.setInt(1, id);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    try (InputStream inputStream = rs.getBinaryStream("imagenUrl"); BufferedInputStream bis = new BufferedInputStream(inputStream); BufferedOutputStream bos = new BufferedOutputStream(outputStream)) {

                        byte[] buffer = new byte[4096];
                        int bytesRead;
                        while ((bytesRead = bis.read(buffer)) != -1) {
                            bos.write(buffer, 0, bytesRead);
                        }
                    }
                }
            }
        } catch (Exception e) {
            System.err.println("Error en listarImg: " + e.getMessage());
            e.printStackTrace();
        }
    }

    public void actualizarStock(Connection con, int idProducto, int cantidad) throws SQLException {
        String sql = "UPDATE productos SET stock = stock + ? WHERE idProducto = ?";

        try (PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, cantidad);
            ps.setInt(2, idProducto);
            ps.executeUpdate();
        }
    }

    public String obtenerNombreProducto(int idProducto) throws SQLException {
        String sql = "SELECT nombre FROM productos WHERE idProducto = ?";
        String nombre = null;

        try (Connection con = ConnectDB.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, idProducto);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    nombre = rs.getString("nombre");
                }
            }
        }
        return nombre != null ? nombre : "Producto desconocido";
    }

}
