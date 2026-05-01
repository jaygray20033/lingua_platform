package com.lingua.entity;

import io.quarkus.hibernate.orm.panache.PanacheEntityBase;
import jakarta.persistence.*;
import java.util.List;

@Entity
@Table(name = "grammars")
public class Grammar extends PanacheEntityBase {
    @Id @GeneratedValue(strategy = GenerationType.IDENTITY)
    public Long id;
    @Column(name = "language_id") public Long languageId;
    public String pattern;
    @Column(name = "meaning_vi") public String meaningVi;
    @Column(name = "meaning_en") public String meaningEn;
    public String structure;
    @Column(name = "jlpt_level") public String jlptLevel;
    @Column(name = "cefr_level") public String cefrLevel;
    @Column(name = "hsk_level") public String hskLevel;
    @Column(name = "example_sentence") public String exampleSentence;
    @Column(name = "example_translation") public String exampleTranslation;
    public String note;

    @Column(name = "explanation_vi", columnDefinition = "LONGTEXT") public String explanationVi;
    @Column(name = "explanation_en", columnDefinition = "LONGTEXT") public String explanationEn;
    public String formation;
    @Column(name = "usage_context") public String usageContext;
    @Column(name = "common_mistakes") public String commonMistakes;
    @Column(name = "related_patterns") public String relatedPatterns;
    @Column(name = "difficulty_score") public Integer difficultyScore;
    @Column(name = "audio_url") public String audioUrl;

    public static List<Grammar> findByLanguageAndLevel(Long langId, String level) {
        return list("languageId = ?1 and (jlptLevel = ?2 or cefrLevel = ?2 or hskLevel = ?2)", langId, level);
    }
}
