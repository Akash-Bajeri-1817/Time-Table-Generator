package com.timetable.dao;

import com.timetable.model.Faculty;

public class FacultyDao extends GenericDao<Faculty> {
    public FacultyDao() {
        super(Faculty.class);
    }
}
