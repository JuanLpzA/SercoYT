
<%-- 
    Document   : asesoria
    Created on : 4 jun. 2025, 01:08:05
    Author     : Arrunategui
--%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="es">
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <meta name="description" content="Asesoría técnica especializada en SercoYT - Reparación, armado de equipos y consultas tecnológicas">
        <meta name="keywords" content="asesoría técnica, reparación computadoras, armado PC, soporte técnico">
        <title>SercoYT - Asesoría Técnica Especializada</title>
        
        <!-- Stylesheets -->
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/styleonline.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/asesoria.css">
        <link rel="stylesheet" href="https://use.fontawesome.com/releases/v5.8.2/css/all.css">
        
        <!-- Preload crítico -->
        <link rel="preload" href="https://use.fontawesome.com/releases/v5.8.2/css/all.css" as="style">
    </head>
    <body>
        <!-- Header -->
        <header class="main-header">
            <%@include file="resources/commons/header.jsp" %>
        </header>

        <!-- Contenido Principal -->
        <main class="asesoria-container">
            
            <!-- Hero Section -->
            <section class="hero-section">
                <div class="hero-content">
                    <h1 class="hero-title">Asesoría Técnica Especializada</h1>
                    <p class="hero-subtitle">
                        Soluciones profesionales para todos tus equipos tecnológicos. 
                        Contamos con expertos certificados listos para ayudarte.
                    </p>
                </div>
            </section>

            <!-- Sección de Asesoría Online - Ahora primera -->
            <section class="asesoria-online">
                <h2 class="section-title">Servicios de Asesoría</h2>
                <p class="section-description">
                    Conecta directamente con nuestros especialistas a través de WhatsApp 
                    y recibe atención personalizada para resolver tus necesidades tecnológicas
                </p>
                
                <div class="asesoria-options">
                    <article class="asesoria-card" 
                             onclick="window.location.href='https://api.whatsapp.com/send?phone=51918060852&text=Hola%20SercoYT,%20estoy%20interesado%20en%20el%20servicio%20de%20ARMADO%20de%20equipos'"
                             role="button" 
                             tabindex="0"
                             aria-label="Contactar para servicio de armado de equipos">
                        <div class="asesoria-icon">
                            <i class="fas fa-tools" aria-hidden="true"></i>
                        </div>
                        <h3>Armado de Equipos</h3>
                        <p>Diseñamos y ensamblamos tu PC ideal con componentes de alta calidad, 
                           optimizada para tus necesidades específicas y presupuesto.</p>
                        <button class="btn-asesoria" type="button">
                            Contactar <i class="fab fa-whatsapp" aria-hidden="true"></i>
                        </button>
                    </article>
                    
                    <article class="asesoria-card" 
                             onclick="window.location.href='https://api.whatsapp.com/send?phone=51918060852&text=Hola%20SercoYT,%20necesito%20ayuda%20con%20la%20REPARACIÓN%20de%20mi%20equipo'"
                             role="button" 
                             tabindex="0"
                             aria-label="Contactar para servicio de reparación">
                        <div class="asesoria-icon">
                            <i class="fas fa-wrench" aria-hidden="true"></i>
                        </div>
                        <h3>Reparación Técnica</h3>
                        <p>Diagnóstico profesional y reparación especializada de computadoras, 
                           laptops y dispositivos electrónicos con garantía de servicio.</p>
                        <button class="btn-asesoria" type="button">
                            Contactar <i class="fab fa-whatsapp" aria-hidden="true"></i>
                        </button>
                    </article>
                    
                    <article class="asesoria-card" 
                             onclick="window.location.href='https://api.whatsapp.com/send?phone=51918060852&text=Hola%20SercoYT,%20tengo%20una%20CONSULTA%20sobre%20sus%20productos%20o%20servicios'"
                             role="button" 
                             tabindex="0"
                             aria-label="Contactar para consultas generales">
                        <div class="asesoria-icon">
                            <i class="fas fa-question-circle" aria-hidden="true"></i>
                        </div>
                        <h3>Consultas Especializadas</h3>
                        <p>Asesoramiento técnico personalizado, recomendaciones de compra 
                           y soporte para optimizar el rendimiento de tus equipos.</p>
                        <button class="btn-asesoria" type="button">
                            Contactar <i class="fab fa-whatsapp" aria-hidden="true"></i>
                        </button>
                    </article>
                </div>
            </section>
            
            <!-- Sección de Contacto -->
            <section class="contact-section">
                <h2 class="section-title">Información de Contacto</h2>
                <div class="contact-content">
                    <div class="contact-info">
                        <h3>Datos de Contacto</h3>
                        <p>
                            <i class="fas fa-map-marker-alt" aria-hidden="true"></i> 
                            <span>Calle Bolívar 438, Lambayeque, Perú</span>
                        </p>
                        <p>
                            <i class="fas fa-phone" aria-hidden="true"></i> 
                            <span><a href="tel:+51918060852">(+51) 918-060-852</a></span>
                        </p>
                        <p>
                            <i class="fas fa-envelope" aria-hidden="true"></i> 
                            <span><a href="mailto:Ingsimelowl@gmail.com">Ingsimelowl@gmail.com</a></span>
                        </p>
                        <p>
                            <i class="fas fa-clock" aria-hidden="true"></i> 
                            <span>Lunes a Viernes: 9:00 AM - 7:00 PM<br>Sábados: 10:00 AM - 5:00 PM</span>
                        </p>
                        
                        <div class="social-links">
                            <a href="https://www.facebook.com/Sercoyt.pe/" 
                               target="_blank" 
                               rel="noopener noreferrer"
                               class="social-btn fb"
                               aria-label="Visitar página de Facebook">
                                <i class="fab fa-facebook-f" aria-hidden="true"></i> Facebook
                            </a>
                            <a href="https://www.instagram.com/sercoyt.pe" 
                               target="_blank" 
                               rel="noopener noreferrer"
                               class="social-btn ig"
                               aria-label="Visitar perfil de Instagram">
                                <i class="fab fa-instagram" aria-hidden="true"></i> Instagram
                            </a>
                            <a href="https://api.whatsapp.com/send/?phone=5174626497&text&type=phone_number&app_absent=0" 
                               target="_blank" 
                               rel="noopener noreferrer"
                               class="social-btn wa"
                               aria-label="Contactar por WhatsApp">
                                <i class="fab fa-whatsapp" aria-hidden="true"></i> WhatsApp
                            </a>
                        </div>
                    </div>
                    
                    <div class="map-container">
                        <iframe src="https://www.google.com/maps/embed?pb=!1m18!1m12!1m3!1d394.3973140676939!2d-79.9069856337886!3d-6.703732644442859!2m3!1f0!2f0!3f0!3m2!1i1024!2i768!4f13.1!3m3!1m2!1s0x904ced09546952ab%3A0x510832e0a54aacc7!2sServicio%20de%20Computadoras%20y%20Tecnolog%C3%ADa%20E.I.R.L.%20(SERCOYT)!5e0!3m2!1ses-419!2spe!4v1749016888885!5m2!1ses-419!2spe"
                                width="100%" 
                                height="450" 
                                style="border:0;" 
                                allowfullscreen="" 
                                loading="lazy" 
                                referrerpolicy="no-referrer-when-downgrade"
                                title="Ubicación de SercoYT en Google Maps"
                                aria-label="Mapa de ubicación de SercoYT">
                        </iframe>
                    </div>
                </div>
            </section>
        </main>

        <!-- Footer -->
        <footer class="main-footer">
            <%@include file="resources/commons/footer.jsp" %>
        </footer>

        <!-- Scripts -->
        <script src="${pageContext.request.contextPath}/js/jquery-3.7.1.min.js"></script>
    </body>
</html>