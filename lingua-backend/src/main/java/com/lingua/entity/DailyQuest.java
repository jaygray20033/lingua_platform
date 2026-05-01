package com.lingua.entity;

import io.quarkus.hibernate.orm.panache.PanacheEntityBase;
import jakarta.persistence.*;
import java.time.LocalDate;
import java.util.List;

@Entity
@Table(name = "daily_quests")
public class DailyQuest extends PanacheEntityBase {
    @Id @GeneratedValue(strategy = GenerationType.IDENTITY)
    public Long id;

    @Column(name = "user_id", nullable = false) public Long userId;
    @Column(name = "quest_code", nullable = false, length = 100) public String questCode;
    @Column(name = "template_id") public Long templateId;
    public String description;
    public Integer target = 1;
    public Integer progress = 0;
    @Column(name = "reward_gems") public Integer rewardGems = 5;
    @Column(name = "reward_xp") public Integer rewardXp = 5;
    public Boolean completed = false;
    public Boolean claimed = false;
    @Column(name = "quest_date", nullable = false) public LocalDate questDate;

    public static List<DailyQuest> findForDate(Long userId, LocalDate date) {
        return list("userId = ?1 and questDate = ?2", userId, date);
    }

    public static DailyQuest findOneByCode(Long userId, LocalDate date, String code) {
        return find("userId = ?1 and questDate = ?2 and questCode = ?3", userId, date, code).firstResult();
    }
}
