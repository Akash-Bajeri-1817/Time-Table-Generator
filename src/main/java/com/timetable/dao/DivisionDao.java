package com.timetable.dao;

import com.timetable.model.Division;
import com.timetable.model.Branch;
import com.timetable.model.YearLevel;
import com.timetable.util.HibernateUtil;
import org.hibernate.Session;
import java.util.List;
import java.util.Collections;

public class DivisionDao extends GenericDao<Division> {
    public DivisionDao() {
        super(Division.class);
    }

    public List<Division> findByBranch(Branch branch) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            return session.createQuery("FROM Division WHERE branch = :branch ORDER BY year, name", Division.class)
                    .setParameter("branch", branch)
                    .list();
        } catch (Exception e) {
            e.printStackTrace();
            return Collections.emptyList();
        }
    }

    public List<Division> findByBranchAndYear(Branch branch, YearLevel year) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            return session
                    .createQuery("FROM Division WHERE branch = :branch AND year = :year ORDER BY name", Division.class)
                    .setParameter("branch", branch)
                    .setParameter("year", year)
                    .list();
        } catch (Exception e) {
            e.printStackTrace();
            return Collections.emptyList();
        }
    }
}
