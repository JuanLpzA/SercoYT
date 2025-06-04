package com.sercoyt.config;

import com.sercoyt.controller.ServletContextProvider;
import com.zaxxer.hikari.HikariConfig;
import com.zaxxer.hikari.HikariDataSource;
import java.io.FileInputStream;
import java.io.IOException;
import java.util.Properties;
import java.util.logging.Level;
import javax.servlet.ServletContext;
import java.util.logging.Logger;
import java.sql.Connection;
import java.sql.SQLException;
import java.sql.DriverManager;

public class ConnectDB {

    private static final Logger logger = Logger.getLogger(ConnectDB.class.getName());
    private static HikariDataSource dataSource;

    static {
        try {
            // Cargar explícitamente el driver de MySQL
            Class.forName("com.mysql.cj.jdbc.Driver");

            Properties properties = loadProperties();
            String url = properties.getProperty("database.url");
            String user = properties.getProperty("database.user");
            String password = properties.getProperty("database.password");
            int maxPool = Integer.parseInt(properties.getProperty("database.maxpool"));

            HikariConfig config = new HikariConfig();
            config.setJdbcUrl(url);
            config.setUsername(user);
            config.setPassword(password);
            config.setMaximumPoolSize(maxPool);
            config.setMinimumIdle(Math.min(5, maxPool));

            // Configuración de tiempo de espera
            config.setConnectionTimeout(30000);
            config.setValidationTimeout(5000);
            config.setIdleTimeout(600000);
            config.setMaxLifetime(1800000);
            config.setLeakDetectionThreshold(60000);

            // Configuración específica para MySQL
            config.addDataSourceProperty("cachePrepStmts", "true");
            config.addDataSourceProperty("prepStmtCacheSize", "250");
            config.addDataSourceProperty("prepStmtCacheSqlLimit", "2048");
            config.addDataSourceProperty("useServerPrepStmts", "true");
            config.addDataSourceProperty("useSSL", "false");
            config.addDataSourceProperty("allowPublicKeyRetrieval", "true");
            config.addDataSourceProperty("autoReconnect", "true");

            dataSource = new HikariDataSource(config);
            logger.log(Level.INFO, "Pool de conexiones inicializado correctamente");

            // Test connection
            try (Connection conn = dataSource.getConnection()) {
                logger.log(Level.INFO, "Conexión de prueba exitosa a la base de datos");
            }

        } catch (Exception e) {
            logger.log(Level.SEVERE, "Error fatal al inicializar el pool de conexiones", e);
            throw new RuntimeException("No se pudo inicializar el pool de conexiones", e);
        }
    }

    public static Connection getConnection() throws SQLException {
        return dataSource.getConnection();
    }

    private static Properties loadProperties() throws IOException {
        Properties props = new Properties();
        ServletContext context = ServletContextProvider.getContextServlet();
        String path = context.getRealPath("/WEB-INF/application.properties");
        try (FileInputStream fis = new FileInputStream(path)) {
            props.load(fis);
            return props;
        }
    }

    public static void shutdown() {
        if (dataSource != null && !dataSource.isClosed()) {
            dataSource.close();
            logger.log(Level.INFO, "Pool de conexiones cerrado correctamente");
        }
    }
}
