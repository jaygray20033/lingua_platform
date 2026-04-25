package com.lingua.entity;

import io.quarkus.hibernate.orm.panache.PanacheEntityBase;
import jakarta.persistence.*;
import java.util.List;

@Entity
@Table(name = "mock_test_questions")
public class MockTestQuestion extends PanacheEntityBase {
    @Id @GeneratedValue(strategy = GenerationType.IDENTITY)
    public Long id;
    @Column(name = "mock_test_id") public Long mockTestId;
    public String section;
    @Column(name = "question_json", columnDefinition = "JSON") public String questionJson;
    @Column(name = "answer_json", columnDefinition = "JSON") public String answerJson;
    public Integer difficulty;
    @Column(name = "order_index") public Integer orderIndex;

    public static List<MockTestQuestion> findByTest(Long testId) {
        return list("mockTestId = ?1 order by section, orderIndex", testId);
    }
}
