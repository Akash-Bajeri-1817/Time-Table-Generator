package com.timetable.dao;

import com.timetable.model.Batch;
import com.timetable.model.Division;
import com.timetable.util.HibernateUtil;
import org.hibernate.Session;
import java.util.List;
import java.util.Collections;

public class BatchDao extends GenericDao<Batch> {
    public BatchDao() {
        super(Batch.class);
    }

    public List<Batch> findByDivision(Division division) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            return session.createQuery("FROM Batch WHERE division = :division ORDER BY startRollNo", Batch.class)
                    .setParameter("division", division)
                    .list();
        } catch (Exception e) {
            e.printStackTrace();
            return Collections.emptyList();
        }
    }
}
