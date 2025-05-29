/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.sercoyt.model;

/**
 *
 * @author Arrunategui
 */
public class DireccionEntrega {
    private int idEntrega;
    private int idVenta;
    private String direccion;

    public DireccionEntrega() {
    }

    public DireccionEntrega(int idEntrega, int idVenta, String direccion) {
        this.idEntrega = idEntrega;
        this.idVenta = idVenta;
        this.direccion = direccion;
    }

    public int getIdEntrega() {
        return idEntrega;
    }

    public void setIdEntrega(int idEntrega) {
        this.idEntrega = idEntrega;
    }

    public int getIdVenta() {
        return idVenta;
    }

    public void setIdVenta(int idVenta) {
        this.idVenta = idVenta;
    }

    public String getDireccion() {
        return direccion;
    }

    public void setDireccion(String direccion) {
        this.direccion = direccion;
    }
    
    
    
}
