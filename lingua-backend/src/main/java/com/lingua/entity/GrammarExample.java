package com.lingua.entity;

import io.quarkus.hibernate.orm.panache.PanacheEntityBase;
import jakarta.persistence.*;
import java.util.List;

@Entity
@Table(name = "grammar_examples")
public class GrammarExample extends PanacheEntityBase {
    @Id @GeneratedValue(strategy = GenerationType.IDENTITY)
    public Long id;
    @Column(name = "grammar_id") public Long grammarId;
    public String sentence;
    public String reading;
    public String romaji;
    @Column(name = "translation_vi") public String translationVi;
    @Column(name = "translation_en") public String translationEn;
    public String note;
    @Column(name = "audio_url") public String audioUrl;
    @Column(name = "order_index") public Integer orderIndex;

    public static List<GrammarExample> findByGrammar(Long grammarId) {
        return list("grammarId = ?1 order by orderIndex, id", grammarId);
    }
}
