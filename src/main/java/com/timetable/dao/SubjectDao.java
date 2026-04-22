package com.timetable.dao;

import com.timetable.model.Subject;
import com.timetable.util.HibernateUtil;
import org.hibernate.Session;
import org.hibernate.query.Query;

public class SubjectDao extends GenericDao<Subject> {
    public SubjectDao() {
        super(Subject.class);
    }

    /** Returns true if a subject with this code already exists */
    public boolean existsByCode(String code) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            Query<Long> q = session.createQuery(
                "SELECT COUNT(s) FROM Subject s WHERE LOWER(s.code) = LOWER(:code)", Long.class);
            q.setParameter("code", code.trim());
            return q.uniqueResult() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    /** Returns true if a subject with this name already exists */
    public boolean existsByName(String name) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            Query<Long> q = session.createQuery(
                "SELECT COUNT(s) FROM Subject s WHERE LOWER(s.name) = LOWER(:name)", Long.class);
            q.setParameter("name", name.trim());
            return q.uniqueResult() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
}
