/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.sercoyt.model;

import java.util.Date;
import java.util.List;

/**
 *
 * @author Arrunategui
 */
public class Venta {

    private int idVenta;
    private Date fecha;
    private int idTipoVenta;
    private int idCliente;
    private int idUsuario;
    private int idEstado;
    private int idPago;
    private double subtotal;
    private double igv;
    private double total;
    private List<DetalleVenta> detalles;

    public Venta() {
    }

    public Venta(int idVenta, Date fecha, int idTipoVenta, int idCliente, int idUsuario, int idEstado, int idPago, double subtotal, double igv, double total, List<DetalleVenta> detalles) {
        this.idVenta = idVenta;
        this.fecha = fecha;
        this.idTipoVenta = idTipoVenta;
        this.idCliente = idCliente;
        this.idUsuario = idUsuario;
        this.idEstado = idEstado;
        this.idPago = idPago;
        this.subtotal = subtotal;
        this.igv = igv;
        this.total = total;
        this.detalles = detalles;
    }

    public int getIdVenta() {
        return idVenta;
    }

    public void setIdVenta(int idVenta) {
        this.idVenta = idVenta;
    }

    public Date getFecha() {
        return fecha;
    }

    public void setFecha(Date fecha) {
        this.fecha = fecha;
    }

    public int getIdTipoVenta() {
        return idTipoVenta;
    }

    public void setIdTipoVenta(int idTipoVenta) {
        this.idTipoVenta = idTipoVenta;
    }

    public int getIdCliente() {
        return idCliente;
    }

    public void setIdCliente(int idCliente) {
        this.idCliente = idCliente;
    }

    public int getIdUsuario() {
        return idUsuario;
    }

    public void setIdUsuario(int idUsuario) {
        this.idUsuario = idUsuario;
    }

    public int getIdEstado() {
        return idEstado;
    }

    public void setIdEstado(int idEstado) {
        this.idEstado = idEstado;
    }

    public int getIdPago() {
        return idPago;
    }

    public void setIdPago(int idPago) {
        this.idPago = idPago;
    }

    public double getSubtotal() {
        return subtotal;
    }

    public void setSubtotal(double subtotal) {
        this.subtotal = subtotal;
    }

    public double getIgv() {
        return igv;
    }

    public void setIgv(double igv) {
        this.igv = igv;
    }

    public double getTotal() {
        return total;
    }

    public void setTotal(double total) {
        this.total = total;
    }

    public List<DetalleVenta> getDetalles() {
        return detalles;
    }

    public void setDetalles(List<DetalleVenta> detalles) {
        this.detalles = detalles;
    }
    
    
    
    
}
