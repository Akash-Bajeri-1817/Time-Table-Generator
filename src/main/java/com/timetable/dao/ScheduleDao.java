package com.timetable.dao;

import com.timetable.model.Schedule;
import com.timetable.util.HibernateUtil;
import org.hibernate.Session;
import org.hibernate.Transaction;

public class ScheduleDao extends GenericDao<Schedule> {
    public ScheduleDao() {
        super(Schedule.class);
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
