package com.timetable.dao;

import com.timetable.model.Faculty;

import com.timetable.util.HibernateUtil;
import org.hibernate.Session;
import org.hibernate.query.Query;

public class FacultyDao extends GenericDao<Faculty> {
    public FacultyDao() {
        super(Faculty.class);
    }

    public Faculty findByEmail(String email) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            Query<Faculty> query = session.createQuery("FROM Faculty f WHERE f.email = :email", Faculty.class);
            query.setParameter("email", email);
            return query.uniqueResult();
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }
}
