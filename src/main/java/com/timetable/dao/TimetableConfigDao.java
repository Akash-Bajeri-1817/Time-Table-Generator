package com.timetable.dao;

import com.timetable.model.TimetableConfig;
import com.timetable.util.HibernateUtil;
import org.hibernate.Session;
import org.hibernate.Transaction;
import org.hibernate.query.Query;

public class TimetableConfigDao extends GenericDao<TimetableConfig> {

    public TimetableConfigDao() {
        super(TimetableConfig.class);
    }

    /**
     * Get the active configuration
     */
    public TimetableConfig getActiveConfig() {
        Transaction transaction = null;
        TimetableConfig config = null;
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            transaction = session.beginTransaction();
            Query<TimetableConfig> query = session.createQuery(
                    "FROM TimetableConfig WHERE isActive = true ORDER BY id DESC",
                    TimetableConfig.class);
            query.setMaxResults(1);
            config = query.uniqueResult();
            transaction.commit();
        } catch (Exception e) {
            if (transaction != null) {
                transaction.rollback();
            }
            e.printStackTrace();
        }
        return config;
    }

    /**
     * Deactivate all configs
     */
    public void deactivateAll() {
        Transaction transaction = null;
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            transaction = session.beginTransaction();
            session.createMutationQuery("UPDATE TimetableConfig SET isActive = false")
                    .executeUpdate();
            transaction.commit();
        } catch (Exception e) {
            if (transaction != null) {
                transaction.rollback();
            }
            e.printStackTrace();
        }
    }

    /**
     * Save config and set as active
     */
    public void saveAsActive(TimetableConfig config) {
        // Deactivate all existing configs
        deactivateAll();

        // Set this config as active
        config.setIsActive(true);

        // Save the config
        save(config);
    }
}
