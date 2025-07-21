package com.sercoyt.controller;
import com.sercoyt.model.Usuario;
import java.io.IOException;
import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.annotation.WebFilter;
import javax.servlet.http.HttpServletRequest;   
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebFilter(filterName = "AuthFilter", urlPatterns = {
    "/DashboardControlador", 
    "/MarcaControlador",
    "/ProductoControlador",
    "/ClienteControlador",
    "/VentaPresencialControlador",
    "/DespachoControlador",
    "/CategoriaControlador",
    "/ReporteControlador",
    "/CajaControlador",
    "/carrito.jsp",
    "/compras.jsp",
    "/admin/*"
})
public class AuthFilter implements Filter {
    
    @Override
    public void init(FilterConfig filterConfig) throws ServletException {}
    
    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        
        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;
        HttpSession session = httpRequest.getSession(false);
        String uri = httpRequest.getRequestURI();
        
        // Verificar si es una acción administrativa del UsuarioControlador
        if (uri.contains("UsuarioControlador")) {
            String accion = httpRequest.getParameter("accion");
            
            // Acciones administrativas que requieren autenticación y rol de administrador
            if (accion != null && (accion.contains("Admin") || 
                                 accion.equals("listarActivosCajasActivas"))) {
                
                if (session == null || session.getAttribute("usuario") == null) {
                    httpResponse.sendRedirect(httpRequest.getContextPath() + "/UsuarioControlador?accion=login");
                    return;
                }
                
                Usuario usuario = (Usuario) session.getAttribute("usuario");
                if (!usuario.getTipoUsuario().equals("administrador")) {
                    httpResponse.sendError(HttpServletResponse.SC_FORBIDDEN, "Acceso denegado");
                    return;
                }
            }
            // Si no es una acción administrativa, permitir el acceso libre
            chain.doFilter(request, response);
            return;
        }
        
        // Para el resto de recursos, verificar si hay sesión y usuario logueado
        if (session == null || session.getAttribute("usuario") == null) {
            httpResponse.sendRedirect(httpRequest.getContextPath() + "/UsuarioControlador?accion=login");
            return;
        }
        
        Usuario usuario = (Usuario) session.getAttribute("usuario");
        String tipo = usuario.getTipoUsuario();
        
        // 1. Acceso general a /admin/* => Solo administrador o vendedor
        if (uri.contains("/admin/")) {
            if (!(tipo.equals("administrador") || tipo.equals("vendedor"))) {
                httpResponse.sendError(HttpServletResponse.SC_FORBIDDEN, "Acceso denegado");
                return;
            }
            
            // 2. JSPs específicos dentro de /admin/ que solo pueden acceder administradores
            if (uri.endsWith("categorias.jsp") || 
                uri.endsWith("entregas.jsp") || 
                uri.endsWith("reportes.jsp") || 
                uri.endsWith("tipoUsuario.jsp") || 
                uri.endsWith("usuarios.jsp") || 
                uri.endsWith("cajas.jsp")) {
                
                if (!tipo.equals("administrador")) {
                    httpResponse.sendError(HttpServletResponse.SC_FORBIDDEN, "Acceso denegado");
                    return;
                }
            }
        }
        
        // 3. Controladores para administradores y vendedores
        if (uri.contains("DashboardControlador") || 
            uri.contains("ProductoControlador") || 
            uri.contains("ClienteControlador") || 
            uri.contains("MarcaControlador") || 
            uri.contains("VentaPresencialControlador") || 
            uri.contains("DespachoControlador")) {
            
            if (!tipo.equals("administrador") && !tipo.equals("vendedor")) {
                httpResponse.sendError(HttpServletResponse.SC_FORBIDDEN, "Acceso denegado");
                return;
            }
        }
        
        // 4. Controladores solo para administradores
        if (uri.contains("CategoriaControlador") || 
            uri.contains("ReporteControlador") || 
            uri.contains("CajaControlador")) {
            
            if (!tipo.equals("administrador")) {
                httpResponse.sendError(HttpServletResponse.SC_FORBIDDEN, "Acceso denegado");
                return;
            }
        }
        
        // 5. Acceso al carrito o compras (solo usuarios logueados, cualquier rol)
        if (uri.contains("carrito.jsp") || uri.contains("compras.jsp")) {
            // Ya está controlado por la verificación de sesión al inicio,
            // cualquier usuario autenticado puede acceder
        }
        
        // Permitir el acceso si pasó todas las validaciones
        chain.doFilter(request, response);
    }
    
    @Override
    public void destroy() {}
}