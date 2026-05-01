package com.lingua.entity;

import io.quarkus.hibernate.orm.panache.PanacheEntityBase;
import jakarta.persistence.*;
import java.util.List;

@Entity
@Table(name = "word_meanings")
public class WordMeaning extends PanacheEntityBase {
    @Id @GeneratedValue(strategy = GenerationType.IDENTITY)
    public Long id;
    @Column(name = "word_id") public Long wordId;
    @Column(name = "translation_lang_id") public Long translationLangId;
    public String meaning;
    @Column(name = "example_sentence") public String exampleSentence;
    @Column(name = "example_translation") public String exampleTranslation;

    public static List<WordMeaning> findByWord(Long wordId) {
        return list("wordId", wordId);
    }
}
