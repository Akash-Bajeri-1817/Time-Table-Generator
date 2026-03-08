package com.timetable.dao;

import com.timetable.model.Workload;
import com.timetable.util.HibernateUtil;
import org.hibernate.Session;

import java.util.List;

public class WorkloadDao extends GenericDao<Workload> {
    public WorkloadDao() {
        super(Workload.class);
    }

    /**
     * Overrides findAll() to eagerly fetch all lazy associations (faculty, subject,
     * studentGroup, division, batch). This is REQUIRED so that the Timefold AI
     * solver can access these properties after the Hibernate session is closed.
     * Without this, the solver throws LazyInitializationException when evaluating
     * constraints, silently failing the generation.
     */
    @Override
    public List<Workload> findAll() {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            return session.createQuery(
                    "SELECT DISTINCT w FROM com.timetable.model.Workload w " +
                            "LEFT JOIN FETCH w.faculty " +
                            "LEFT JOIN FETCH w.subject " +
                            "LEFT JOIN FETCH w.studentGroup " +
                            "LEFT JOIN FETCH w.division " +
                            "LEFT JOIN FETCH w.batch",
                    Workload.class).list();
        }
    }
}
