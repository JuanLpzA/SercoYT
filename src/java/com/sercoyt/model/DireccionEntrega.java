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
    private String nombreReceptor;
    private String telefono;
    private String provincia;
    private String direccion;
    private String referencia;
    private String codigoPostal;

    public DireccionEntrega() {
    }

    public DireccionEntrega(int idEntrega, int idVenta, String nombreReceptor, String telefono, String provincia, String direccion, String referencia, String codigoPostal) {
        this.idEntrega = idEntrega;
        this.idVenta = idVenta;
        this.nombreReceptor = nombreReceptor;
        this.telefono = telefono;
        this.provincia = provincia;
        this.direccion = direccion;
        this.referencia = referencia;
        this.codigoPostal = codigoPostal;
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

    public String getNombreReceptor() {
        return nombreReceptor;
    }

    public void setNombreReceptor(String nombreReceptor) {
        this.nombreReceptor = nombreReceptor;
    }

    public String getTelefono() {
        return telefono;
    }

    public void setTelefono(String telefono) {
        this.telefono = telefono;
    }

    public String getProvincia() {
        return provincia;
    }

    public void setProvincia(String provincia) {
        this.provincia = provincia;
    }

    public String getDireccion() {
        return direccion;
    }

    public void setDireccion(String direccion) {
        this.direccion = direccion;
    }

    public String getReferencia() {
        return referencia;
    }

    public void setReferencia(String referencia) {
        this.referencia = referencia;
    }

    public String getCodigoPostal() {
        return codigoPostal;
    }

    public void setCodigoPostal(String codigoPostal) {
        this.codigoPostal = codigoPostal;
    }

    

}
