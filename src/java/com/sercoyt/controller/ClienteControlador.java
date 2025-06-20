/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package com.sercoyt.controller;

import com.sercoyt.model.Cliente;
import com.sercoyt.model.dao.ClienteDao;
import com.sercoyt.util.ReniecAPI;
import org.json.JSONObject;

import java.io.IOException;
import java.io.PrintWriter;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.List;
import java.util.stream.Collectors;
import javax.servlet.http.HttpSession;

/**
 *
 * @author Arrunategui
 */
public class ClienteControlador extends HttpServlet {

    private final ClienteDao clienteDao = new ClienteDao();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String accion = request.getParameter("accion");

        if (accion == null) {
            accion = "listar";
        }

        try {
            switch (accion) {
                case "editar":
                    obtenerClienteParaEdicion(request, response);
                    break;
                case "eliminar":
                    eliminarCliente(request, response);
                    break;
                case "consultarDni":
                    consultarDniApi(request, response);
                    break;
                case "filtrar":
                    filtrarClientes(request, response);
                    break;
                default:
                    listarClientes(request, response);
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error en el servidor");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String accion = request.getParameter("accion");
        
        try {
            switch (accion) {
                case "guardar":
                    guardarCliente(request, response);
                    break;
                case "actualizar":
                    actualizarCliente(request, response);
                    break;
                default:
                    response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Acción no válida");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error en el servidor");
        }
    }

    private void listarClientes(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();

        // Obtener los mensajes de la sesión
        String exito = (String) session.getAttribute("exito");
        String error = (String) session.getAttribute("error");
        List<Cliente> clientes = clienteDao.listarTodos();
        request.setAttribute("clientes", clientes);
        request.getRequestDispatcher("/admin/clientes.jsp").forward(request, response);
    }

    private void guardarCliente(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            Cliente cliente = new Cliente();
            cliente.setNombre(request.getParameter("nombre"));
            cliente.setApellido(request.getParameter("apellido"));
            cliente.setDocumento(request.getParameter("dni"));
            cliente.setTelefono(request.getParameter("telefono"));

            int idGenerado = clienteDao.insertar(cliente);

            if (idGenerado > 0) {
                request.getSession().setAttribute("exito", "Cliente creado correctamente");
                response.sendRedirect(request.getContextPath() + "/ClienteControlador?accion=listar");
            } else {
                request.getSession().setAttribute("error", "Error al guardar el cliente");
                response.sendRedirect(request.getContextPath() + "/admin/clientes.jsp");
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.getSession().setAttribute("error", "Error al procesar el cliente: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/admin/clientes.jsp");
        }
    }

    private void actualizarCliente(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            Cliente cliente = new Cliente();
            cliente.setIdCliente(Integer.parseInt(request.getParameter("id")));
            cliente.setNombre(request.getParameter("nombre"));
            cliente.setApellido(request.getParameter("apellido"));
            cliente.setDocumento(request.getParameter("dni"));
            cliente.setTelefono(request.getParameter("telefono"));

            if (clienteDao.actualizar(cliente)) {
                request.getSession().setAttribute("exito", "Cliente actualizado correctamente");
            } else {
                request.getSession().setAttribute("error", "Error al actualizar el cliente");
            }
            response.sendRedirect(request.getContextPath() + "/ClienteControlador?accion=listar");
        } catch (Exception e) {
            e.printStackTrace();
            request.getSession().setAttribute("error", "Error al actualizar el cliente: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/ClienteControlador?accion=listar");
        }
    }

    private void eliminarCliente(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        
        if (clienteDao.eliminar(id)) {
            request.getSession().setAttribute("exito", "Cliente eliminado correctamente");
        } else {
            request.getSession().setAttribute("error", "Error al eliminar el cliente");
        }
        response.sendRedirect(request.getContextPath() + "/ClienteControlador?accion=listar");
    }

    private void filtrarClientes(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String nombre = request.getParameter("nombre");
        String dni = request.getParameter("dni");

        List<Cliente> clientes = clienteDao.listarTodos();

        // Aplicar filtros
        if (nombre != null && !nombre.isEmpty()) {
            final String nombreFilter = nombre.toLowerCase();
            clientes = clientes.stream()
                    .filter(c -> (c.getNombre() + " " + c.getApellido()).toLowerCase().contains(nombreFilter))
                    .collect(Collectors.toList());
        }

        if (dni != null && !dni.isEmpty()) {
            clientes = clientes.stream()
                    .filter(c -> c.getDocumento().contains(dni))
                    .collect(Collectors.toList());
        }

        request.setAttribute("clientes", clientes);
        request.setAttribute("filtroNombre", nombre);
        request.setAttribute("filtroDni", dni);
        request.getRequestDispatcher("/admin/clientes.jsp").forward(request, response);
    }

    private void obtenerClienteParaEdicion(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            Cliente cliente = clienteDao.obtenerPorId(id);

            if (cliente != null) {
                response.setContentType("application/json");
                response.setCharacterEncoding("UTF-8");

                String json = String.format(
                    "{\"id\": %d, \"nombre\": \"%s\", \"apellido\": \"%s\", \"dni\": \"%s\", \"telefono\": \"%s\"}",
                    cliente.getIdCliente(), cliente.getNombre(), cliente.getApellido(), cliente.getDocumento(), cliente.getTelefono()
                );

                response.getWriter().write(json);
            } else {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Cliente no encontrado");
            }
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "ID inválido");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error al obtener el cliente");
        }
    }

    private void consultarDniApi(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            String dni = request.getParameter("dni");
            JSONObject datos = ReniecAPI.consultarDni(dni);

            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            response.getWriter().write(datos.toString());
        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("{\"error\": \"" + e.getMessage() + "\"}");
        }
    }
}
