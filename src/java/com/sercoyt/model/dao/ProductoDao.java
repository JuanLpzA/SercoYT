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
    
    private static final String SQL_INSERT = "INSERT INTO productos(nombre, descripcion, precio, stock, imagenUrl, idMarca, idCategoria, estadoProducto) VALUES(?, ?, ?, ?, ?, ?, ?, ?)";
    private static final String SQL_UPDATE = "UPDATE productos SET nombre=?, descripcion=?, precio=?, idMarca=?, idCategoria=?, estadoProducto=?, imagenUrl=? WHERE idProducto=?";
    private static final String SQL_DELETE = "UPDATE productos SET estadoProducto='inactivo' WHERE idProducto=?";
    private static final String SQL_GET_BY_ID = "SELECT p.*, m.nombre as nombreMarca, c.nombre as nombreCategoria, p.estadoProducto as estado FROM productos p JOIN marcas m ON p.idMarca = m.idMarca JOIN categorias c ON p.idCategoria = c.idCategoria WHERE p.idProducto=?";
    private static final String SQL_ACTUALIZAR_STOCK = "UPDATE productos SET stock = stock + ? WHERE idProducto = ?";
    private static final String SQL_LISTAR_ACTIVOS = "SELECT p.*, m.nombre as nombreMarca, c.nombre as nombreCategoria FROM productos p JOIN marcas m ON p.idMarca = m.idMarca JOIN categorias c ON p.idCategoria = c.idCategoria WHERE p.estadoProducto='activo'";
    private static final String SQL_LISTAR_TODOS = "SELECT p.*, m.nombre as nombreMarca, c.nombre as nombreCategoria, p.estadoProducto as estado FROM productos p JOIN marcas m ON p.idMarca = m.idMarca JOIN categorias c ON p.idCategoria = c.idCategoria ORDER BY p.idProducto ASC";

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
                    p.setEstado(rs.getString("estado"));
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
                + "JOIN categorias c ON p.idCategoria = c.idCategoria "
                + "WHERE p.estadoProducto = 'activo'";

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

//    public void actualizarStock(Connection con, int idProducto, int cantidad) throws SQLException {
//        String sql = "UPDATE productos SET stock = stock + ? WHERE idProducto = ?";
//
//        try (PreparedStatement ps = con.prepareStatement(sql)) {
//            ps.setInt(1, cantidad);
//            ps.setInt(2, idProducto);
//            ps.executeUpdate();
//        }
//    }

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
    
    public boolean insertar(Producto producto) {
        try (Connection conn = ConnectDB.getConnection();
             PreparedStatement stmt = conn.prepareStatement(SQL_INSERT)) {
            
            stmt.setString(1, producto.getNombres());
            stmt.setString(2, producto.getDescripcion());
            stmt.setDouble(3, producto.getPrecio());
            stmt.setInt(4, producto.getStock());
            stmt.setBlob(5, producto.getFoto());
            stmt.setInt(6, obtenerIdMarca(producto.getNombreMarca()));
            stmt.setInt(7, obtenerIdCategoria(producto.getNombreCategoria()));
            stmt.setString(8, "activo");
            
            return stmt.executeUpdate() > 0;
        } catch (SQLException ex) {
            ex.printStackTrace();
            return false;
        }
    }

  public boolean actualizar(Producto producto) {
    try (Connection conn = ConnectDB.getConnection();
         PreparedStatement stmt = conn.prepareStatement(SQL_UPDATE)) {
        
        stmt.setString(1, producto.getNombres());
        stmt.setString(2, producto.getDescripcion());
        stmt.setDouble(3, producto.getPrecio());
        stmt.setInt(4, obtenerIdMarca(producto.getNombreMarca()));
        stmt.setInt(5, obtenerIdCategoria(producto.getNombreCategoria()));
        stmt.setString(6, "activo");
        
        // Manejo de la imagen
        if (producto.getFoto() != null) {
            stmt.setBlob(7, producto.getFoto());
        } else {
            // Si no hay nueva imagen, mantenemos la existente
            Producto productoActual = listarId(producto.getId());
            stmt.setBlob(7, productoActual.getFoto());
        }
        
        stmt.setInt(8, producto.getId());
        
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

    public boolean actualizarStock(int idProducto, int cantidad) {
        try (Connection conn = ConnectDB.getConnection();
             PreparedStatement stmt = conn.prepareStatement(SQL_ACTUALIZAR_STOCK)) {
            
            stmt.setInt(1, cantidad);
            stmt.setInt(2, idProducto);
            return stmt.executeUpdate() > 0;
        } catch (SQLException ex) {
            ex.printStackTrace();
            return false;
        }
    }

    public List<Producto> listarTodos() {
        List<Producto> productos = new ArrayList<>();
        try (Connection conn = ConnectDB.getConnection();
             PreparedStatement stmt = conn.prepareStatement(SQL_LISTAR_TODOS);
             ResultSet rs = stmt.executeQuery()) {
            
            while (rs.next()) {
                Producto p = new Producto();
                p.setId(rs.getInt("idProducto"));
                p.setNombres(rs.getString("nombre"));
                p.setDescripcion(rs.getString("descripcion"));
                p.setPrecio(rs.getDouble("precio"));
                p.setStock(rs.getInt("stock"));
                p.setFoto(rs.getBinaryStream("imagenUrl"));
                p.setEstado(rs.getString("estadoProducto"));
                p.setNombreMarca(rs.getString("nombreMarca"));
                p.setNombreCategoria(rs.getString("nombreCategoria"));
                productos.add(p);
            }
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
        return productos;
    }

    public List<Producto> listarActivos() {
        List<Producto> productos = new ArrayList<>();
        try (Connection conn = ConnectDB.getConnection();
             PreparedStatement stmt = conn.prepareStatement(SQL_LISTAR_ACTIVOS);
             ResultSet rs = stmt.executeQuery()) {
            
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
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
        return productos;
    }

    private int obtenerIdMarca(String nombreMarca) throws SQLException {
        String sql = "SELECT idMarca FROM marcas WHERE nombre = ?";
        try (Connection conn = ConnectDB.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, nombreMarca);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("idMarca");
                }
            }
        }
        return -1;
    }

    private int obtenerIdCategoria(String nombreCategoria) throws SQLException {
        String sql = "SELECT idCategoria FROM categorias WHERE nombre = ?";
        try (Connection conn = ConnectDB.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, nombreCategoria);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("idCategoria");
                }
            }
        }
        return -1;
    }
    
    //nuevo añadido
    public List<Producto> filtrarProductos(String nombre, String marca, String categoria, Integer stockMin, Integer stockMax) {
    List<Producto> productos = new ArrayList<>();
    StringBuilder sql = new StringBuilder(SQL_LISTAR_ACTIVOS);
    List<Object> parametros = new ArrayList<>();

    // Construir la consulta dinámica
    if (nombre != null && !nombre.isEmpty()) {
        sql.append(" AND p.nombre LIKE ?");
        parametros.add("%" + nombre + "%");
    }
    if (marca != null && !marca.isEmpty()) {
        sql.append(" AND m.nombre = ?");
        parametros.add(marca);
    }
    if (categoria != null && !categoria.isEmpty()) {
        sql.append(" AND c.nombre = ?");
        parametros.add(categoria);
    }
    if (stockMin != null) {
        sql.append(" AND p.stock >= ?");
        parametros.add(stockMin);
    }
    if (stockMax != null) {
        sql.append(" AND p.stock <= ?");
        parametros.add(stockMax);
    }

    try (Connection conn = ConnectDB.getConnection();
         PreparedStatement stmt = conn.prepareStatement(sql.toString())) {
        
        // Establecer parámetros
        for (int i = 0; i < parametros.size(); i++) {
            stmt.setObject(i + 1, parametros.get(i));
        }

        try (ResultSet rs = stmt.executeQuery()) {
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
                p.setEstado(rs.getString("estadoProducto"));
                productos.add(p);
            }
        }
    } catch (SQLException ex) {
        ex.printStackTrace();
    }
    return productos;
}

