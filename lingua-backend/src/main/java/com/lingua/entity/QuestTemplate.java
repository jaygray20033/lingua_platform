package com.lingua.entity;

import io.quarkus.hibernate.orm.panache.PanacheEntityBase;
import jakarta.persistence.*;
import java.util.List;

@Entity
@Table(name = "quest_templates")
public class QuestTemplate extends PanacheEntityBase {
    @Id @GeneratedValue(strategy = GenerationType.IDENTITY)
    public Long id;

    @Column(unique = true, nullable = false, length = 80)
    public String code;
    public String title;
    public String description;
    public String category;
    @Column(name = "target_count") public Integer targetCount = 1;
    @Column(name = "reward_xp") public Integer rewardXp = 5;
    @Column(name = "reward_gems") public Integer rewardGems = 5;
    public String icon;
    public Boolean enabled = true;

    public static List<QuestTemplate> findEnabled() {
        return list("enabled", true);
    }
}
