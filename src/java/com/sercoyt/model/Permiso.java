/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.sercoyt.model;

/**
 *
 * @author Arrunategui
 */
public class Permiso {
    private int idPermiso;
    private int idTipoUsuario;
    private String recurso;
    private String accion;
    private boolean permitido;
    private String fechaCreacion;
    private String fechaModificacion;
    
    // Constructor vacío
    public Permiso() {}
    
    // Constructor completo
    public Permiso(int idPermiso, int idTipoUsuario, String recurso, String accion, boolean permitido) {
        this.idPermiso = idPermiso;
        this.idTipoUsuario = idTipoUsuario;
        this.recurso = recurso;
        this.accion = accion;
        this.permitido = permitido;
    }
    
    // Constructor sin ID (para inserción)
    public Permiso(int idTipoUsuario, String recurso, String accion, boolean permitido) {
        this.idTipoUsuario = idTipoUsuario;
        this.recurso = recurso;
        this.accion = accion;
        this.permitido = permitido;
    }

    // Getters y Setters
    public int getIdPermiso() {
        return idPermiso;
    }

    public void setIdPermiso(int idPermiso) {
        this.idPermiso = idPermiso;
    }

    public int getIdTipoUsuario() {
        return idTipoUsuario;
    }

    public void setIdTipoUsuario(int idTipoUsuario) {
        this.idTipoUsuario = idTipoUsuario;
    }

    public String getRecurso() {
        return recurso;
    }

    public void setRecurso(String recurso) {
        this.recurso = recurso;
    }

    public String getAccion() {
        return accion;
    }

    public void setAccion(String accion) {
        this.accion = accion;
    }

    public boolean isPermitido() {
        return permitido;
    }

    public void setPermitido(boolean permitido) {
        this.permitido = permitido;
    }

    public String getFechaCreacion() {
        return fechaCreacion;
    }

    public void setFechaCreacion(String fechaCreacion) {
        this.fechaCreacion = fechaCreacion;
    }

    public String getFechaModificacion() {
        return fechaModificacion;
    }

    public void setFechaModificacion(String fechaModificacion) {
        this.fechaModificacion = fechaModificacion;
    }

    @Override
    public String toString() {
        return "Permiso{" +
                "idPermiso=" + idPermiso +
                ", idTipoUsuario=" + idTipoUsuario +
                ", recurso='" + recurso + '\'' +
                ", accion='" + accion + '\'' +
                ", permitido=" + permitido +
                '}';
    }
    
}
