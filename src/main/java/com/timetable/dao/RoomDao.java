package com.timetable.dao;

import com.timetable.model.Room;
import com.timetable.util.HibernateUtil;
import org.hibernate.Session;
import org.hibernate.query.Query;
import java.util.List;

public class RoomDao extends GenericDao<Room> {
    public RoomDao() {
        super(Room.class);
    }

    public List<Room> findByType(Room.RoomType type) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            return session.createQuery("from Room where type = :type", Room.class)
                    .setParameter("type", type)
                    .list();
        }
    }

    /** Returns true if a room with this name already exists */
    public boolean existsByName(String name) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            Query<Long> q = session.createQuery(
                "SELECT COUNT(r) FROM Room r WHERE LOWER(r.name) = LOWER(:name)", Long.class);
            q.setParameter("name", name.trim());
            return q.uniqueResult() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
}
