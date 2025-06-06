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
    
    "/UsuariosControlador",
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

        // Verificar si hay sesión y usuario logueado
        if (session == null || session.getAttribute("usuario") == null) {
            httpResponse.sendRedirect(httpRequest.getContextPath() + "/UsuarioControlador?accion=login");
            return;
        }
        
        

        Usuario usuario = (Usuario) session.getAttribute("usuario");
        String tipo = usuario.getTipoUsuario(); // por ejemplo: "cliente", "vendedor", "administrador"
        String uri = httpRequest.getRequestURI();
        
//        // 1. Acceso a /admin/* => Solo administrador
//         if (uri.contains("/admin/") && !tipo.equals("administrador")) {
//        httpResponse.sendError(HttpServletResponse.SC_FORBIDDEN, "Acceso denegado");
//        return;
//        }
        // Reglas de acceso según controlador
        if (uri.contains("DashboardControlador") || uri.contains("ProductoControlador") || uri.contains("ProductoControlador")  ) {
            // Solo admin y vendedor acceden al dashboard general
            if (!tipo.equals("administrador") && !tipo.equals("vendedor")) {
                httpResponse.sendError(HttpServletResponse.SC_FORBIDDEN, "Acceso denegado");
                return;
            }
        }

        if (uri.contains("UsuariosControlador") || uri.contains("VentasControlador")) {
            // Solo administrador puede acceder
            if (!tipo.equals("administrador")) {
                httpResponse.sendError(HttpServletResponse.SC_FORBIDDEN, "Acceso denegado");
                return;
            }
        }

        // Acceso al carrito o compras (solo usuarios logueados, cualquier rol)
        // Ya está controlado por estar logueado, así que no se necesita extra validación aquí

        chain.doFilter(request, response); // permitir el acceso si pasó todo
    }

    @Override
    public void destroy() {}
}

