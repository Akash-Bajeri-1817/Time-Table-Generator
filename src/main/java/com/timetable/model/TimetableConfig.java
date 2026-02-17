package com.timetable.model;

import jakarta.persistence.*;
import java.time.DayOfWeek;
import java.time.LocalTime;
import java.util.HashSet;
import java.util.Set;

@Entity
@Table(name = "timetable_configs")
public class TimetableConfig {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "config_name", length = 100)
    private String configName;

    @Column(name = "first_lecture_start_time", nullable = false)
    private LocalTime firstLectureStartTime;

    @Column(name = "lecture_duration_minutes", nullable = false)
    private Integer lectureDurationMinutes;

    @Column(name = "lectures_per_day", nullable = false)
    private Integer lecturesPerDay;

    @Column(name = "has_break")
    private Boolean hasBreak = false;

    @Column(name = "break_duration_minutes")
    private Integer breakDurationMinutes;

    @Column(name = "break_after_lecture_number")
    private Integer breakAfterLectureNumber;

    @Column(name = "working_days", length = 200)
    private String workingDays; // Comma-separated: "MONDAY,TUESDAY,WEDNESDAY,THURSDAY,FRIDAY,SATURDAY"

    @Column(name = "is_active")
    private Boolean isActive = true;

    // Constructors
    public TimetableConfig() {
    }

    public TimetableConfig(String configName, LocalTime firstLectureStartTime,
            Integer lectureDurationMinutes, Integer lecturesPerDay) {
        this.configName = configName;
        this.firstLectureStartTime = firstLectureStartTime;
        this.lectureDurationMinutes = lectureDurationMinutes;
        this.lecturesPerDay = lecturesPerDay;
    }

    // Helper method to get working days as Set
    public Set<DayOfWeek> getWorkingDaysSet() {
        Set<DayOfWeek> days = new HashSet<>();
        if (workingDays != null && !workingDays.isEmpty()) {
            String[] dayArray = workingDays.split(",");
            for (String day : dayArray) {
                try {
                    days.add(DayOfWeek.valueOf(day.trim()));
                } catch (IllegalArgumentException e) {
                    // Skip invalid day
                }
            }
        }
        return days;
    }

    // Helper method to set working days from Set
    public void setWorkingDaysFromSet(Set<DayOfWeek> days) {
        if (days == null || days.isEmpty()) {
            this.workingDays = "";
            return;
        }
        StringBuilder sb = new StringBuilder();
        for (DayOfWeek day : days) {
            if (sb.length() > 0) {
                sb.append(",");
            }
            sb.append(day.name());
        }
        this.workingDays = sb.toString();
    }

    // Getters and Setters
    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getConfigName() {
        return configName;
    }

    public void setConfigName(String configName) {
        this.configName = configName;
    }

    public LocalTime getFirstLectureStartTime() {
        return firstLectureStartTime;
    }

    public void setFirstLectureStartTime(LocalTime firstLectureStartTime) {
        this.firstLectureStartTime = firstLectureStartTime;
    }

    public Integer getLectureDurationMinutes() {
        return lectureDurationMinutes;
    }

    public void setLectureDurationMinutes(Integer lectureDurationMinutes) {
        this.lectureDurationMinutes = lectureDurationMinutes;
    }

    public Integer getLecturesPerDay() {
        return lecturesPerDay;
    }

    public void setLecturesPerDay(Integer lecturesPerDay) {
        this.lecturesPerDay = lecturesPerDay;
    }

    public Boolean getHasBreak() {
        return hasBreak;
    }

    public void setHasBreak(Boolean hasBreak) {
        this.hasBreak = hasBreak;
    }

    public Integer getBreakDurationMinutes() {
        return breakDurationMinutes;
    }

    public void setBreakDurationMinutes(Integer breakDurationMinutes) {
        this.breakDurationMinutes = breakDurationMinutes;
    }

    public Integer getBreakAfterLectureNumber() {
        return breakAfterLectureNumber;
    }

    public void setBreakAfterLectureNumber(Integer breakAfterLectureNumber) {
        this.breakAfterLectureNumber = breakAfterLectureNumber;
    }

    public String getWorkingDays() {
        return workingDays;
    }

    public void setWorkingDays(String workingDays) {
        this.workingDays = workingDays;
    }

    public Boolean getIsActive() {
        return isActive;
    }

    public void setIsActive(Boolean isActive) {
        this.isActive = isActive;
    }
}
