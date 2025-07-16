/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.sercoyt.model;

/**
 *
 * @author Arrunategui
 */
public class TipoCliente {
    private int idTipoCliente;
    private String descripcion;

    public TipoCliente() {
    }

    public TipoCliente(int idTipoCliente, String descripcion) {
        this.idTipoCliente = idTipoCliente;
        this.descripcion = descripcion;
    }

    public int getIdTipoCliente() {
        return idTipoCliente;
    }

    public void setIdTipoCliente(int idTipoCliente) {
        this.idTipoCliente = idTipoCliente;
    }

    public String getDescripcion() {
        return descripcion;
    }

    public void setDescripcion(String descripcion) {
        this.descripcion = descripcion;
    }
    
    
}
