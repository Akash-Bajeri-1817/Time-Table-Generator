package com.timetable.dao;

import com.timetable.model.Subject;

public class SubjectDao extends GenericDao<Subject> {
    public SubjectDao() {
        super(Subject.class);
    }
}
