package com.timetable.model;

public enum SessionType {
    THEORY("Theory"),
    PRACTICAL("Practical/Lab");

    private String displayName;

    SessionType(String displayName) {
        this.displayName = displayName;
    }

    public String getDisplayName() {
        return displayName;
    }
}
