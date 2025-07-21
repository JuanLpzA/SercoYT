/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.sercoyt.model;
import java.util.Date;
/**
 *
 * @author Arrunategui
 */
public class Caja {
    private int idCaja;
    private int idUsuario;
    private Date fechaApertura;
    private Date fechaCierre;
    private double montoInicial;
    private double montoFinal;
    private double montoRecaudado;
    private String estado;
    private String observaciones;
    
    // Campo temporal no persistente para mostrar nombre de usuario
    private String nombreUsuario;
    
    // Constructor vacío (sin cambios)
    public Caja() {
    }
    
    // Constructor original (sin cambios para mantener compatibilidad)
    public Caja(int idCaja, int idUsuario, Date fechaApertura, Date fechaCierre, double montoInicial, double montoFinal, double montoRecaudado, String estado, String observaciones) {
        this.idCaja = idCaja;
        this.idUsuario = idUsuario;
        this.fechaApertura = fechaApertura;
        this.fechaCierre = fechaCierre;
        this.montoInicial = montoInicial;
        this.montoFinal = montoFinal;
        this.montoRecaudado = montoRecaudado;
        this.estado = estado;
        this.observaciones = observaciones;
        // nombreUsuario queda como null por defecto
    }
    
    // Constructor adicional que incluye nombreUsuario (opcional para nuevos usos)
    public Caja(int idCaja, int idUsuario, Date fechaApertura, Date fechaCierre, double montoInicial, double montoFinal, double montoRecaudado, String estado, String observaciones, String nombreUsuario) {
        this.idCaja = idCaja;
        this.idUsuario = idUsuario;
        this.fechaApertura = fechaApertura;
        this.fechaCierre = fechaCierre;
        this.montoInicial = montoInicial;
        this.montoFinal = montoFinal;
        this.montoRecaudado = montoRecaudado;
        this.estado = estado;
        this.observaciones = observaciones;
        this.nombreUsuario = nombreUsuario;
    }
    
    public int getIdCaja() {
        return idCaja;
    }
    
    public void setIdCaja(int idCaja) {
        this.idCaja = idCaja;
    }
    
    public int getIdUsuario() {
        return idUsuario;
    }
    
    public void setIdUsuario(int idUsuario) {
        this.idUsuario = idUsuario;
    }
    
    public Date getFechaApertura() {
        return fechaApertura;
    }
    
    public void setFechaApertura(Date fechaApertura) {
        this.fechaApertura = fechaApertura;
    }
    
    public Date getFechaCierre() {
        return fechaCierre;
    }
    
    public void setFechaCierre(Date fechaCierre) {
        this.fechaCierre = fechaCierre;
    }
    
    public double getMontoInicial() {
        return montoInicial;
    }
    
    public void setMontoInicial(double montoInicial) {
        this.montoInicial = montoInicial;
    }
    
    public double getMontoFinal() {
        return montoFinal;
    }
    
    public void setMontoFinal(double montoFinal) {
        this.montoFinal = montoFinal;
    }
    
    public double getMontoRecaudado() {
        return montoRecaudado;
    }
    
    public void setMontoRecaudado(double montoRecaudado) {
        this.montoRecaudado = montoRecaudado;
    }
    
    public String getEstado() {
        return estado;
    }
    
    public void setEstado(String estado) {
        this.estado = estado;
    }
    
    public String getObservaciones() {
        return observaciones;
    }
    
    public void setObservaciones(String observaciones) {
        this.observaciones = observaciones;
    }
    
    // Getter y Setter para el campo nombreUsuario (no persistente)
    public String getNombreUsuario() {
        return nombreUsuario;
    }
    
    public void setNombreUsuario(String nombreUsuario) {
        this.nombreUsuario = nombreUsuario;
    }
}