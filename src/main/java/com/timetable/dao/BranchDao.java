package com.timetable.dao;

import com.timetable.model.Branch;
import com.timetable.util.HibernateUtil;
import org.hibernate.Session;

public class BranchDao extends GenericDao<Branch> {
    public BranchDao() {
        super(Branch.class);
    }

    public Branch findByCode(String code) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            return session.createQuery("FROM Branch WHERE code = :code", Branch.class)
                    .setParameter("code", code)
                    .uniqueResult();
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }
}
