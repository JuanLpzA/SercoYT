package com.sercoyt.util;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import org.json.JSONObject;

public class ReniecAPI {
    private static final String API_URL = "https://api.apis.net.pe/v2/reniec/dni?numero=";
    private static final String TOKEN = "Bearer apis-token-16031.5qKEr2NSEEHNUwXl3C9KiEYret6W9Tte";

    public static JSONObject consultarDni(String dni) throws Exception {
        URL url = new URL(API_URL + dni);
        HttpURLConnection conn = (HttpURLConnection) url.openConnection();
        
        // Configuración 
        conn.setRequestMethod("GET");
        conn.setRequestProperty("Content-Type", "application/json");
        conn.setRequestProperty("Authorization", TOKEN);
        conn.setRequestProperty("Referer", "https://apis.net.pe/consulta-dni-api"); 
        conn.setConnectTimeout(5000); 
        conn.setReadTimeout(5000);
        
        System.out.println("Consultando API RENIEC: " + url); 
        
        int responseCode = conn.getResponseCode();
        if (responseCode == 200) {
            BufferedReader in = new BufferedReader(new InputStreamReader(conn.getInputStream()));
            String inputLine;
            StringBuilder response = new StringBuilder();

            while ((inputLine = in.readLine()) != null) {
                response.append(inputLine);
            }
            in.close();

            String jsonResponse = response.toString();
            System.out.println("Respuesta de la API: " + jsonResponse); 
            return new JSONObject(jsonResponse);
        } else {
            // Leer el mensaje de error de la api de dni 
            BufferedReader errorReader = new BufferedReader(new InputStreamReader(conn.getErrorStream()));
            String errorLine;
            StringBuilder errorResponse = new StringBuilder();
            while ((errorLine = errorReader.readLine()) != null) {
                errorResponse.append(errorLine);
            }
            errorReader.close();
            
            throw new RuntimeException("Error en la API. Código: " + responseCode + ", Mensaje: " + errorResponse.toString());
        }
    }
}