package com.lingua.entity;

import io.quarkus.hibernate.orm.panache.PanacheEntityBase;
import jakarta.persistence.*;
import java.util.List;

@Entity
@Table(name = "characters_table")
public class CharacterEntity extends PanacheEntityBase {
    @Id @GeneratedValue(strategy = GenerationType.IDENTITY)
    public Long id;
    @Column(name = "language_id") public Long languageId;
    @Column(name = "character_text") public String characterText;
    @Column(name = "stroke_count") public Integer strokeCount;
    @Column(name = "jlpt_level") public String jlptLevel;
    @Column(name = "frequency_rank") public Integer frequencyRank;
    @Column(name = "meaning_vi") public String meaningVi;
    @Column(name = "meaning_en") public String meaningEn;
    @Column(name = "on_reading") public String onReading;
    @Column(name = "kun_reading") public String kunReading;
    @Column(name = "han_viet") public String hanViet;
    @Column(name = "mnemonic_text") public String mnemonicText;

    public static List<CharacterEntity> findByLevel(String level) {
        return list("jlptLevel = ?1 order by frequencyRank", level);
    }

    public static CharacterEntity findByChar(String c) {
        return find("characterText", c).firstResult();
    }
}
