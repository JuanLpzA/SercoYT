package com.sercoyt.controller;

import com.sercoyt.model.Usuario;
import com.sercoyt.model.dao.UsuarioDao;
import com.sercoyt.util.EmailUtil;
import com.sercoyt.util.PasswordUtil;
import com.sercoyt.util.ReniecAPI;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import org.json.JSONObject;

public class UsuarioControlador extends HttpServlet {

    private final String pagRegistro = "RegistrarUsuario.jsp";
    private final String pagLogin = "IngresarUsuario.jsp";
    private final String pagVerificacion = "verificacionCorreo.jsp";
    private final String pagRecuperacion = "recuperarContrasena.jsp";
    private final String pagPerfil = "perfilUsuario.jsp";

    private final UsuarioDao usuarioDao = new UsuarioDao();

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");

        String accion = request.getParameter("accion");

        try {
            if (accion == null) {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Acción no especificada");
                return;
            }

            switch (accion) {
                case "nuevo":
                    nuevo(request, response);
                    break;
                case "guardar":
                    guardar(request, response);
                    break;
                case "verificar":
                    verificar(request, response);
                    break;
                case "login":
                    login(request, response);
                    break;
                case "recuperar":
                    mostrarRecuperacion(request, response);
                    break;
                case "enviarCodigo":
                    enviarCodigoRecuperacion(request, response);
                    break;
                case "cambiarContrasena":
                    cambiarContrasena(request, response);
                    break;
                case "logout":
                    logout(request, response);
                    break;
                case "perfil":
                    mostrarPerfil(request, response);
                    break;
                case "actualizarPerfil":
                    actualizarPerfil(request, response);
                    break;
                case "consultarDni":
                    consultarDni(request, response);
                    break;
                default:
                    response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Acción no válida");
            }
        } catch (Exception e) {
            request.setAttribute("error", e.getMessage());

            // Redirigir a la página adecuada según la acción
            if (accion.equals("login")) {
                request.getRequestDispatcher(pagLogin).forward(request, response);
            } else if (accion.equals("recuperar") || accion.equals("enviarCodigo") || accion.equals("cambiarContrasena")) {
                request.getRequestDispatcher(pagRecuperacion).forward(request, response);
            } else {
                request.getRequestDispatcher(pagRegistro).forward(request, response);
            }
        }
    }

    private void guardar(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String contrasena = request.getParameter("contrasena");
        String confirmarContrasena = request.getParameter("confirmarContrasena");

        if (!contrasena.equals(confirmarContrasena)) {
            throw new RuntimeException("Las contraseñas no coinciden");
        }

        if (!PasswordUtil.esContrasenaValida(contrasena)) {
            throw new RuntimeException("La contraseña debe tener al menos 8 caracteres, incluyendo números y letras");
        }

        String dni = request.getParameter("dni");
        if (!PasswordUtil.esDniValido(dni)) {
            throw new RuntimeException("El DNI debe tener exactamente 8 dígitos");
        }

        Usuario usuario = new Usuario();
        usuario.setNombre(request.getParameter("nombre"));
        usuario.setApellido(request.getParameter("apellido"));
        usuario.setDni(dni);
        usuario.setContraseña(PasswordUtil.encriptar(contrasena));
        usuario.setCorreo(request.getParameter("correo"));
        usuario.setDireccion(request.getParameter("direccion"));
        usuario.setTelefono(request.getParameter("telefono"));

        String codigoVerificacion = PasswordUtil.generarCodigoVerificacion();

        HttpSession session = request.getSession();
        session.setAttribute("usuarioPendiente", usuario);
        session.setAttribute("codigoVerificacion", codigoVerificacion);

        EmailUtil.enviarCodigoVerificacion(usuario.getCorreo(), codigoVerificacion);

        request.setAttribute("correo", usuario.getCorreo());
        request.getRequestDispatcher(pagVerificacion).forward(request, response);
    }
    
    private void verificar(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {
    HttpSession session = request.getSession();
    Usuario usuario = (Usuario) session.getAttribute("usuarioPendiente");
    String codigoEnviado = (String) session.getAttribute("codigoVerificacion");
    String codigoIngresado = request.getParameter("codigo");
    
    if (usuario == null || codigoEnviado == null) {
        throw new RuntimeException("Sesión expirada o inválida");
    }
    
    if (!codigoEnviado.equals(codigoIngresado)) {
        throw new RuntimeException("Código de verificación incorrecto");
    }
    
    if (usuarioDao.registrarUsuario(usuario)) {
        session.removeAttribute("usuarioPendiente");
        session.removeAttribute("codigoVerificacion");
        
        // Establecer atributo de éxito y volver a mostrar la página de verificación
        request.setAttribute("verificacionExitosa", true);
        request.setAttribute("correo", usuario.getCorreo()); // o como obtengas el correo
        request.getRequestDispatcher("verificacionCorreo.jsp").forward(request, response);
    } else {
        throw new RuntimeException("Error al registrar usuario");
    }
}

//    private void verificar(HttpServletRequest request, HttpServletResponse response)
//            throws ServletException, IOException {
//        HttpSession session = request.getSession();
//        Usuario usuario = (Usuario) session.getAttribute("usuarioPendiente");
//        String codigoEnviado = (String) session.getAttribute("codigoVerificacion");
//        String codigoIngresado = request.getParameter("codigo");
//
//        if (usuario == null || codigoEnviado == null) {
//            throw new RuntimeException("Sesión expirada o inválida");
//        }
//
//        if (!codigoEnviado.equals(codigoIngresado)) {
//            throw new RuntimeException("Código de verificación incorrecto");
//        }
//
//        if (usuarioDao.registrarUsuario(usuario)) {
//            session.removeAttribute("usuarioPendiente");
//            session.removeAttribute("codigoVerificacion");
//          
//            request.setAttribute("registroExitoso", true);
//            request.getRequestDispatcher("registroExitoso.jsp").forward(request, response);
//        } else {
//            throw new RuntimeException("Error al registrar usuario");
//        }
//    }

    private void nuevo(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setAttribute("usuario", new Usuario());
        request.getRequestDispatcher(pagRegistro).forward(request, response);
    }

    private void login(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String dni = request.getParameter("dni");
        String contrasena = request.getParameter("contrasena");

        if (dni == null || dni.isEmpty() || contrasena == null || contrasena.isEmpty()) {
            throw new RuntimeException("DNI y contraseña son requeridos");
        }

        Usuario usuario = usuarioDao.validarUsuario(dni, contrasena);

        if (usuario == null) {
            throw new RuntimeException("DNI o contraseña incorrectos");
        }

        if (!usuario.getEstado().equals("activo")) {
            throw new RuntimeException("Tu cuenta está inactiva. Contacta al administrador.");
        }

        HttpSession session = request.getSession();
        session.setAttribute("usuario", usuario);

        switch (usuario.getTipoUsuario()) {
            case "administrador":
                response.sendRedirect(request.getContextPath() + "/DashboardControlador");
                break;
            case "vendedor":
                response.sendRedirect(request.getContextPath() + "/vendedor/dashboard.jsp");
                break;
            default: // cliente
                response.sendRedirect(request.getContextPath() + "/Controlador");
        }
    }

    private void mostrarRecuperacion(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher(pagRecuperacion).forward(request, response);
    }

    private void enviarCodigoRecuperacion(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String correo = request.getParameter("correo");

        if (correo == null || correo.isEmpty()) {
            throw new RuntimeException("El correo electrónico es requerido");
        }

        Usuario usuario = usuarioDao.obtenerUsuarioPorCorreo(correo);

        if (usuario == null) {
            throw new RuntimeException("No existe una cuenta asociada a este correo electrónico");
        }

        String codigoRecuperacion = PasswordUtil.generarCodigoVerificacion();

        HttpSession session = request.getSession();
        session.setAttribute("codigoRecuperacion", codigoRecuperacion);
        session.setAttribute("usuarioRecuperacion", usuario);

        EmailUtil.enviarCodigoRecuperacion(correo, codigoRecuperacion);

        request.setAttribute("mostrarCambioContrasena", false);
        request.setAttribute("mostrarIngresoCorreo", false);
        request.setAttribute("mostrarIngresoCodigo", true);
        request.setAttribute("correo", correo);
        request.getRequestDispatcher(pagRecuperacion).forward(request, response);
    }

    private void logout(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session != null) {
            session.invalidate();
        }
        response.sendRedirect(request.getContextPath() + "/Controlador");
    }

    private void cambiarContrasena(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        String codigoEnviado = (String) session.getAttribute("codigoRecuperacion");
        Usuario usuario = (Usuario) session.getAttribute("usuarioRecuperacion");

        if (usuario == null || codigoEnviado == null) {
            throw new RuntimeException("Sesión expirada o inválida");
        }

        String codigoIngresado = request.getParameter("codigo");
        String nuevaContrasena = request.getParameter("nuevaContrasena");
        String confirmarContrasena = request.getParameter("confirmarContrasena");

        if (!codigoEnviado.equals(codigoIngresado)) {
            throw new RuntimeException("Código de verificación incorrecto");
        }

        if (!nuevaContrasena.equals(confirmarContrasena)) {
            throw new RuntimeException("Las contraseñas no coinciden");
        }

        if (!PasswordUtil.esContrasenaValida(nuevaContrasena)) {
            throw new RuntimeException("La contraseña debe tener al menos 8 caracteres, incluyendo números y letras");
        }

        if (usuarioDao.actualizarContrasena(usuario.getIdUsuario(), PasswordUtil.encriptar(nuevaContrasena))) {
            // Limpiar sesión
            session.removeAttribute("codigoRecuperacion");
            session.removeAttribute("usuarioRecuperacion");

            request.setAttribute("exito", "Contraseña actualizada correctamente. Ahora puedes iniciar sesión.");
            request.getRequestDispatcher(pagLogin).forward(request, response);
        } else {
            throw new RuntimeException("Error al actualizar la contraseña");
        }
    }

    // Controladores para el apartado de Mi Perfil
    private void mostrarPerfil(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        Usuario usuarioSesion = (Usuario) session.getAttribute("usuario");

        if (usuarioSesion == null) {
            response.sendRedirect(request.getContextPath() + "/UsuarioControlador?accion=login");
            return;
        }

        // Obtener datos actualizados del usuario
        Usuario usuario = usuarioDao.obtenerUsuarioPorId(usuarioSesion.getIdUsuario());
        request.setAttribute("usuario", usuario);
        request.getRequestDispatcher(pagPerfil).forward(request, response);
    }

    private void actualizarPerfil(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        Usuario usuarioSesion = (Usuario) session.getAttribute("usuario");

        if (usuarioSesion == null) {
            response.sendRedirect(request.getContextPath() + "/UsuarioControlador?accion=login");
            return;
        }

        try {
            int idUsuario = Integer.parseInt(request.getParameter("idUsuario"));

            // Verificar que el usuario que edita es el mismo de la sesión
            if (usuarioSesion.getIdUsuario() != idUsuario) {
                throw new RuntimeException("No tienes permiso para editar este perfil");
            }

            // Obtener datos del formulario
            String nombre = request.getParameter("nombre");
            String apellido = request.getParameter("apellido");
            String telefono = request.getParameter("telefono");
            String direccion = request.getParameter("direccion");
            String contrasenaActual = request.getParameter("contrasenaActual");
            String nuevaContrasena = request.getParameter("nuevaContrasena");
            String confirmarContrasena = request.getParameter("confirmarContrasena");

            // Validaciones básicas
            if (nombre == null || nombre.isEmpty() || apellido == null || apellido.isEmpty() || direccion == null || direccion.isEmpty()) {
                throw new RuntimeException("Nombre, apellido y dirección son campos obligatorios");
            }

            // Actualizar datos del usuario
            Usuario usuario = new Usuario();
            usuario.setIdUsuario(idUsuario);
            usuario.setNombre(nombre);
            usuario.setApellido(apellido);
            usuario.setTelefono(telefono);
            usuario.setDireccion(direccion);

            // Actualizar perfil
            usuarioDao.actualizarPerfil(usuario);

            // Actualizar contraseña si se proporcionó
            if (nuevaContrasena != null && !nuevaContrasena.isEmpty()) {
                if (contrasenaActual == null || contrasenaActual.isEmpty()) {
                    throw new RuntimeException("Debes ingresar tu contraseña actual para cambiarla");
                }

                if (!nuevaContrasena.equals(confirmarContrasena)) {
                    throw new RuntimeException("Las contraseñas nuevas no coinciden");
                }

                if (!PasswordUtil.esContrasenaValida(nuevaContrasena)) {
                    throw new RuntimeException("La contraseña debe tener al menos 8 caracteres, incluyendo números y letras");
                }

                boolean contrasenaActualizada = usuarioDao.actualizarContrasenaConValidacion(
                        idUsuario, nuevaContrasena, contrasenaActual);

                if (!contrasenaActualizada) {
                    throw new RuntimeException("La contraseña actual es incorrecta");
                }
            }

            // Actualizar datos en sesión
            Usuario usuarioActualizado = usuarioDao.obtenerUsuarioPorId(idUsuario);
            session.setAttribute("usuario", usuarioActualizado);

            request.setAttribute("success", "Perfil actualizado correctamente");
            mostrarPerfil(request, response);
        } catch (Exception e) {
            request.setAttribute("error", e.getMessage());
            mostrarPerfil(request, response);
        }
    }

    // mETODO PARA LA API DE RENIEC
    private void consultarDni(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            String dni = request.getParameter("dni");
            JSONObject datos = ReniecAPI.consultarDni(dni);

            response.setContentType("application/json");
            response.getWriter().write(datos.toString());
        } catch (Exception e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("{\"error\":\"" + e.getMessage() + "\"}");
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }
}
