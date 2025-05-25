package com.sercoyt.util;

import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.util.Random;
import java.util.regex.Pattern;

public class PasswordUtil {
    private static final String SALT = "SercoYT2025";
    private static final Pattern PASSWORD_PATTERN = 
            Pattern.compile("^(?=.*[0-9])(?=.*[a-zA-Z]).{8,}$");
    private static final Pattern DNI_PATTERN = 
            Pattern.compile("^[0-9]{8}$");
    
    public static String encriptar(String password) {
        try {
            MessageDigest md = MessageDigest.getInstance("SHA-256");
            String saltedPassword = SALT + password;
            byte[] hashedPassword = md.digest(saltedPassword.getBytes());
            
            StringBuilder sb = new StringBuilder();
            for(byte b : hashedPassword) {
                sb.append(String.format("%02x", b));
            }
            return sb.toString();
        } catch (NoSuchAlgorithmException e) {
            throw new RuntimeException("Error al encriptar contraseña", e);
        }
    }
    
    public static boolean esContrasenaValida(String password) {
        return PASSWORD_PATTERN.matcher(password).matches();
    }
    
    public static boolean esDniValido(String dni) {
        return DNI_PATTERN.matcher(dni).matches();
    }
    
    public static String generarCodigoVerificacion() {
        Random random = new Random();
        return String.format("%06d", random.nextInt(999999));
    }
}