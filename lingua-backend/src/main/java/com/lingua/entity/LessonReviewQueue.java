package com.lingua.entity;

import io.quarkus.hibernate.orm.panache.PanacheEntityBase;
import jakarta.persistence.*;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;

@Entity
@Table(name = "lesson_review_queue")
public class LessonReviewQueue extends PanacheEntityBase {
    @Id @GeneratedValue(strategy = GenerationType.IDENTITY)
    public Long id;

    @Column(name = "user_id", nullable = false)   public Long userId;
    @Column(name = "lesson_id", nullable = false) public Long lessonId;
    @Column(name = "last_score") public Double lastScore = 0.0;
    @Column(name = "fail_count") public Integer failCount = 1;
    @Column(name = "review_after", nullable = false) public LocalDate reviewAfter;
    @Column(name = "last_failed_at") public LocalDateTime lastFailedAt;
    public Boolean resolved = false;
    @Column(name = "resolved_at") public LocalDateTime resolvedAt;

    public static LessonReviewQueue findByUserAndLesson(Long userId, Long lessonId) {
        return find("userId = ?1 and lessonId = ?2", userId, lessonId).firstResult();
    }

    public static List<LessonReviewQueue> pendingForUser(Long userId) {
        return list(
            "userId = ?1 and resolved = false and reviewAfter <= ?2 order by reviewAfter asc, lastFailedAt desc",
            userId, LocalDate.now()
        );
    }

    public static long countPending(Long userId) {
        return count("userId = ?1 and resolved = false and reviewAfter <= ?2", userId, LocalDate.now());
    }
}
