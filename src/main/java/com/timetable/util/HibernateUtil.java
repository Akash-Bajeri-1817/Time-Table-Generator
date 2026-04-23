package com.timetable.util;

import org.hibernate.SessionFactory;
import org.hibernate.cfg.Configuration;

import java.util.Properties;

public class HibernateUtil {
    private static SessionFactory sessionFactory;

    static {
        try {
            Configuration configuration = new Configuration().configure();

            // Override DB settings from environment variables when running on Render/cloud.
            // Falls back to values in hibernate.cfg.xml for local development.
            String dbUrl      = System.getenv("DB_URL");
            String dbUsername = System.getenv("DB_USERNAME");
            String dbPassword = System.getenv("DB_PASSWORD");

            if (dbUrl != null && !dbUrl.isEmpty()) {
                Properties props = new Properties();
                props.setProperty("hibernate.connection.url",      dbUrl);
                props.setProperty("hibernate.connection.username", dbUsername != null ? dbUsername : "");
                props.setProperty("hibernate.connection.password", dbPassword != null ? dbPassword : "");
                // NeonDB requires SSL
                props.setProperty("hibernate.connection.sslfactory",    "org.postgresql.ssl.NonValidatingFactory");
                props.setProperty("hibernate.connection.sslmode",       "require");
                // Smaller pool for NeonDB free tier (max 10 connections)
                props.setProperty("hibernate.connection.pool_size", "5");
                
                // Enable Batch Fetching to solve N+1 query problem and drastically improve performance
                props.setProperty("hibernate.default_batch_fetch_size", "50");
                
                configuration.addProperties(props);

                System.out.println("[HibernateUtil] Using environment-variable database configuration.");
            } else {
                System.out.println("[HibernateUtil] Using hibernate.cfg.xml database configuration (local).");
            }

            sessionFactory = configuration.buildSessionFactory();
        } catch (Throwable ex) {
            System.err.println("Initial SessionFactory creation failed: " + ex);
            throw new ExceptionInInitializerError(ex);
        }
    }

    public static SessionFactory getSessionFactory() {
        return sessionFactory;
    }

    public static void shutdown() {
        getSessionFactory().close();
    }
}

