package com.timetable.dao;

import com.timetable.model.Schedule;
import com.timetable.util.HibernateUtil;
import org.hibernate.Session;
import org.hibernate.Transaction;

import java.util.List;

public class ScheduleDao extends GenericDao<Schedule> {
    public ScheduleDao() {
        super(Schedule.class);
    }

    /**
     * Overrides save() to use merge() instead of persist().
     *
     * The Timefold-solved Schedule objects are new (no ID) but contain
     * DETACHED entity references (Workload, Room, TimeSlot loaded in a previous
     * Hibernate session). Using the base persist() would fail with a
     * "detached entity passed to persist" error. merge() correctly handles
     * this by re-attaching the detached associations within the current session.
     */
    @Override
    public void save(Schedule entity) {
        Transaction transaction = null;
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            transaction = session.beginTransaction();
            session.merge(entity);
            transaction.commit();
        } catch (Exception e) {
            if (transaction != null)
                transaction.rollback();
            e.printStackTrace();
        }
    }

    public void deleteAll() {
        Transaction transaction = null;
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            transaction = session.beginTransaction();
            session.createQuery("delete from Schedule").executeUpdate();
            transaction.commit();
        } catch (Exception e) {
            if (transaction != null)
                transaction.rollback();
            e.printStackTrace();
        }
    }
}
