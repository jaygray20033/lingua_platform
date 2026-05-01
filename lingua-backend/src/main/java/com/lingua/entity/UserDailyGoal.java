package com.lingua.entity;

import io.quarkus.hibernate.orm.panache.PanacheEntityBase;
import jakarta.persistence.*;
import java.time.LocalDateTime;

@Entity
@Table(name = "user_daily_goals")
public class UserDailyGoal extends PanacheEntityBase {

    @Id
    @Column(name = "user_id")
    public Long userId;

    @Column(name = "daily_xp_goal")
    public Integer dailyXpGoal = 20;

    @Column(name = "updated_at")
    public LocalDateTime updatedAt = LocalDateTime.now();

    public static UserDailyGoal findByUser(Long userId) {
        return findById(userId);
    }
}
