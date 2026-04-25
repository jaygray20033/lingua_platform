package com.lingua.entity;

import io.quarkus.hibernate.orm.panache.PanacheEntityBase;
import jakarta.persistence.*;
import java.time.LocalDateTime;
import java.util.List;

@Entity
@Table(name = "flashcard_reviews")
public class FlashcardReview extends PanacheEntityBase {
    @Id @GeneratedValue(strategy = GenerationType.IDENTITY)
    public Long id;
    @Column(name = "user_id") public Long userId;
    @Column(name = "card_id") public Long cardId;
    @Enumerated(EnumType.STRING) public SRSState state = SRSState.NEW;
    @Column(name = "ease_factor") public Double easeFactor = 2.5;
    @Column(name = "interval_days") public Integer intervalDays = 0;
    public Integer repetitions = 0;
    public Integer lapses = 0;
    @Column(name = "next_review_at") public LocalDateTime nextReviewAt = LocalDateTime.now();
    @Column(name = "last_reviewed_at") public LocalDateTime lastReviewedAt;

    public enum SRSState { NEW, LEARNING, REVIEW, RELEARNING, SUSPENDED }

    public static List<FlashcardReview> findDue(Long userId, int limit) {
        return list("userId = ?1 and state != 'SUSPENDED' and nextReviewAt <= ?2 order by nextReviewAt",
            userId, LocalDateTime.now());
    }
}
