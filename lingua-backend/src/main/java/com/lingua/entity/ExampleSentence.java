package com.lingua.entity;

import io.quarkus.hibernate.orm.panache.PanacheEntityBase;
import jakarta.persistence.*;
import java.time.LocalDateTime;
import java.util.List;

@Entity
@Table(name = "example_sentences")
public class ExampleSentence extends PanacheEntityBase {
    @Id @GeneratedValue(strategy = GenerationType.IDENTITY)
    public Long id;

    @Column(name = "word_id", nullable = false) public Long wordId;
    @Column(nullable = false, length = 500) public String sentence;
    @Column(length = 500) public String reading;
    @Column(name = "translation_vi", nullable = false, length = 500) public String translationVi;
    @Column(name = "translation_en", length = 500) public String translationEn;
    @Column(name = "audio_url", length = 500) public String audioUrl;
    public String difficulty;
    @Column(name = "sort_order") public Integer sortOrder = 0;
    @Column(name = "created_at") public LocalDateTime createdAt;

    public static List<ExampleSentence> findByWord(Long wordId) {
        return list("wordId = ?1 order by sortOrder asc, id asc", wordId);
    }

    public static List<ExampleSentence> findTopForWord(Long wordId, int limit) {
        return find("wordId = ?1 order by sortOrder asc, id asc", wordId)
            .page(0, Math.max(1, Math.min(limit, 10)))
            .list();
    }
}
