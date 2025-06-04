package com.sercoyt.filter;

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

@WebFilter(filterName = "AuthFilter", urlPatterns = {"/admin/*", "/vendedor/*", "/carrito.jsp", "/compras.jsp"})
public class AuthFilter implements Filter {

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;
        HttpSession session = httpRequest.getSession(false);

        boolean loggedIn = (session != null && session.getAttribute("usuario") != null);

        if (!loggedIn) {
            httpResponse.sendRedirect(httpRequest.getContextPath() + "/UsuarioControlador?accion=login");
            return;
        }

        // Verificar roles para rutas protegidas
        Usuario usuario = (Usuario) session.getAttribute("usuario");
        String requestURI = httpRequest.getRequestURI();

        if (requestURI.contains("/admin/") && !usuario.getTipoUsuario().equals("administrador")) {
            httpResponse.sendError(HttpServletResponse.SC_FORBIDDEN, "Acceso denegado");
            return;
        }

        if (requestURI.contains("/vendedor/") && !usuario.getTipoUsuario().equals("vendedor")) {
            httpResponse.sendError(HttpServletResponse.SC_FORBIDDEN, "Acceso denegado");
            return;
        }

        chain.doFilter(request, response);
    }

    @Override
    public void destroy() {
    }
}
