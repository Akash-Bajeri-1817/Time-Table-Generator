package com.timetable.model;

import jakarta.persistence.*;

@Entity
@Table(name = "batches")
public class Batch {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false, length = 50)
    private String name; // "A01-A30", "B31-B60"

    @ManyToOne
    @JoinColumn(name = "division_id", nullable = false)
    private Division division;

    @Column
    private Integer startRollNo;

    @Column
    private Integer endRollNo;

    // Constructors
    public Batch() {
    }

    public Batch(String name, Division division, Integer startRollNo, Integer endRollNo) {
        this.name = name;
        this.division = division;
        this.startRollNo = startRollNo;
        this.endRollNo = endRollNo;
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

    public Division getDivision() {
        return division;
    }

    public void setDivision(Division division) {
        this.division = division;
    }

    public Integer getStartRollNo() {
        return startRollNo;
    }

    public void setStartRollNo(Integer startRollNo) {
        this.startRollNo = startRollNo;
    }

    public Integer getEndRollNo() {
        return endRollNo;
    }

    public void setEndRollNo(Integer endRollNo) {
        this.endRollNo = endRollNo;
    }
}
