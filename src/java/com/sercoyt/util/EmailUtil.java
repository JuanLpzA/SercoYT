package com.sercoyt.util;

import java.util.Properties;
import javax.mail.Message;
import javax.mail.MessagingException;
import javax.mail.PasswordAuthentication;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;

public class EmailUtil {
    // Configuración para Gmail
    private static final String FROM_EMAIL = "sercoyt.eirl@gmail.com";
    private static final String EMAIL_PASSWORD = "ztubepiniokgsvxz";
    private static final String SMTP_HOST = "smtp.gmail.com";
    private static final int SMTP_PORT = 587;

    public static void enviarCodigoVerificacion(String toEmail, String codigoVerificacion) {
        // Validar que el correo destino no esté vacío
        if (toEmail == null || toEmail.trim().isEmpty()) {
            throw new RuntimeException("La dirección de correo electrónico no puede estar vacía");
        }

        Properties props = new Properties();
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");
        props.put("mail.smtp.host", SMTP_HOST);
        props.put("mail.smtp.port", SMTP_PORT);
        props.put("mail.smtp.ssl.trust", SMTP_HOST);
        props.put("mail.smtp.ssl.protocols", "TLSv1.2");

        Session session = Session.getInstance(props,
                new javax.mail.Authenticator() {
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(FROM_EMAIL, EMAIL_PASSWORD);
            }
        });

        try {
            Message message = new MimeMessage(session);
            message.setFrom(new InternetAddress(FROM_EMAIL));

            // Corrección clave: Establecer correctamente el destinatario
            message.setRecipient(Message.RecipientType.TO, new InternetAddress(toEmail));

            message.setSubject("Código de verificación - SercoYT");

            String textoMensaje = "Estimado usuario,\n\n"
                    + "Tu código de verificación es: " + codigoVerificacion + "\n\n"
                    + "Por favor ingresa este código en nuestra página para completar tu registro.\n\n"
                    + "Atentamente,\nEl equipo de SercoYT";

            message.setText(textoMensaje);

            Transport.send(message);
        } catch (MessagingException e) {
            throw new RuntimeException("Error al enviar correo: " + e.getMessage(), e);
        }
    }

    public static void enviarCodigoRecuperacion(String toEmail, String codigoRecuperacion) {
        if (toEmail == null || toEmail.trim().isEmpty()) {
            throw new RuntimeException("La dirección de correo electrónico no puede estar vacía");
        }

        Properties props = new Properties();
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");
        props.put("mail.smtp.host", SMTP_HOST);
        props.put("mail.smtp.port", SMTP_PORT);
        props.put("mail.smtp.ssl.trust", SMTP_HOST);
        props.put("mail.smtp.ssl.protocols", "TLSv1.2");

        Session session = Session.getInstance(props,
                new javax.mail.Authenticator() {
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(FROM_EMAIL, EMAIL_PASSWORD);
            }
        });

        try {
            Message message = new MimeMessage(session);
            message.setFrom(new InternetAddress(FROM_EMAIL));
            message.setRecipient(Message.RecipientType.TO, new InternetAddress(toEmail));
            message.setSubject("Recuperación de contraseña - SercoYT");

            String textoMensaje = "Estimado usuario,\n\n"
                    + "Hemos recibido una solicitud para recuperar tu contraseña.\n\n"
                    + "Tu código de recuperación es: " + codigoRecuperacion + "\n\n"
                    + "Si no has solicitado este cambio, por favor ignora este mensaje.\n\n"
                    + "Atentamente,\nEl equipo de SercoYT";

            message.setText(textoMensaje);

            Transport.send(message);
        } catch (MessagingException e) {
            throw new RuntimeException("Error al enviar correo: " + e.getMessage(), e);
        }
    }
}