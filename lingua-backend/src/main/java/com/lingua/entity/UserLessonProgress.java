package com.lingua.entity;

import io.quarkus.hibernate.orm.panache.PanacheEntityBase;
import jakarta.persistence.*;
import java.time.LocalDateTime;

@Entity
@Table(name = "user_lesson_progress")
public class UserLessonProgress extends PanacheEntityBase {
    @Id @GeneratedValue(strategy = GenerationType.IDENTITY)
    public Long id;
    @Column(name = "user_id") public Long userId;
    @Column(name = "lesson_id") public Long lessonId;
    @Column(name = "completion_count") public Integer completionCount = 0;
    @Column(name = "best_score") public Double bestScore = 0.0;
    @Column(name = "is_legendary") public Boolean isLegendary = false;
    @Column(name = "last_completed_at") public LocalDateTime lastCompletedAt;

    public static UserLessonProgress findByUserAndLesson(Long userId, Long lessonId) {
        return find("userId = ?1 and lessonId = ?2", userId, lessonId).firstResult();
    }
}
