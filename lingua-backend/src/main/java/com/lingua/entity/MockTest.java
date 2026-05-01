package com.lingua.entity;

import io.quarkus.hibernate.orm.panache.PanacheEntityBase;
import jakarta.persistence.*;
import java.util.List;

@Entity
@Table(name = "mock_tests")
public class MockTest extends PanacheEntityBase {
    @Id @GeneratedValue(strategy = GenerationType.IDENTITY)
    public Long id;
    @Column(name = "course_id") public Long courseId;
    public String certification;
    @Column(name = "level_code") public String levelCode;
    public String title;
    @Column(name = "total_duration_min") public Integer totalDurationMin;
    @Column(name = "pass_score") public Integer passScore;
    @Column(name = "section_config_json", columnDefinition = "JSON") public String sectionConfigJson;

    public static List<MockTest> findByCert(String cert, String level) {
        if (level != null) return list("certification = ?1 and levelCode = ?2", cert, level);
        return list("certification", cert);
    }
}
