package com.lingua.entity;

import io.quarkus.hibernate.orm.panache.PanacheEntityBase;
import jakarta.persistence.*;
import java.util.List;

@Entity
@Table(name = "words")
public class Word extends PanacheEntityBase {
    @Id @GeneratedValue(strategy = GenerationType.IDENTITY)
    public Long id;
    @Column(name = "language_id") public Long languageId;
    public String text;
    public String reading;
    public String romaji;
    public String pos;
    @Column(name = "jlpt_level") public String jlptLevel;
    @Column(name = "topik_level") public String topikLevel;
    @Column(name = "cefr_level") public String cefrLevel;
    @Column(name = "hsk_level") public String hskLevel;
    @Column(name = "audio_url") public String audioUrl;
    @Column(name = "frequency_rank") public Integer frequencyRank;

    public static List<Word> findByLanguageAndLevel(Long langId, String level) {
        return list("languageId = ?1 and (jlptLevel = ?2 or cefrLevel = ?2 or hskLevel = ?2)", langId, level);
    }

    public static List<Word> search(String query) {
        return list("text like ?1 or reading like ?1 or romaji like ?1", "%" + query + "%");
    }
}
