package com.lingua.entity;

import io.quarkus.hibernate.orm.panache.PanacheEntityBase;
import jakarta.persistence.*;

@Entity
@Table(name = "languages")
public class Language extends PanacheEntityBase {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    public Long id;

    @Column(unique = true, nullable = false)
    public String code;

    public String name;

    @Column(name = "native_name")
    public String nativeName;

    @Column(name = "flag_emoji")
    public String flagEmoji;

    public String direction = "LTR";

    public static Language findByCode(String code) {
        return find("code", code).firstResult();
    }
}
