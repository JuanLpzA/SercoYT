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
public class VentaExtra extends Venta {
    private String tipoVentaNombre;
    private String clienteNombre;
    private String clienteDni;
    private String estadoNombre;
    private String metodoPagoNombre;

    public VentaExtra() {
        super();
    }

    public VentaExtra(int idVenta, Date fecha, int idTipoVenta, int idCliente,
            int idUsuario, int idEstado, int idPago, double subtotal,
            double igv, double total, String tipoVentaNombre,
            String clienteNombre, String clienteDni, String estadoNombre,
            String metodoPagoNombre) {
        super(idVenta, fecha, idTipoVenta, idCliente, idUsuario, idEstado,
                idPago, subtotal, igv, total, null);
        this.tipoVentaNombre = tipoVentaNombre;
        this.clienteNombre = clienteNombre;
        this.clienteDni = clienteDni;
        this.estadoNombre = estadoNombre;
        this.metodoPagoNombre = metodoPagoNombre;
    }

    public String getTipoVentaNombre() {
        return tipoVentaNombre;
    }

    public void setTipoVentaNombre(String tipoVentaNombre) {
        this.tipoVentaNombre = tipoVentaNombre;
    }

    public String getClienteNombre() {
        return clienteNombre;
    }

    public void setClienteNombre(String clienteNombre) {
        this.clienteNombre = clienteNombre;
    }

    public String getClienteDni() {
        return clienteDni;
    }

    public void setClienteDni(String clienteDni) {
        this.clienteDni = clienteDni;
    }

    public String getEstadoNombre() {
        return estadoNombre;
    }

    public void setEstadoNombre(String estadoNombre) {
        this.estadoNombre = estadoNombre;
    }

    public String getMetodoPagoNombre() {
        return metodoPagoNombre;
    }

    public void setMetodoPagoNombre(String metodoPagoNombre) {
        this.metodoPagoNombre = metodoPagoNombre;
    }
    
    
    
    
    
    
}
