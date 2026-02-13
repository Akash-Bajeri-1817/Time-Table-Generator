package com.timetable.model;

import jakarta.persistence.*;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.AllArgsConstructor;
import java.util.List;

@Entity
@Table(name = "student_groups")
@Data
@NoArgsConstructor
@AllArgsConstructor
public class StudentGroup {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false, unique = true)
    private String name;

    @ManyToOne
    @JoinColumn(name = "parent_group_id")
    private StudentGroup parentGroup; // For batches like "Div A - Batch 1" having "Div A" as parent

    // Helper to check if this is a main group (Division) or sub-group (Batch)
    public boolean isBatch() {
        return parentGroup != null;
    }

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

    public StudentGroup getParentGroup() {
        return parentGroup;
    }

    public void setParentGroup(StudentGroup parentGroup) {
        this.parentGroup = parentGroup;
    }
}
