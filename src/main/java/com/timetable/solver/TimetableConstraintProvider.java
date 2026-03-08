package com.timetable.solver;

import ai.timefold.solver.core.api.score.buildin.hardsoft.HardSoftScore;
import ai.timefold.solver.core.api.score.stream.Constraint;
import ai.timefold.solver.core.api.score.stream.ConstraintFactory;
import ai.timefold.solver.core.api.score.stream.ConstraintProvider;
import ai.timefold.solver.core.api.score.stream.Joiners;

import com.timetable.model.Schedule;

/**
 * All timetabling rules defined as Timefold constraints.
 *
 * Hard constraints MUST NOT be violated (e.g., teacher clash, room clash).
 * Soft constraints SHOULD be satisfied but can be broken (preferences).
 *
 * IMPORTANT: Timefold evaluates constraints incrementally, including during
 * phases where planning variables (timeSlot, room) are still null.
 * All lambda extractors MUST null-check planning variables before using them,
 * otherwise a NullPointerException will crash the solver stream silently.
 * Using forEach().filter() before forEachUniquePair avoids this issue cleanly.
 */
public class TimetableConstraintProvider implements ConstraintProvider {

        @Override
        public Constraint[] defineConstraints(ConstraintFactory factory) {
                return new Constraint[] {
                                // --- HARD CONSTRAINTS ---
                                // Note: roomConflict removed — rooms are fixed per division
                                // so two divisions can never share a room (ensured by pre-assignment).
                                teacherConflict(factory),
                                studentGroupConflict(factory),
                                divisionConflict(factory),

                                // --- SOFT CONSTRAINTS ---
                                subjectVarietyPerDay(factory)
                };
        }

        // =========================================================
        // HARD 2: A teacher can only teach one class at a time.
        // =========================================================
        private Constraint teacherConflict(ConstraintFactory factory) {
                return factory.forEachUniquePair(Schedule.class,
                                Joiners.equal(Schedule::getTimeSlot),
                                Joiners.equal(s -> s.getWorkload().getFaculty().getId()))
                                .filter((s1, s2) -> s1.getTimeSlot() != null)
                                .penalize(HardSoftScore.ONE_HARD)
                                .asConstraint("Teacher conflict");
        }

        // =========================================================
        // HARD 3: A student group can only attend one lecture at a time.
        // =========================================================
        private Constraint studentGroupConflict(ConstraintFactory factory) {
                return factory.forEachUniquePair(Schedule.class,
                                Joiners.equal(Schedule::getTimeSlot),
                                Joiners.equal(s -> s.getWorkload().getStudentGroup().getId()))
                                .filter((s1, s2) -> s1.getTimeSlot() != null)
                                .penalize(HardSoftScore.ONE_HARD)
                                .asConstraint("Student group conflict");
        }

        // =========================================================
        // HARD 4: A division can only have one class at a time.
        // Only penalises when BOTH schedules have a non-null division.
        // =========================================================
        private Constraint divisionConflict(ConstraintFactory factory) {
                return factory.forEachUniquePair(Schedule.class,
                                Joiners.equal(Schedule::getTimeSlot),
                                Joiners.equal(s -> s.getWorkload().getDivision() != null
                                                ? s.getWorkload().getDivision().getId()
                                                : null))
                                .filter((s1, s2) -> s1.getTimeSlot() != null
                                                && s1.getWorkload().getDivision() != null
                                                && s2.getWorkload().getDivision() != null)
                                .penalize(HardSoftScore.ONE_HARD)
                                .asConstraint("Division conflict");
        }

        // =========================================================
        // SOFT 1: Avoid repeating the same subject twice in a day.
        // Guards against null timeSlot — critical during initial solve phases.
        // =========================================================
        private Constraint subjectVarietyPerDay(ConstraintFactory factory) {
                return factory.forEachUniquePair(Schedule.class,
                                Joiners.equal(s -> s.getTimeSlot() != null
                                                ? s.getTimeSlot().getDayOfWeek()
                                                : null),
                                Joiners.equal(s -> s.getWorkload().getSubject().getId()),
                                Joiners.equal(s -> s.getWorkload().getDivision() != null
                                                ? s.getWorkload().getDivision().getId()
                                                : null))
                                // Only penalise when both have a real timeslot assigned
                                .filter((s1, s2) -> s1.getTimeSlot() != null && s2.getTimeSlot() != null)
                                .penalize(HardSoftScore.ONE_SOFT)
                                .asConstraint("Same subject twice on same day");
        }
}
