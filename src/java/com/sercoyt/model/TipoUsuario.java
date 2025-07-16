/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.sercoyt.model;

/**
 *
 * @author Arrunategui
 */
public class TipoUsuario {
    private int idTipoUsuario;
    private String nombre;
    private String estadoTipo;

    public TipoUsuario() {
    }

    public TipoUsuario(int idTipoUsuario, String nombre, String estadoTipo) {
        this.idTipoUsuario = idTipoUsuario;
        this.nombre = nombre;
        this.estadoTipo = estadoTipo;
    }

    public int getIdTipoUsuario() {
        return idTipoUsuario;
    }

    public void setIdTipoUsuario(int idTipoUsuario) {
        this.idTipoUsuario = idTipoUsuario;
    }

    public String getNombre() {
        return nombre;
    }

    public void setNombre(String nombre) {
        this.nombre = nombre;
    }

    public String getEstadoTipo() {
        return estadoTipo;
    }

    public void setEstadoTipo(String estadoTipo) {
        this.estadoTipo = estadoTipo;
    }
    
    
    
}
