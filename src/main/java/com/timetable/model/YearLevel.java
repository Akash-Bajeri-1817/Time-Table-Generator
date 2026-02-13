package com.timetable.model;

public enum YearLevel {
    FY("First Year"),
    SY("Second Year"),
    TY("Third Year");

    private String displayName;

    YearLevel(String displayName) {
        this.displayName = displayName;
    }

    public String getDisplayName() {
        return displayName;
    }
}
