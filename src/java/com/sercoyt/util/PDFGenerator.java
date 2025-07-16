package com.sercoyt.util;

import com.sercoyt.model.Venta;
import com.sercoyt.model.DetalleVenta;
import com.itextpdf.text.*;
import com.itextpdf.text.pdf.*;
import com.itextpdf.text.pdf.draw.LineSeparator;
import com.sercoyt.controller.ServletContextProvider;
import java.io.*;
import java.text.SimpleDateFormat;
import java.util.List;

public class PDFGenerator {

    private static final Font TITLE_FONT = new Font(Font.FontFamily.HELVETICA, 18, Font.BOLD);
    private static final Font SUBTITLE_FONT = new Font(Font.FontFamily.HELVETICA, 14, Font.BOLD);
    private static final Font NORMAL_FONT = new Font(Font.FontFamily.HELVETICA, 12);
    private static final Font BOLD_FONT = new Font(Font.FontFamily.HELVETICA, 12, Font.BOLD);

    public static void generarBoleta(Venta venta, List<DetalleVenta> detalles, OutputStream out)
        throws DocumentException, IOException {

    System.out.println("=== Iniciando generación de documento PDF ===");
    
    Document document = new Document();
    PdfWriter writer = null;
    
    try {
        writer = PdfWriter.getInstance(document, out);
        
        // Metadatos del PDF
        document.addTitle("Boleta de Venta #" + venta.getIdVenta());
        document.addSubject("Comprobante de compra");
        document.addKeywords("boleta, venta, compra, SercoYT");
        document.addCreator("SercoYT System");

        document.open();
        System.out.println("Documento PDF abierto");

        // Logo de la empresa (comentar temporalmente para debugging)
        try {
            String logoPath = ServletContextProvider.getContextServlet().getRealPath("/img/logo.png");
            System.out.println("Ruta del logo: " + logoPath);
            
            if (logoPath != null && new File(logoPath).exists()) {
                Image logo = Image.getInstance(logoPath);
                logo.scaleToFit(100, 100);
                logo.setAlignment(Element.ALIGN_CENTER);
                document.add(logo);
                System.out.println("Logo agregado exitosamente");
            } else {
                System.out.println("Logo no encontrado, continuando sin logo");
            }
        } catch (Exception e) {
            System.err.println("Error con logo (continuando sin logo): " + e.getMessage());
        }

        // Encabezado
        Paragraph title = new Paragraph("BOLETA DE VENTA", TITLE_FONT);
        title.setAlignment(Element.ALIGN_CENTER);
        title.setSpacingAfter(10);
        document.add(title);
        System.out.println("Título agregado");

        Paragraph subTitle = new Paragraph("SercoYT - Tecnología a tu alcance", NORMAL_FONT);
        subTitle.setAlignment(Element.ALIGN_CENTER);
        subTitle.setSpacingAfter(20);
        document.add(subTitle);
        System.out.println("Subtítulo agregado");

        // Información de la venta
        PdfPTable infoTable = new PdfPTable(2);
        infoTable.setWidthPercentage(100);
        infoTable.setSpacingAfter(20);

        addCell(infoTable, "Número de Boleta:", BOLD_FONT);
        addCell(infoTable, "SERCO-" + venta.getIdVenta(), NORMAL_FONT);

        SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy HH:mm:ss");
        addCell(infoTable, "Fecha:", BOLD_FONT);
        addCell(infoTable, sdf.format(venta.getFecha()), NORMAL_FONT);

        addCell(infoTable, "Tipo de Venta:", BOLD_FONT);
        addCell(infoTable, venta.getIdTipoVenta() == 1 ? "Presencial" : "Virtual", NORMAL_FONT);

        addCell(infoTable, "Método de Pago:", BOLD_FONT);
        String metodoPago = "";
        switch (venta.getIdPago()) {
            case 1: metodoPago = "Efectivo"; break;
            case 2: metodoPago = "Tarjeta"; break;
            case 3: metodoPago = "Yape"; break;
            default: metodoPago = "No especificado"; break;
        }
        addCell(infoTable, metodoPago, NORMAL_FONT);

        document.add(infoTable);
        System.out.println("Tabla de información agregada");

        // Línea separadora
        document.add(new Chunk(new LineSeparator()));

        // Detalles de productos
        Paragraph productosTitle = new Paragraph("DETALLES DE PRODUCTOS", SUBTITLE_FONT);
        productosTitle.setSpacingAfter(10);
        document.add(productosTitle);

        PdfPTable detallesTable = new PdfPTable(5);
        detallesTable.setWidthPercentage(100);
        detallesTable.setWidths(new float[]{3, 1, 1, 1, 1});

        addHeaderCell(detallesTable, "Producto");
        addHeaderCell(detallesTable, "Cantidad");
        addHeaderCell(detallesTable, "P. Unitario");
        addHeaderCell(detallesTable, "IGV (18%)");
        addHeaderCell(detallesTable, "Subtotal");

        for (DetalleVenta detalle : detalles) {
            addCell(detallesTable, detalle.getNombreProducto(), NORMAL_FONT);
            addCell(detallesTable, String.valueOf(detalle.getCantidad()), NORMAL_FONT);
            addCell(detallesTable, formatMoney(detalle.getPrecioUnitario()), NORMAL_FONT);
            addCell(detallesTable, formatMoney(detalle.getPrecioUnitario() * 0.18), NORMAL_FONT);
            addCell(detallesTable, formatMoney(detalle.getSubtotal() / 1.18), NORMAL_FONT);

        }

        document.add(detallesTable);
        System.out.println("Tabla de detalles agregada");

        // Totales
        PdfPTable totalesTable = new PdfPTable(2);
        totalesTable.setWidthPercentage(50);
        totalesTable.setHorizontalAlignment(Element.ALIGN_RIGHT);
        totalesTable.setSpacingBefore(20);

        addCell(totalesTable, "Subtotal:", BOLD_FONT);
        addCell(totalesTable, formatMoney(venta.getSubtotal()), NORMAL_FONT);

        addCell(totalesTable, "IGV (18%):", BOLD_FONT);
        addCell(totalesTable, formatMoney(venta.getIgv()), NORMAL_FONT);

        addCell(totalesTable, "Total a Pagar:", BOLD_FONT);
        addCell(totalesTable, formatMoney(venta.getTotal()), NORMAL_FONT);

        document.add(totalesTable);
        System.out.println("Tabla de totales agregada");

        // Pie de página
        Paragraph footer = new Paragraph("\n\nGracias por su compra!\n\n"
                + "SercoYT - Calle Bolívar 438 Lambayeque 14013 Lambayeque, Peru\n"
                + "Teléfono: (+51) 918-060-852 - Email: sercoyt.eirl@gmail.com", NORMAL_FONT);
        footer.setAlignment(Element.ALIGN_CENTER);
        document.add(footer);
        System.out.println("Footer agregado");

        System.out.println("=== PDF generado exitosamente ===");
        
    } catch (Exception e) {
        System.err.println("Error durante la generación del PDF: " + e.getMessage());
        e.printStackTrace();
        throw e;
    } finally {
        if (document != null && document.isOpen()) {
            document.close();
        }
    }
}

    private static void addCell(PdfPTable table, String text, Font font) {
        PdfPCell cell = new PdfPCell(new Phrase(text, font));
        cell.setBorder(PdfPCell.NO_BORDER);
        cell.setPadding(5);
        table.addCell(cell);
    }

    private static void addHeaderCell(PdfPTable table, String text) {
        PdfPCell cell = new PdfPCell(new Phrase(text, BOLD_FONT));
        cell.setBackgroundColor(new BaseColor(220, 220, 220));
        cell.setPadding(5);
        table.addCell(cell);
    }

    private static String formatMoney(double amount) {
        return String.format("S/ %.2f", amount);
    }
}
