package com.sercoyt.controller;

import javax.servlet.ServletContext;
import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;
import javax.servlet.annotation.WebListener;

@WebListener 
public class ServletContextProvider implements ServletContextListener {
    
    private static ServletContext context;
    
    @Override
    public void contextInitialized(ServletContextEvent event) {
        context = event.getServletContext();
        System.out.println("¡Contexto inicializado con éxito!"); 
    }
    
    public static ServletContext getContextServlet() {
        return context; 
    }
    
    @Override
    public void contextDestroyed(ServletContextEvent event) {
        // Limpieza al detener la app
    }
}