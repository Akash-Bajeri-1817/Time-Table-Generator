package com.timetable.model;

import jakarta.persistence.*;

@Entity
@Table(name = "divisions")
public class Division {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false, length = 10)
    private String name; // "A", "B", "C"

    @ManyToOne
    @JoinColumn(name = "branch_id", nullable = false)
    private Branch branch;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    private YearLevel year; // FY, SY, TY

    @Column
    private Integer capacity; // Max students

    @Column(length = 20)
    private String classroom; // Default classroom number

    // Constructors
    public Division() {
    }

    public Division(String name, Branch branch, YearLevel year) {
        this.name = name;
        this.branch = branch;
        this.year = year;
    }

    // Getters and Setters
    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public Branch getBranch() {
        return branch;
    }

    public void setBranch(Branch branch) {
        this.branch = branch;
    }

    public YearLevel getYear() {
        return year;
    }

    public void setYear(YearLevel year) {
        this.year = year;
    }

    public Integer getCapacity() {
        return capacity;
    }

    public void setCapacity(Integer capacity) {
        this.capacity = capacity;
    }

    public String getClassroom() {
        return classroom;
    }

    public void setClassroom(String classroom) {
        this.classroom = classroom;
    }

    // Helper method to get full name
    public String getFullName() {
        return year.name() + " " + branch.getCode() + " - Div " + name;
    }
}
