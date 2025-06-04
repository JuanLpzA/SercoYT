<%-- 
    Document   : conocenos
    Created on : 4 jun. 2025, 01:09:36
    Author     : Arrunategui
--%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>SercoYT - Conócenos</title>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/styleonline.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/conocenos.css">
        <link rel="stylesheet" href="https://use.fontawesome.com/releases/v6.4.0/css/all.css">
        <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
        <link href="https://unpkg.com/aos@2.3.1/dist/aos.css" rel="stylesheet">
    </head>
    <body>
        <!-- Header -->
        <header class="main-header">
            <%@include file="resources/commons/header.jsp" %>
        </header>

        <!-- Hero Section -->
        <section class="hero-section">
            <div class="hero-overlay"></div>
            <div class="hero-content container">
                <div class="hero-text" data-aos="fade-right" data-aos-duration="800">
                    <h1 class="hero-title">Descubre Nuestra Esencia</h1>
                    <p class="hero-subtitle">Innovación y calidad en cada producto que ofrecemos</p>
                    <div class="hero-stats">
                        <div class="stat-item">
                            <div class="stat-icon">
                                <i class="fas fa-medal"></i>
                            </div>
                            <div class="stat-content">
                                <span class="stat-number" data-count="100">0</span>
                                <span class="stat-label">Productos Certificados</span>
                            </div>
                        </div>
                        <div class="stat-item">
                            <div class="stat-icon">
                                <i class="fas fa-headset"></i>
                            </div>
                            <div class="stat-content">
                                <span class="stat-number" data-count="24">0</span>
                                <span class="stat-label">Soporte Continuo</span>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="hero-visual" data-aos="fade-left" data-aos-duration="800" data-aos-delay="200">
                    <div class="floating-cards">
                        <div class="floating-card card-1">
                            <i class="fas fa-shield-alt"></i>
                            <span>Garantía</span>
                        </div>
                        <div class="floating-card card-2">
                            <i class="fas fa-truck"></i>
                            <span>Envíos</span>
                        </div>
                        <div class="floating-card card-3">
                            <i class="fas fa-hand-holding-usd"></i>
                            <span>Financiación</span>
                        </div>
                    </div>
                </div>
            </div>
            <div class="hero-waves">
                <svg viewBox="0 0 1200 120" preserveAspectRatio="none">
                    <path d="M0,0V46.29c47.79,22.2,103.59,32.17,158,28,70.36-5.37,136.33-33.31,206.8-37.5C438.64,32.43,512.34,53.67,583,72.05c69.27,18,138.3,24.88,209.4,13.08,36.15-6,69.85-17.84,104.45-29.34C989.49,25,1113-14.29,1200,52.47V0Z" opacity=".25" fill="#3CB371"></path>
                    <path d="M0,0V15.81C13,36.92,27.64,56.86,47.69,72.05,99.41,111.27,165,111,224.58,91.58c31.15-10.15,60.09-26.07,89.67-39.8,40.92-19,84.73-46,130.83-49.67,36.26-2.85,70.9,9.42,98.6,31.56,31.77,25.39,62.32,62,103.63,73,40.44,10.79,81.35-6.69,119.13-24.28s75.16-39,116.92-43.05c59.73-5.85,113.28,22.88,168.9,38.84,30.2,8.66,59,6.17,87.09-7.5,22.43-10.89,48-26.93,60.65-49.24V0Z" opacity=".5" fill="#3CB371"></path>
                    <path d="M0,0V5.63C149.93,59,314.09,71.32,475.83,42.57c43-7.64,84.23-20.12,127.61-26.46,59-8.63,112.48,12.24,165.56,35.4C827.93,77.22,886,95.24,951.2,90c86.53-7,172.46-45.71,248.8-84.81V0Z" fill="#3CB371"></path>
                </svg>
            </div>
        </section>

        <!-- Contenido Principal -->
        <main class="conocenos-container">
            
            <!-- Sección Quiénes Somos -->
            <section class="about-section">
                <div class="section-header" data-aos="fade-up">
                    <span class="section-badge">Nuestra Identidad</span>
                    <h2 class="section-title">¿Quiénes Somos?</h2>
                    <p class="section-description">Conoce la pasión que impulsa nuestro trabajo</p>
                </div>
                <div class="about-content">
                    <div class="about-visual" data-aos="fade-right">
                        <div class="about-image-container">
                            <img src="${pageContext.request.contextPath}/img/about.jpg" alt="Equipo SercoYT" class="about-image">
                            <div class="image-overlay">
                                <div class="overlay-content">
                                    <i class="fas fa-play-circle"></i>
                                    <span>Nuestra Historia</span>
                                </div>
                            </div>
                        </div>
                        <div class="experience-badge">
                            <span class="badge-number">+5</span>
                            <span class="badge-text">Años en el mercado</span>
                        </div>
                    </div>
                    <div class="about-text" data-aos="fade-left" data-aos-delay="200">
                        <div class="text-content">
                            <h3>Excelencia en cada detalle</h3>
                            <p class="lead-text">En SercoYT nos dedicamos a ofrecer productos tecnológicos de la más alta calidad, seleccionados cuidadosamente para satisfacer las necesidades de nuestros clientes.</p>
                            <p>Nuestro equipo está compuesto por profesionales apasionados por la tecnología, comprometidos con brindar asesoramiento personalizado y soluciones adaptadas a cada requerimiento.</p>
                            <div class="highlight-message">
                                <div class="quote-icon">
                                    <i class="fas fa-quote-left"></i>
                                </div>
                                <p>"Creemos que la tecnología debe ser accesible, confiable y mejorar la vida de las personas. Ese es nuestro compromiso diario."</p>
                                <div class="quote-author">
                                    <span>Equipo SercoYT</span>
                                </div>
                            </div>
                            <div class="cta-buttons">
                                <a href="#contacto" class="btn btn-primary">
                                    <span>Contáctanos</span>
                                    <i class="fas fa-arrow-right"></i>
                                </a>
                                <a href="#productos" class="btn btn-outline">
                                    <span>Nuestros productos</span>
                                    <i class="fas fa-box-open"></i>
                                </a>
                            </div>
                        </div>
                    </div>
                </div>
            </section>
            
            <!-- Sección Misión y Visión -->
            <section class="mission-vision-section">
                <div class="section-header" data-aos="fade-up">
                    <span class="section-badge">Nuestro Propósito</span>
                    <h2 class="section-title">Misión & Visión</h2>
                    <p class="section-description">Los pilares que guían nuestro camino</p>
                </div>
                <div class="mv-container">
                    <div class="mv-card vision-card" data-aos="fade-up" data-aos-delay="100">
                        <div class="card-header">
                            <div class="mv-icon">
                                <i class="fas fa-eye"></i>
                            </div>
                            <h3>Visión</h3>
                        </div>
                        <div class="card-content">
                            <p>Ser reconocidos como líderes en distribución de tecnología, destacando por nuestra calidad, servicio personalizado y compromiso con la innovación constante.</p>
                            <ul class="vision-list">
                                <li>
                                    <i class="fas fa-check"></i>
                                    <span>Referentes en el sector tecnológico</span>
                                </li>
                                <li>
                                    <i class="fas fa-check"></i>
                                    <span>Expansión sostenible y responsable</span>
                                </li>
                                <li>
                                    <i class="fas fa-check"></i>
                                    <span>Relaciones comerciales a largo plazo</span>
                                </li>
                            </ul>
                        </div>
                        <div class="card-decoration">
                            <div class="decoration-circle circle-1"></div>
                            <div class="decoration-circle circle-2"></div>
                        </div>
                    </div>
                    
                    <div class="mv-card mission-card" data-aos="fade-up" data-aos-delay="300">
                        <div class="card-header">
                            <div class="mv-icon">
                                <i class="fas fa-bullseye"></i>
                            </div>
                            <h3>Misión</h3>
                        </div>
                        <div class="card-content">
                            <p>Brindar soluciones tecnológicas innovadoras que faciliten la vida y el trabajo de nuestros clientes, con productos de calidad y un servicio excepcional.</p>
                            <ul class="mission-list">
                                <li>
                                    <i class="fas fa-check"></i>
                                    <span>Asesoramiento técnico especializado</span>
                                </li>
                                <li>
                                    <i class="fas fa-check"></i>
                                    <span>Productos con garantía certificada</span>
                                </li>
                                <li>
                                    <i class="fas fa-check"></i>
                                    <span>Soporte post-venta integral</span>
                                </li>
                                <li>
                                    <i class="fas fa-check"></i>
                                    <span>Precios competitivos y transparentes</span>
                                </li>
                            </ul>
                        </div>
                    </div>
                </div>
            </section>
            
            <!-- Sección Valores -->
            <section class="values-section">
                <div class="section-header" data-aos="fade-up">
                    <span class="section-badge">Nuestra Filosofía</span>
                    <h2 class="section-title">Valores Corporativos</h2>
                    <p class="section-description">Principios que definen nuestra forma de trabajar</p>
                </div>
                <div class="values-grid">
                    <div class="value-card" data-aos="fade-up" data-aos-delay="100">
                        <div class="card-inner">
                            <div class="card-front">
                                <div class="value-icon">
                                    <i class="fas fa-handshake"></i>
                                </div>
                                <h3>Integridad</h3>
                                <p>Honestidad en cada acción</p>
                            </div>
                            <div class="card-back">
                                <h3>Integridad</h3>
                                <p>Actuamos con transparencia y ética en todas nuestras relaciones comerciales, manteniendo siempre nuestra palabra.</p>
                                <div class="card-accent"></div>
                            </div>
                        </div>
                    </div>
                    
                    <div class="value-card" data-aos="fade-up" data-aos-delay="200">
                        <div class="card-inner">
                            <div class="card-front">
                                <div class="value-icon">
                                    <i class="fas fa-lightbulb"></i>
                                </div>
                                <h3>Innovación</h3>
                                <p>Buscamos constantemente mejorar</p>
                            </div>
                            <div class="card-back">
                                <h3>Innovación</h3>
                                <p>Nos mantenemos a la vanguardia tecnológica para ofrecer siempre las mejores soluciones a nuestros clientes.</p>
                                <div class="card-accent"></div>
                            </div>
                        </div>
                    </div>
                    
                    <div class="value-card" data-aos="fade-up" data-aos-delay="300">
                        <div class="card-inner">
                            <div class="card-front">
                                <div class="value-icon">
                                    <i class="fas fa-heart"></i>
                                </div>
                                <h3>Pasión</h3>
                                <p>Amor por lo que hacemos</p>
                            </div>
                            <div class="card-back">
                                <h3>Pasión</h3>
                                <p>Nos apasiona la tecnología y ese entusiasmo se refleja en nuestro servicio y atención al cliente.</p>
                                <div class="card-accent"></div>
                            </div>
                        </div>
                    </div>
                    
                    <div class="value-card" data-aos="fade-up" data-aos-delay="400">
                        <div class="card-inner">
                            <div class="card-front">
                                <div class="value-icon">
                                    <i class="fas fa-users"></i>
                                </div>
                                <h3>Trabajo en Equipo</h3>
                                <p>Juntos logramos más</p>
                            </div>
                            <div class="card-back">
                                <h3>Trabajo en Equipo</h3>
                                <p>Fomentamos la colaboración y el respeto mutuo para alcanzar objetivos comunes y superar expectativas.</p>
                                <div class="card-accent"></div>
                            </div>
                        </div>
                    </div>
                </div>
            </section>

           
            <!-- Call to Action Final -->
            <section class="cta-section" data-aos="fade-up">
                <div class="cta-content container">
                    <div class="cta-text">
                        <h2>¿Listo para Experimentar la Diferencia?</h2>
                        <p>Descubre por qué nuestros clientes confían en nosotros para sus necesidades tecnológicas</p>
                    </div>
                    <div class="cta-actions">
                        <a href="#tienda" class="btn btn-white">
                            <span>Explorar Catálogo</span>
                            <i class="fas fa-shopping-cart"></i>
                        </a>
                        <a href="#contacto" class="btn btn-transparent">
                            <span>Hablar con un Asesor</span>
                            <i class="fas fa-comments"></i>
                        </a>
                    </div>
                </div>
            </section>
        </main>

        <!-- Footer -->
        <footer class="main-footer">
            <%@include file="resources/commons/footer.jsp" %>
        </footer>

        <script src="${pageContext.request.contextPath}/js/jquery-3.7.1.min.js"></script>
        <script src="https://unpkg.com/aos@2.3.1/dist/aos.js"></script>
        <script>
            // Inicializar AOS (Animate On Scroll)
            AOS.init({
                duration: 800,
                easing: 'ease-in-out',
                once: true
            });

            // Animación de contadores
            $(document).ready(function() {
                function animateCounters() {
                    $('.stat-number[data-count]').each(function() {
                        const $this = $(this);
                        const countTo = parseInt($this.attr('data-count'));
                        
                        $({ countNum: 0 }).animate({
                            countNum: countTo
                        }, {
                            duration: 2000,
                            easing: 'swing',
                            step: function() {
                                $this.text(Math.floor(this.countNum));
                            },
                            complete: function() {
                                $this.text(countTo);
                            }
                        });
                    });
                }

                // Trigger animación cuando el elemento sea visible
                const statsObserver = new IntersectionObserver(function(entries) {
                    entries.forEach(entry => {
                        if (entry.isIntersecting) {
                            animateCounters();
                            statsObserver.unobserve(entry.target);
                        }
                    });
                }, { threshold: 0.5 });

                const statsSection = document.querySelector('.hero-stats');
                if (statsSection) {
                    statsObserver.observe(statsSection);
                }

                // Efecto hover para tarjetas de valores
                $('.value-card').hover(
                    function() {
                        $(this).find('.card-inner').css('transform', 'rotateY(180deg)');
                    },
                    function() {
                        $(this).find('.card-inner').css('transform', 'rotateY(0deg)');
                    }
                );

                // Smooth scroll para enlaces
                $('a[href^="#"]').on('click', function(e) {
                    e.preventDefault();
                    const target = $(this.getAttribute('href'));
                    if (target.length) {
                        $('html, body').animate({
                            scrollTop: target.offset().top - 100
                        }, 800);
                    }
                });
            });
        </script>
    </body>
</html>