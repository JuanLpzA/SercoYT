/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.sercoyt.util;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import org.json.JSONObject;

/**
 *
 * @author Arrunategui
 */
public class SunatAPI {
    private static final String API_URL_BASIC = "https://api.apis.net.pe/v2/sunat/ruc?numero=";
    private static final String API_URL_FULL = "https://api.apis.net.pe/v2/sunat/ruc/full?numero=";
    private static final String TOKEN = "Bearer apis-token-15638.ohYOvAVirRjjGuOhXtksC9eZpnkMzimr";
    
    public static JSONObject consultarRucBasico(String ruc) throws Exception {
        return consultarRuc(ruc, false);
    }
    

    public static JSONObject consultarRucCompleto(String ruc) throws Exception {
        return consultarRuc(ruc, true);
    }
    
    private static JSONObject consultarRuc(String ruc, boolean esCompleto) throws Exception {
        String urlString = esCompleto ? API_URL_FULL + ruc : API_URL_BASIC + ruc;
        URL url = new URL(urlString);
        HttpURLConnection conn = (HttpURLConnection) url.openConnection();
        
        // Configuración
        conn.setRequestMethod("GET");
        conn.setRequestProperty("Content-Type", "application/json");
        conn.setRequestProperty("Accept", "application/json");
        conn.setRequestProperty("Authorization", TOKEN);
        conn.setRequestProperty("Referer", "https://apis.net.pe/consulta-ruc-api");
        conn.setConnectTimeout(5000);
        conn.setReadTimeout(5000);
        
        System.out.println("Consultando API SUNAT: " + url);
        
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
            // Leer el mensaje de error de la API de RUC
            BufferedReader errorReader = new BufferedReader(new InputStreamReader(conn.getErrorStream()));
            String errorLine;
            StringBuilder errorResponse = new StringBuilder();
            while ((errorLine = errorReader.readLine()) != null) {
                errorResponse.append(errorLine);
            }
            errorReader.close();
            
            throw new RuntimeException("Error en la API SUNAT. Código: " + responseCode + ", Mensaje: " + errorResponse.toString());
        }
    }
}