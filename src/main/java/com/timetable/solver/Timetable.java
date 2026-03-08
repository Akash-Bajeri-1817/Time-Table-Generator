package com.timetable.solver;

import ai.timefold.solver.core.api.domain.solution.PlanningEntityCollectionProperty;
import ai.timefold.solver.core.api.domain.solution.PlanningScore;
import ai.timefold.solver.core.api.domain.solution.PlanningSolution;
import ai.timefold.solver.core.api.domain.solution.ProblemFactCollectionProperty;
import ai.timefold.solver.core.api.domain.valuerange.ValueRangeProvider;
import ai.timefold.solver.core.api.score.buildin.hardsoft.HardSoftScore;

import com.timetable.model.Schedule;
import com.timetable.model.TimeSlot;

import java.util.List;

/**
 * The PlanningSolution wraps all input data and the list of Schedules the AI
 * will solve.
 *
 * Room is NO LONGER a planning variable — each division has a fixed room for
 * the
 * entire semester (pre-assigned before solving). The AI only decides which
 * TimeSlot each lecture goes into.
 */
@PlanningSolution
public class Timetable {

    /** The full pool of available time slots the AI can pick from. */
    @ValueRangeProvider(id = "timeSlotRange")
    @ProblemFactCollectionProperty
    private List<TimeSlot> timeSlotList;

    /**
     * One Schedule entry per required lecture.
     * The AI fills in timeSlot only; room is already pre-assigned.
     */
    @PlanningEntityCollectionProperty
    private List<Schedule> scheduleList;

    /**
     * The AI uses this score to know how good/bad a solution is.
     * Hard score = 0 means no clashes. Soft score = higher means more preferred.
     */
    @PlanningScore
    private HardSoftScore score;

    // Required no-arg constructor for Timefold
    public Timetable() {
    }

    public Timetable(List<TimeSlot> timeSlotList, List<Schedule> scheduleList) {
        this.timeSlotList = timeSlotList;
        this.scheduleList = scheduleList;
    }

    public List<TimeSlot> getTimeSlotList() {
        return timeSlotList;
    }

    public List<Schedule> getScheduleList() {
        return scheduleList;
    }

    public HardSoftScore getScore() {
        return score;
    }

    public void setTimeSlotList(List<TimeSlot> timeSlotList) {
        this.timeSlotList = timeSlotList;
    }

    public void setScheduleList(List<Schedule> scheduleList) {
        this.scheduleList = scheduleList;
    }

    public void setScore(HardSoftScore score) {
        this.score = score;
    }
}
