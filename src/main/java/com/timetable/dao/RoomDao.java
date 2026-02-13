package com.timetable.dao;

import com.timetable.model.Room;
import com.timetable.util.HibernateUtil;
import org.hibernate.Session;
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
}
