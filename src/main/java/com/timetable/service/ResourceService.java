package com.timetable.service;

import com.timetable.dao.*;
import com.timetable.model.*;
import java.util.List;

public class ResourceService {
    private final FacultyDao facultyDao = new FacultyDao();
    private final SubjectDao subjectDao = new SubjectDao();
    private final RoomDao roomDao = new RoomDao();
    private final StudentGroupDao studentGroupDao = new StudentGroupDao();
    private final WorkloadDao workloadDao = new WorkloadDao();
    private final TimeSlotDao timeSlotDao = new TimeSlotDao();

    // Faculty
    public void addFaculty(Faculty faculty) {
        facultyDao.save(faculty);
    }

    public List<Faculty> getAllFaculty() {
        return facultyDao.findAll();
    }

    public void deleteFaculty(Long id) {
        facultyDao.delete(id);
    }

    public Faculty getFaculty(Long id) {
        return facultyDao.findById(id);
    }

    // Subject
    public void addSubject(Subject subject) {
        subjectDao.save(subject);
    }

    public List<Subject> getAllSubjects() {
        return subjectDao.findAll();
    }

    public void deleteSubject(Long id) {
        subjectDao.delete(id);
    }

    public Subject getSubject(Long id) {
        return subjectDao.findById(id);
    }

    // Room
    public void addRoom(Room room) {
        roomDao.save(room);
    }

    public List<Room> getAllRooms() {
        return roomDao.findAll();
    }

    public void deleteRoom(Long id) {
        roomDao.delete(id);
    }

    // Student Group
    public void addStudentGroup(StudentGroup group) {
        studentGroupDao.save(group);
    }

    public List<StudentGroup> getAllStudentGroups() {
        return studentGroupDao.findAll();
    }

    public void deleteStudentGroup(Long id) {
        studentGroupDao.delete(id);
    }

    public StudentGroup getStudentGroup(Long id) {
        return studentGroupDao.findById(id);
    }

    // Workload
    public void addWorkload(Workload workload) {
        workloadDao.save(workload);
    }

    public List<Workload> getAllWorkloads() {
        return workloadDao.findAll();
    }

    public void deleteWorkload(Long id) {
        workloadDao.delete(id);
    }

    // TimeSlot
    public void addTimeSlot(TimeSlot timeSlot) {
        timeSlotDao.save(timeSlot);
    }

    public List<TimeSlot> getAllTimeSlots() {
        return timeSlotDao.findAll();
    }
}
