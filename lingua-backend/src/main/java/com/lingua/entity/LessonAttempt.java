package com.lingua.entity;

import io.quarkus.hibernate.orm.panache.PanacheEntityBase;
import jakarta.persistence.*;
import java.time.LocalDateTime;

@Entity
@Table(name = "lesson_attempts")
public class LessonAttempt extends PanacheEntityBase {
    @Id @GeneratedValue(strategy = GenerationType.IDENTITY)
    public Long id;
    @Column(name = "user_id") public Long userId;
    @Column(name = "lesson_id") public Long lessonId;
    @Enumerated(EnumType.STRING) public AttemptStatus status = AttemptStatus.IN_PROGRESS;
    @Column(name = "score_percent") public Double scorePercent = 0.0;
    @Column(name = "xp_earned") public Integer xpEarned = 0;
    @Column(name = "hearts_lost") public Integer heartsLost = 0;
    @Column(name = "duration_sec") public Integer durationSec = 0;
    @Column(name = "started_at") public LocalDateTime startedAt = LocalDateTime.now();
    @Column(name = "completed_at") public LocalDateTime completedAt;

    public enum AttemptStatus { IN_PROGRESS, COMPLETED, ABANDONED }
}
