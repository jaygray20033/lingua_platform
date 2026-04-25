package com.lingua.entity;

import io.quarkus.hibernate.orm.panache.PanacheEntityBase;
import jakarta.persistence.*;
import java.util.List;

@Entity
@Table(name = "lessons")
public class Lesson extends PanacheEntityBase {
    @Id @GeneratedValue(strategy = GenerationType.IDENTITY)
    public Long id;
    @Column(name = "unit_id") public Long unitId;
    @Column(name = "order_index") public Integer orderIndex;
    public String title;
    @Enumerated(EnumType.STRING) public LessonType type = LessonType.NORMAL;
    @Column(name = "xp_reward") public Integer xpReward = 15;
    @Column(name = "heart_cost_per_error") public Integer heartCostPerError = 1;
    @Column(name = "exercise_count") public Integer exerciseCount = 10;

    public enum LessonType { NORMAL, STORY, CHECKPOINT, LEGENDARY }

    public static List<Lesson> findByUnit(Long unitId) {
        return list("unitId = ?1 order by orderIndex", unitId);
    }
}
