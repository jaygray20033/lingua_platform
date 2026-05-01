package com.lingua.entity;

import io.quarkus.hibernate.orm.panache.PanacheEntityBase;
import jakarta.persistence.*;
import java.util.List;

@Entity
@Table(name = "units")
public class Unit extends PanacheEntityBase {
    @Id @GeneratedValue(strategy = GenerationType.IDENTITY)
    public Long id;
    @Column(name = "section_id") public Long sectionId;
    @Column(name = "order_index") public Integer orderIndex;
    public String title;
    @Column(name = "communication_goal") public String communicationGoal;
    public String icon;
    @Column(name = "xp_reward") public Integer xpReward = 50;

    public static List<Unit> findBySection(Long sectionId) {
        return list("sectionId = ?1 order by orderIndex", sectionId);
    }
}