public boolean existeMarca(String nombreMarca) throws SQLException {
    String sql = "SELECT COUNT(*) FROM marcas WHERE nombre = ?";
    try (Connection conn = ConnectDB.getConnection();
         PreparedStatement stmt = conn.prepareStatement(sql)) {
        
        stmt.setString(1, nombreMarca);
        try (ResultSet rs = stmt.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
        }
    }
    return false;
}

public boolean existeCategoria(String nombreCategoria) throws SQLException {
    String sql = "SELECT COUNT(*) FROM categorias WHERE nombre = ?";
    try (Connection conn = ConnectDB.getConnection();
         PreparedStatement stmt = conn.prepareStatement(sql)) {
        
        stmt.setString(1, nombreCategoria);
        try (ResultSet rs = stmt.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
        }
    }
    return false;
}

public boolean activar(int id) {
    String sql = "UPDATE productos SET estadoProducto='activo' WHERE idProducto=?";
    try (Connection conn = ConnectDB.getConnection();
         PreparedStatement stmt = conn.prepareStatement(sql)) {
        
        stmt.setInt(1, id);
        return stmt.executeUpdate() > 0;
    } catch (SQLException ex) {
        ex.printStackTrace();
        return false;
    }
}

public boolean existeProducto(String nombre, String marca, String categoria) throws SQLException {
    String sql = "SELECT COUNT(*) FROM productos p " +
                "JOIN marcas m ON p.idMarca = m.idMarca " +
                "JOIN categorias c ON p.idCategoria = c.idCategoria " +
                "WHERE p.nombre = ? AND m.nombre = ? AND c.nombre = ? AND p.estadoProducto = 'activo'";
    
    try (Connection conn = ConnectDB.getConnection();
         PreparedStatement stmt = conn.prepareStatement(sql)) {
        
        stmt.setString(1, nombre);
        stmt.setString(2, marca);
        stmt.setString(3, categoria);
        
        try (ResultSet rs = stmt.executeQuery()) {
            return rs.next() && rs.getInt(1) > 0;
        }
    }
}

    
    
    //dashboard
    public int contarProductosActivos() throws SQLException {
    String sql = "SELECT COUNT(*) FROM productos WHERE estadoProducto = 'activo'";
    try (Connection con = ConnectDB.getConnection();
         PreparedStatement ps = con.prepareStatement(sql);
         ResultSet rs = ps.executeQuery()) {
        if (rs.next()) {
            return rs.getInt(1);
        }
    }
    return 0;
}


}