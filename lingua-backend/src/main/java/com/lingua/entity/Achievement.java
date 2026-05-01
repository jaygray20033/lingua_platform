package com.lingua.entity;

import io.quarkus.hibernate.orm.panache.PanacheEntityBase;
import jakarta.persistence.*;

@Entity
@Table(name = "achievements")
public class Achievement extends PanacheEntityBase {
    @Id @GeneratedValue(strategy = GenerationType.IDENTITY)
    public Long id;
    public String code;
    public String title;
    public String description;
    @Column(name = "icon_url") public String iconUrl;
    public String rarity;

    @Column(name = "trigger_rule", columnDefinition = "JSON") public String triggerRule;

    public static Achievement findByCode(String code) {
        return find("code", code).firstResult();
    }
}
