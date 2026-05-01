package com.lingua.entity;

import io.quarkus.hibernate.orm.panache.PanacheEntityBase;
import jakarta.persistence.*;
import java.time.LocalDate;
import java.time.LocalDateTime;

@Entity
@Table(name = "user_gamification")
public class UserGamification extends PanacheEntityBase {
    @Id
    @Column(name = "user_id")
    public Long userId;

    @Column(name = "total_xp") public Long totalXp = 0L;
    public Integer level = 1;
    public Integer gems = 50;
    public Integer hearts = 5;

    @Column(name = "hearts_updated_at")
    public LocalDateTime heartsUpdatedAt = LocalDateTime.now();

    @Column(name = "streak_count") public Integer streakCount = 0;
    @Column(name = "longest_streak") public Integer longestStreak = 0;
    @Column(name = "last_streak_date") public LocalDate lastStreakDate;
    @Column(name = "streak_freeze_count") public Integer streakFreezeCount = 0;

    public static UserGamification findByUser(Long userId) {
        return findById(userId);
    }
}
