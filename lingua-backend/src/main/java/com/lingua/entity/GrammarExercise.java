package com.lingua.entity;

import io.quarkus.hibernate.orm.panache.PanacheEntityBase;
import jakarta.persistence.*;
import java.util.List;

@Entity
@Table(name = "grammar_exercises")
public class GrammarExercise extends PanacheEntityBase {
    @Id @GeneratedValue(strategy = GenerationType.IDENTITY)
    public Long id;
    @Column(name = "grammar_id") public Long grammarId;
    public String type;
    @Column(name = "question_json", columnDefinition = "JSON") public String questionJson;
    @Column(name = "answer_json", columnDefinition = "JSON") public String answerJson;
    public String explanation;
    public Integer difficulty;
    @Column(name = "order_index") public Integer orderIndex;

    public static List<GrammarExercise> findByGrammar(Long grammarId) {
        return list("grammarId = ?1 order by orderIndex, id", grammarId);
    }
}
