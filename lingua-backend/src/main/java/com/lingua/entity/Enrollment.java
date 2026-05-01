package com.lingua.entity;

import io.quarkus.hibernate.orm.panache.PanacheEntityBase;
import jakarta.persistence.*;
import java.time.LocalDateTime;

@Entity
@Table(name = "enrollments")
public class Enrollment extends PanacheEntityBase {
    @Id @GeneratedValue(strategy = GenerationType.IDENTITY)
    public Long id;
    @Column(name = "user_id") public Long userId;
    @Column(name = "course_id") public Long courseId;
    @Enumerated(EnumType.STRING) public EnrollStatus status = EnrollStatus.ACTIVE;
    @Column(name = "progress_percent") public Double progressPercent = 0.0;
    @Column(name = "enrolled_at") public LocalDateTime enrolledAt = LocalDateTime.now();
    @Column(name = "completed_at") public LocalDateTime completedAt;

    public enum EnrollStatus { ACTIVE, COMPLETED, DROPPED }

    public static Enrollment findByUserAndCourse(Long userId, Long courseId) {
        return find("userId = ?1 and courseId = ?2", userId, courseId).firstResult();
    }
}
